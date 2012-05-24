#
# Instance interface.
cf     = require 'config'

exports.Instance = class Instance
  constructor: (config) ->
    @config = new cf.Config config

  # Create a server ready to run. Somewhere on the internet.
  # Servers are created in the "stopped" state.
  @create: (config) ->

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

  # Run a shell command as root on the server.
  # This is useful for testing, but I don't know whether we'll
  # want it in production.
  # Does this background it and return the process id?
  # (We'd have another command for retrieving stdout and stderr.)
  # Or does this return a list of [stdout, stderr] ?
  # (That would be convenient.)
  # I'll assume the latter for now.
  sh: -> (command) ->
