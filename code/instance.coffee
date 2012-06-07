#
# Instance interface.
spawn         = require('child_process').spawn
net           = require 'net'

_             = require 'underscore'
async         = require 'async'

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

  # Get an instance by name
  @get: (name, callback) ->

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
  sh: (command, callback) ->
    @_ssh LithiumConfig.sshkey_private, command, callback

  # Copy files to the instance
  cp: (files, callback) ->
    if files.length > 0
      @_scp LithiumConfig.sshkey_private, files, callback
    else callback

  # Copy & run hooks on instance
  # TODO: coupled
  # TODO: we don't actually test this
  run_hooks: (callback) ->
    c = @config
    all_parents = while c.parent?
      c = c.parent

    configs = all_parents.concat @config
    async.forEachSeries configs, @run_config_hooks, callback

  run_config_hooks: (config, callback) =>
    files_to_cp = _.select config.hooks, (hook) ->
      /^\d+_.+\.r\.\w/.test hook

    files_to_cp = _.map files_to_cp, (f) =>
      "class/#{config.name}/hooks/#{f}"
    @cp files_to_cp, (exit_code) =>
      return if exit_code > 0

    async.forEachSeries config.hooks, @_call_hook, callback


  #### Private methods ####

  _call_hook: (hook, callback) =>
    console.log "Running #{hook}"
    if /^\d+_.+\.r\.\w/.test hook
      @sh "sh /root/#{hook}", callback
    if /^\d+_.+\.l\.\w/.test hook
      # won't work properly
      @_local_sh "class/#{@config.name}/hooks/#{hook}", callback

  # Connect via SSH and execute command
  # TODO: proper callbacks?
  _ssh: (key, command, callback) ->
    @_wait_for_sshd()
    args = [
      '-o', 'LogLevel=ERROR', '-o', 'UserKnownHostsFile=/dev/null', '-o', 'StrictHostKeyChecking=no', '-i', key, "root@#{@ip_address}"]
    args = args.concat(command.split ' ')

    ssh = spawn 'ssh', args
    ssh.stdout.on 'data', (data) -> console.log 'ssh: ' + data.toString('ascii')
    ssh.stderr.on 'data', (data) -> console.log 'ssh: ' + data.toString('ascii')
    ssh.on 'exit', callback

  # Copy files via SCP
  # TODO: factor out into SSH & SCP class, proper callbacks?
  _scp: (key, files, callback) ->
    @_wait_for_sshd()
    args = [
      '-o', 'LogLevel=ERROR', '-o', 'UserKnownHostsFile=/dev/null', '-o', 'StrictHostKeyChecking=no', '-i', key ]
    args = args.concat files
    args.push "root@#{@ip_address}:/root"

    ssh = spawn 'scp', args
    ssh.stdout.on 'data', (data) -> console.log data.toString('ascii')
    ssh.stderr.on 'data', (data) -> console.log data.toString('ascii')
    ssh.on 'exit', callback

  # Wait until we can connect to port 22 of instance
  _wait_for_sshd: ->
    f = =>
        client = net.connect 22, @ip_address, ->
          setTimeout ->
            clearInterval int
          , 3000
        client._handle.socket.destroy()

    int = setInterval f, 1000

  # Spawn a command locally, needs to be executable
  # TODO: put somewhere more sane, name it properly: exec?
  _local_sh: (command, callback) ->
    cmd = spawn command, []
    cmd.stdout.on 'data', (data) -> console.log data.toString('ascii')
    cmd.stderr.on 'data', (data) -> console.log data.toString('ascii')
    cmd.on 'exit', callback

  _all_hooks: ->
    c = @config
    all_parent_hooks = while c.parent?
      c = c.parent
      c.hooks
    _.flatten all_parent_hooks.concat @config.hooks
