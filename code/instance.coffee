#
# Instance interface.
cf     = require 'config'

exports.Instance = class Instance
  constructor: (config, id, name, state) ->
    @config = new cf.Config config if config?
    @id = id if id?
    @name = name if name?
    @state = state if state?

  # Create a server ready to run. Somewhere on the internet.
  # Servers are created in the "stopped" state.
  @create: (config) ->
    @config = new cf.Config config

  # Destroy a previously created server.
  @destroy: (instance) ->

  # List instances in the cloud
  @list: ->

  # Start the server. Immediately go into the 'starting' state,
  # and if everything goes okay, then sometime later it will be
  # in the 'running' state.
  start: ->

  # Stop the server. Immediately go into the 'stopping' state,
  # and if everything goes okay, then sometime later it will be
  # in the 'stopped' state.
  stop: ->

  # Return the state of the server.  Will be one of:
  # 'stopped', 'running', 'starting', 'stopping', and probably
  # others.
  state: ->

  # Run a shell command as root on the server. Return stdout.
  # Throw stderr as an error on nonzero exit.
  sh: -> (command) ->
