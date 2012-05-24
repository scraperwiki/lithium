_       = require 'underscore'

Instance = (require 'instance').Instance

exports.Placebo = class Placebo extends Instance
  @instances: []

  @create: (config) ->
    instance = new Placebo config
    @instances.push instance
    instance

  @destroy: (instance) ->
    @instances.pop instance

  # List instances in the cloud
  @list: ->
    _.clone @instances

  start: ->

  stop: ->

  state: ->

