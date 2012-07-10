#!/usr/bin/env coffee

_s = require 'underscore.string'
async = require 'async'

Linode = (require 'linode').Linode

# args[1] is the name of the command, e.g. start
# args[2..] are the command args
help = (args) ->
  help =
  """
  Usage: li <command> [OPTIONS]
    Commands:
      list                      List instances
      create <config-name>      Create a instance by config
      destroy <instance-name>   Destroy an instance

      start <instance-name>     Start an instance
      stop <instance-name>      Stop an instance
      restart <instance-name>   Restart an instance
      sh <instance-name> <cmd>  Execute a command on an instance
      deploy <instance-name>    Run deployment hooks on an instance [31m[OBSOLESCENT][0m

  """
  process.stdout.write help

# args[2] is the name of the instance to start
start = (args) ->
  Linode.get args[2], (instance) ->
    instance.start ->
      process.stdout.write('started\n')

# args[2] is the name of the instance to stop
stop = (args) ->
  Linode.get args[2], (instance) ->
    instance.stop ->
      process.stdout.write('stopped\n')

# args[2] is the name of the instance to restart
restart = (args) ->
  Linode.get args[2], (instance) ->
    instance.restart ->
      process.stdout.write('restarted\n')

# Takes a config name, and creates an instance based on that config.
# args[2] is the name of the config
create = (args) ->
  process.stdout.write('Creating...\n')
  Linode.create args[2], (dummy_, item) ->
    Linode.get item.name, (item) ->
      process.stdout.write('Created!\n')
      log_one_item item

# args[2] is the name of the instance to destroy
destroy = (args) ->
  process.stdout.write "Destroying #{args[2]}...\n"
  Linode.destroy args[2], ->
    process.stdout.write "Destroyed\n"

# Executes a command on the instance (with ssh)
# args[2] is the name of the instance;
# args[3] and onwards are the command to run.
sh = (args) ->
  Linode.get args[2], (instance) ->
    callback = (code) ->
      console.log "[22;32mExit code[0m: #{code}"
      process.exit code

    instance.sh (args[3..].join ' '), callback

# Deploys an instance by running all its hooks
# args[2] is the instance
deploy = (args) ->
  Linode.get args[2], (instance) ->
    callback = (code) ->
      if code is null then code = 0
      console.log "Exit code: #{code}"
      process.exit code
    instance.run_hooks callback

# Displays a list of instances
list = (args) ->
  process.stdout.write "Listing instances...\n"
  Linode.list (err, list) ->
    if err?
      console.log err
    else
      log_one_item item for item in list

log_one_item = (item) ->
  state = friendly_state item.state
  console.log "#{item.name} [#{item.config.name}] #{item.ip_address} #{state}"

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

jobs = (args) ->
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

  switch args[1]
    when 'help' then help(args)
    when 'start' then start(args)
    when 'stop' then stop(args)
    when 'restart' then restart(args)
    when 'create' then create(args)
    when 'destroy' then destroy(args)
    when 'list' then list(args)
    when 'sh' then sh(args)
    when 'deploy' then deploy(args)
    when 'jobs' then jobs(args)
    when undefined then help(args)
    else process.stderr.write("Try li help for help, not #{args}\n")

if _s.endsWith process.argv[1], 'li.coffee'
  exports.main()
