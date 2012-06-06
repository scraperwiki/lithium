# linode.coffee
# ScraperWiki Limited.  2012.

LinodeClient = (require 'linode-api').LinodeClient
_            = require('underscore')
_s           = require('underscore.string')

LithiumConfig = (require 'lithium_config').LithiumConfig
Instance      = (require 'instance').Instance

exports.Linode = class Linode extends Instance
  api_key = process.env['LINODE_API_KEY']
  api_key = 'fakeapikey' if not api_key?

  client = new LinodeClient api_key

  @create: (config, callback) ->
    super config

    @_get_plan @config.ram, @config.disk_size, (plan) =>
      @_linode_create plan, callback

  @destroy: (name, callback) ->
    @get name, (instance) ->
      client.call 'linode.delete',
         'LinodeID': instance.id
         'skipChecks': true
         , (err, res) ->
           callback()

  # Returns (by passing to the *callback* function) the arguments (err, res) where *err*
  # is a error, and *res* is an array of instances.
  @list: (callback) ->
    client.call 'linode.list', null, (err, res) =>
      list = _.map res, (l) =>
        o = {name: l['LABEL'], state: l['STATUS'], id: l['LINODEID']}
        # disgusting magic value
        new Linode 'linode_custom_kernel', o.id, o.name, o.state
      @amap ((x, cb) =>
        @_get_ip x.id, (ip) => x.ip_address = ip; cb x),
        list, (x) -> callback err, x

  # Returns an instance given its name.
  @get: (name, callback) ->
    @list (err, list) ->
      k = _.find list, (n) ->
        n.name == name
      callback k

  start: (callback) ->
    client.call 'linode.boot',
      'LinodeID': @id
      , (err, res) ->
        callback()

  stop: (callback) ->
    client.call 'linode.shutdown',
      'LinodeID': @id
      , (err, res) ->
        callback()

  restart: (callback) ->
    client.call 'linode.reboot',
      'LinodeID': @id
      , (err, res) ->
        callback()

  ###

  Only Private Methods Below Here

  ###

  # Private method to create a linode from a plan.  Called from
  # @create; this does most of the actual work.
  @_linode_create: (plan_id, callback) =>
    client.call 'linode.create',
      'DatacenterID': 7
      'PlanID': plan_id
      'PaymentTerm': 1
    , (err, res) =>
      update_linode_label err, res

    update_linode_label = (err, res) =>
      @linode_id = res['LinodeID']
      client.call 'linode.update',
        'LinodeID': @linode_id
        'Label': @config.name
        , have_updated

    have_updated = (err, res) =>
      @_get_distro @config.distribution, create_disk

    create_disk = (id) =>
      client.call 'linode.disk.createfromdistribution',
        'LinodeID': @linode_id
        'DistributionID': id
        'Label': 'system'
        'Size': @config.disk_size * 1000 # magic for now
        'rootPass': 'r00ter' # magic for now
        'rootSSHKey': LithiumConfig.sshkey_public()
        , disk_created

    disk_created = (err, res) =>
      @disk_id = res['DiskID']
      @_get_kernel @config.kernel, create_linode_config
    
    create_linode_config = (kernel_id) =>
      client.call 'linode.config.create',
        'LinodeID': @linode_id
        'KernelID': kernel_id
        'Label': @config.name
        'Comments': @config.description
        'DiskList': @disk_id
        'RootDeviceNum': 1
        , callback

  # Takes RAM as MB and disk as GB.
  @_get_plan: (ram, disk, callback) ->
    client.call 'avail.LinodePlans', null, (err, res) ->
      p =  _.find res, (plan) ->
        plan['DISK'] == disk and plan['RAM'] == ram
      callback p['PLANID']

  @_get_distro: (name, callback) ->
    client.call 'avail.distributions', null, (err, res) ->
      d = _.find res, (distro) ->
        distro['LABEL'] == name
      callback d['DISTRIBUTIONID']

  @_get_kernel: (version, callback) ->
    client.call 'avail.kernels', null, (err, res) ->
      k = _.find res, (kernel) ->
        _s.contains kernel['LABEL'], version
      callback k['KERNELID']

  @_get_ip: (linode_id, callback) ->
   client.call 'linode.ip.list',
     'LinodeID': linode_id
     , (err, res) ->
       callback res[0]['IPADDRESS']

  @amap: (f,l,cb,r) =>
    if l.length == 0
      cb r
    else
      f l[0], (x) =>
        @amap f, l[1..], cb, (if !r? then [] else r).concat [x]
