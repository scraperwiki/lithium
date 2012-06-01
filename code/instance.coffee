#
# Instance interface.
spawn         = require('child_process').spawn
net           = require 'net'

_             = require 'underscore'

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

  # Run a shell command as root on the server.
  sh: (command, callbacks) ->
    @_ssh LithiumConfig.sshkey_private, command, callbacks

  # Copy files to the instance
  cp: (files, callbacks) ->
    @_scp LithiumConfig.sshkey_private, files, callbacks

  # Copy & run hooks on instance
  # TODO: coupled
  run_hooks: ->
    callbacks =
      stdout: (data) -> console.log data
      stderr: (data) -> console.log data
      exit: (code) -> console.log code

    files_to_cp = _.map @config.hooks, (hook) =>
      "classes/#{@config.name}/hooks/#{hook}" if /\d+_.+\.r\..+/.test hook

    @cp files_to_cp, callbacks
    _.each @config.hooks, (hook) =>
      if /\d+_.+\.r\..+/.test hook
        @sh "sh /root/#{hook}", callbacks
      if /\d+_.+\.l\..+/.test hook
        @_local_sh "sh classes/#{@config.name}/#{hook}", callbacks

  #### Private methods ####

  # Connect via SSH and execute command
  _ssh: (key, command, callbacks) ->
    @_wait_for_sshd()
    args = [
      '-o', 'LogLevel=ERROR', '-o', 'UserKnownHostsFile=/dev/null', '-o', 'StrictHostKeyChecking=no', '-i', key, "root@#{@ip_address}"]
    args = args.concat(command.split ' ')

    ssh = spawn 'ssh', args
    ssh.stdout.on 'data', callbacks.stdout
    ssh.stderr.on 'data', callbacks.stderr
    ssh.on 'exit', callbacks.exit

  # Copy files via SCP
  # TODO: factor out into SSH & SCP class
  _scp: (key, files, callbacks) ->
    @_wait_for_sshd()
    args = [
      '-o', 'LogLevel=ERROR', '-o', 'UserKnownHostsFile=/dev/null', '-o', 'StrictHostKeyChecking=no', '-i', key ]
    args = args.concat files
    args.push "root@#{@ip_address}:/root"

    ssh = spawn 'scp', args
    ssh.stdout.on 'data', callbacks.stdout
    ssh.stderr.on 'data', callbacks.stderr
    ssh.on 'exit', callbacks.exit

  # Wait until we can connect to port 22 of instance
  _wait_for_sshd: ->
    f = =>
        client = net.connect 22, @ip_address, ->
          setTimeout ->
            clearInterval int
          , 3000
        client._handle.socket.destroy()

    int = setInterval f, 1000

  # Spawn a command locally
  # TODO: put somewhere more sane
  _local_sh: (command, callbacks) ->
    cmd = spawn 'sh', command.split ' '
    cmd.stdout.on 'data', callbacks.stdout
    cmd.stderr.on 'data', callbacks.stderr
    cmd.on 'exit', callbacks.exit
