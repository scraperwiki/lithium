#
# Instance interface.
spawn         = require('child_process').spawn

cf            = require 'config'
LithiumConfig = require('lithium_config').LithiumConfig

exports.Instance = class Instance
  constructor: (config, id, name, state, ip) ->
    @config = new cf.Config config if config?
    @id = id if id?
    @name = name if name?
    @state = state if state?
    @ip_address = ip if ip?

  # Create a server ready to run. Somewhere on the internet.
  # Servers are created in the "stopped" state.
  @create: (config, callback) ->
    @config = new cf.Config config

  # Destroy a previously created server.
  @destroy: (instance, callback) ->

  # List instances in the cloud
  @list: (callback) ->

  # Start the server. Immediately go into the 'starting' state,
  # and if everything goes okay, then sometime later it will be
  # in the 'running' state.
  start: (callback) ->

  # Stop the server. Immediately go into the 'stopping' state,
  # and if everything goes okay, then sometime later it will be
  # in the 'stopped' state.
  stop: (callback) ->

  # Return the state of the server.  Will be one of:
  # 'stopped', 'running', 'starting', 'stopping', and probably
  # others.
  state: (callback) ->

  # Run a shell command as root on the server. Return stdout.
  # Throw stderr as an error on nonzero exit.
  sh: (command, callbacks) ->
    @_ssh LithiumConfig.sshkey_private, command, callbacks

  # Connect via SSH and execute command
  _ssh: (key, command, callbacks) ->
    args = [
      '-o', 'LogLevel=ERROR', '-o', 'UserKnownHostsFile=/dev/null', '-o', 'StrictHostKeyChecking=no', '-i', key, "root@#{@ip_address}"]
    args = args.concat(command.split ' ')

    ssh = spawn 'ssh', args
    ssh.stdout.on 'data', callbacks.stdout
    ssh.stderr.on 'data', callbacks.stderr
    ssh.on 'exit', callbacks.exit
