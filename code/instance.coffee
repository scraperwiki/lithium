# Instance interface.
spawn         = require('child_process').spawn
fs            = require 'fs'
net           = require 'net'

_             = require 'underscore'
async         = require 'async'
# https://github.com/jprichardson/node-kexec
kexec         = require 'kexec'

cf            = require 'config'
settings      = require 'settings'

class Instance

  constructor: (config, id, name, state, ip) ->
    @config = new cf.Config config if config?
    @id = id if id?
    @name = name if name?
    @state = state if state?
    @ip_address = ip if ip?

  # Create a server ready to run. Somewhere on the internet.  # Servers are created in the "stopped" state.
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
  # *command* is a list (of strings).
  sh: (command, callback) ->
    @_ssh settings.sshkey_private, command, callback

  # Login interactively, using SSH.
  ssh: (username) ->
    key = settings.sshkey_private
    args = _common_ssh_args key
    extra = ["#{username}@#{@ip_address}"]
    args = args.concat extra
    cmd = (['ssh'].concat args).join ' '
    kexec cmd

  # Copy files to the instance
  cp: (files, callback) ->
    if files.length > 0
      @_scp settings.sshkey_private, files, callback
    else callback

  # Copy entire tree of files to the instance.
  # All the files will be copied relative to the directory you
  # pass in.  The copy starts by 'cd'ing (in a subshell) into
  # the directory you pass as the argument (and scp -r the
  # files).  Consequently, the files retain their relative position.
  # So if you pass in /opt/sun/foobar and there is a
  # file /opt/sun/foobar/snack/wozzle then it will get copied
  # as snack/wozzle (ending up in ~/snack/wozzle where ~ is the
  # home directory on the remote machine).
  cpdir: (dir, callback) ->
    @_scp settings.sshkey_private, [dir+'/.'], callback, true

  # Copy & run hooks on instance
  # TODO: coupled
  # TODO: we don't actually test this
  run_hooks: (callback) ->
    c = @config
    all_parents = while c.parent?
      c = c.parent
    all_parents = all_parents.reverse()
    configs = all_parents.concat @config
    # configs = _.select configs, (c) -> c.hooks.length > 0
    async.forEachSeries configs, @run_config_hooks, callback

  run_config_hooks: (config, callback) =>
    if typeof(config) == 'string'
      config = new cf.Config config

    console.log "Running hooks for #{config.name}"

    @cpdir config.hooks_dir, (exit_code) =>
      callback if exit_code > 0

      # Run hooks only from top-level of directory tree.
      files = (fs.readdirSync config.hooks_dir).sort()
      # Don't cull list here, leave _call_hook to decide
      # what a callable hook is.
      
      things = _.map files, (h) ->
        {config_name: config.name, file: h}
      async.forEachSeries things, @_call_hook, callback

  run_one_hook: (config_name, hook_name, callback) =>
    config = new cf.Config config_name
    hook = {config_name: config.name, file: hook_name}
    @cpdir config.hooks_dir, (exit_code) =>
      if exit_code is 0
        process.stderr.write "Failed to copy files #{config.hooks_dir}\n"
        callback 'cpdir error'
      else
        @_call_hook(hook, callback)


  #### Private methods ####

  # Runs file if it is of the form DDD_something.r.ext (remotely)
  # or DDD_something.l.ext (locally).
  _call_hook: (hook, callback) =>
    if /^\d+_.+\.r\.\w/.test hook.file
      console.log "Running remote #{hook.file}"
      @sh "sh /root/#{hook.file} #{@name}", callback
    else if /^\d+_.+\.l\.\w/.test hook.file
      console.log "Running local #{hook.file}"
      hooks_dir="#{settings.config_path}/#{hook.config_name}/hooks"
      oldcwd = process.cwd()
      process.chdir hooks_dir
      @_local_sh "#{hooks_dir}/#{hook.file}", [@name], ->
        process.chdir oldcwd
        callback()
    else
      console.log "(Ignoring #{hook.file})"
      callback()

  # Connect via SSH and execute command.
  # *command* is a list of strings.
  # TODO: proper callbacks?
  _ssh: (key, command, callback) ->
    @_wait_for_sshd key, =>
      stdout_ends_in_newline = true
      stderr_ends_in_newline = true
      args = _common_ssh_args key
      extra = ["root@#{@ip_address}"].concat command
      args = args.concat extra

      ssh = spawn 'ssh', args
      process.stdin.resume()
      process.stdin.pipe ssh.stdin
      ssh.stdout.on 'data', (data) ->
        stuff = data.toString('ascii')
        process.stdout.write stuff
        stdout_ends_in_newline = /\n$/.test stuff
      ssh.stderr.on 'data', (data) ->
        stuff = data.toString('ascii')
        process.stderr.write stuff
        stderr_ends_in_newline = /\n$/.test stuff
      ssh.on 'exit', callback

  # Copy files via SCP
  # TODO: factor out into SSH & SCP class, proper callbacks?
  _scp: (key, files, callback, recursive=false) ->
    @_wait_for_sshd key, =>
      args = _common_ssh_args key
      if recursive
        args = ['-r'].concat args
      args = args.concat files
      args.push "root@#{@ip_address}:/root"

      ssh = spawn 'scp', args
      ssh.stdout.on 'data', (data) -> console.log data.toString('ascii')
      ssh.stderr.on 'data', (data) -> console.log data.toString('ascii')
      ssh.on 'exit', callback

  # Wait until we can connect to ssh and run the command "exit 99".  It needs to
  # be about this complicated because we run this when a server is starting up;
  # and there are all sorts of funny cases (server not yet started, server started
  # but sshd not started, and, bizarrely, sshd running but giving protocol errors
  # (possibly when it first starts it is generating a host key)).
  _wait_for_sshd: (key, callback) ->
    args = _common_ssh_args key
    args.push "root@#{@ip_address}"
    args.push "exit 99"
    again = =>
      ssh = spawn 'ssh', args
      ssh.stdout.on 'data', (data) ->
        process.stdout.write '[1;32mwaiting-for-sshd[0m: ' + data.toString('ascii')
      ssh.stderr.on 'data', (data) ->
        process.stderr.write '[1;31mwaiting-for-sshd[0m: ' + data.toString('ascii')
      ssh.on 'exit', (rc) ->
        if rc == 99
          callback()
        else
          setTimeout again, 999
    again()

  # Spawn a command locally, needs to be executable
  # TODO: put somewhere more sane, name it properly: exec?
  _local_sh: (command, args, callback) ->
    cmd = spawn command, args
    cmd.stdout.on 'data', (data) -> console.log data.toString('ascii')
    cmd.stderr.on 'data', (data) -> console.log data.toString('ascii')
    cmd.on 'exit', callback

_common_ssh_args = (key) -> [
  '-o', 'LogLevel=ERROR',
  '-o', 'ConnectTimeout=10',
  '-o', 'UserKnownHostsFile=/dev/null',
  '-o', 'StrictHostKeyChecking=no',
  '-o', 'IdentitiesOnly=yes',
  '-i', key]

module.exports = Instance
