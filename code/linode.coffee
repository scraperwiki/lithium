LinodeClient = (require 'linode-api').LinodeClient
_            = require('underscore')

Instance = (require 'instance').Instance

exports.Linode = class Linode extends Instance
  client = new LinodeClient 'fakeapikey'

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
