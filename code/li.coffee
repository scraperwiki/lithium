#!/usr/bin/env coffee

_s = require 'underscore.string'
async = require 'async'

Linode = (require 'linode').Linode

command = {}

# args[1] is the name of the command, e.g. start
# args[2..] are the command args
command.help =
  help: "help                        Show this help"
  run: (args) ->
    cmdhelp = (command[cmd].help for cmd of command).join('\n    ')
    help =
    """
    Usage: li <command> [OPTIONS]
      Commands:

    """ + '    ' + cmdhelp + '\n'
    process.stdout.write help

# args[2] is the name of the instance to start
command.start =
  help: "start <instance-name>       Start an instance"
  run: (args) ->
    Linode.get args[2], (instance) ->
      instance.start ->
        process.stdout.write('started\n')

# args[2] is the name of the instance to stop
command.stop =
  help: "stop <instance-name>        Stop an instance"
  run: (args) ->
    Linode.get args[2], (instance) ->
      instance.stop ->
        process.stdout.write('stopped\n')

# args[2] is the name of the instance to restart
command.restart =
  help: "restart <instance-name>     Restart an instance"
  run: restart = (args) ->
    Linode.get args[2], (instance) ->
      instance.restart ->
        process.stdout.write('restarted\n')

# Takes a config name, and creates an instance based on that config.
# args[2] is the name of the config
command.create =
  help: "create <config-name>        Create a instance by config"
  run: (args) ->
    process.stdout.write('Creating...\n')
    Linode.create args[2], (dummy_, item) ->
      Linode.get item.name, (instance) ->
        instance.start ->
          instance.run_hooks (code) ->
            log_one_item instance
            if code is null then code = 0
            console.log "Exit code: #{code}"
            process.exit code

# args[2..] are the names of the instance to destroy
command.destroy =
  help: "destroy <instance-name> ... Destroy an instance (or instances)"
  run: (args) ->
    async.forEach args[2...], (item, callback) ->
      Linode.destroy item, ->
        process.stdout.write "Destroyed #{item}\n"
        callback()

# renames the instance args[2] to args[3]
command.rename =
  help: "rename <name> <new-name>    Rename an instance"
  run: (args) ->
    process.stdout.write "Renaming #{args[2]}...\n"
    Linode.rename args[2], args[3], (err) ->
      if err?
        process.stdout.write "Error while renaming: #{err}\n"
      else
        process.stdout.write "Renamed\n"

# Executes a command on the instance (with ssh)
# args[2] is the name of the instance;
# args[3] and onwards are the command to run.
command.sh =
  help: "sh <instance-name> <cmd>    Execute a command on instance"
  run: (args) ->
    Linode.get args[2], (instance) ->
      callback = (code) ->
        console.log "[22;32mExit code[0m: #{code}"
        process.exit code

      instance.sh (args[3..].join ' '), callback

# ssh into an instance.
# args[2] is the name of the instance.
command.ssh =
  help: "ssh [user@]<instance-name>  Log in to instance using ssh"
  run: (args) ->
    name = args[2]
    l = name.split '@'
    if l.length == 2
      instancename = l[1]
      username = l[0]
    else
      instancename = l[0]
      username = 'root'
    Linode.get instancename, (instance) ->
      instance.ssh username

# Deploys an instance by running all its hooks
# args[2] is the instance
command.deploy =
  help: "deploy <instance-name>      Run deployment hooks on instance [31m[OBSOLESCENT][0m"
  run: (args) ->
    Linode.get args[2], (instance) ->
      callback = (code) ->
        if code is null then code = 0
        console.log "Exit code: #{code}"
        process.exit code
      instance.run_hooks callback

# Makes a comment on an instance
command.comment =
  help: "comment <name> [<comment>]  Make or display a comment on instance"
  run: (args) ->
    if args[3]?
      process.stdout.write "Making comment..."
      Linode.set_comment args[2], args[3], (err, res) ->
        if err?
          console.log err
        else
          console.log "done"
    else
      Linode.get_comment args[2], (err, comment) ->
        if err?
          console.log err
        else
          console.log "#{args[2]}: #{comment}"

# Displays a list of instances
command.list =
  help: "list                        List instances"
  run: (args) ->
    process.stdout.write "Listing instances...\n"
    Linode.list (err, list) ->
      if err?
        console.log err
      else
        log_one_item item for item in list

log_one_item = (item) ->
  state = friendly_state item.state
  console.log "#{item.name} [#{item.config.name}] Pub:#{item.ip_address}#{if item.private_ip_address? then ' Priv:' + item.private_ip_address else ''} #{state}"

friendly_state = (state) ->
  if LINODE_STATE[state]?
    LINODE_STATE[state]
  else
    "Unknown state: #{state}"

# Borrowed from https://svn.apache.org/repos/asf/libcloud/trunk/libcloud/compute/drivers/linode.py
LINODE_STATE =
    '-2': 'BootFailed'           # Boot Failed
    '-1': 'Creating'             # Being Created
    '0' : 'New'                  # Brand New
    '1' : 'Running'              # Running
    '2' : 'Terminated'           # Powered Off
    '3' : 'Rebooting'            # Shutting Down

command.jobs =
  help: "jobs                        List all Linode jobs"
  run: (args) ->
    # Linode lists jobs per instance, so we have to iterate over
    # each of our instances.
    Linode.list (err, instances) ->
      if err?
        console.log err
      else
        async.forEachSeries instances, (instance, callback) ->
          console.log "Jobs for #{instance.name} #{instance.id}"
          Linode.jobs instance, (err, jobs) ->
            if err?
              console.log err
            else
              async.forEachSeries jobs, ((job, cb) ->
                log_one_job job
                cb()), callback

log_one_job = (job) ->
  console.log job

exports.main = (args) ->
  # If supplied *args* should be a list of arguments,
  # including args[0], the command name; if not supplied,
  # process.argv will be used.
  if not args?
    args = process.argv[1..]

  cmd_name = args[1]
  if cmd_name of command
    command[cmd_name].run(args)
  else if not cmd_name?
    command['help'].run(args)
  else
    process.stderr.write("I don't understand '#{args[1]}', try li help\n")

if _s.endsWith process.argv[1], 'li.coffee'
  exports.main()
