LinodeClient = (require 'linode-api').LinodeClient
_            = require('underscore')
_s           = require('underscore.string')

Instance = (require 'instance').Instance

exports.Linode = class Linode extends Instance
  api_key = process.env['LINODE_API_KEY']
  api_key = 'fakeapikey' if not api_key?

  client = new LinodeClient api_key

  @create: (config, callback) ->
    super config
    @_get_plan @config.ram, @config.disk_size, (plan_id) =>
      client.call 'linode.create',
        'DatacenterID': 7
        'PlanID': plan_id
        'PaymentTerm': 1
      , (err, res) =>
        @linode_id = res['LinodeID']
        client.call 'linode.update',
          'LinodeID': @linode_id
          'Label': @config.name
          , (err, res) =>
            @_get_distro @config.distribution, (id) =>
              client.call 'linode.disk.createfromdistribution',
                'LinodeID': @linode_id
                'DistributionID': id
                'Label': 'system'
                'Size': @config.disk_size * 1000 # magic for now
                'rootPass': 'r00ter' # magic for now
                , (err, res) =>
                  @disk_id = res['DiskID']
                  @_get_kernel @config.kernel, (id) =>
                    client.call 'linode.config.create',
                      'LinodeID': @linode_id
                      'KernelID': id
                      'Label': @config.name
                      'Comments': @config.description
                      'DiskList': @disk_id
                      'RootDeviceNum': 1
                      , (err, res) =>
                        callback()


  # Takes RAM as MB and disk as GB
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

  # Returns an array of instances, status should be a string?
  @_list: (callback) ->
    client.call 'linode.list', null, (err, res) ->
      callback _.map res, (l) ->
        {name: l['LABEL'], state: l['STATUS'], id: l['LINODEID']}
