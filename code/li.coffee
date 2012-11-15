#!/usr/bin/env coffee

_ = require 'underscore'
_s = require 'underscore.string'
async = require 'async'

Linode = require 'linode'

command = {}

# args[1] is the name of the command, e.g. start
# args[2..] are the command args
command.help =
  help: "help\t\t\t\tShow this help"
  run: (args) ->
    cmdhelp = (command[cmd].help for cmd of command).join('\n    ')
    help =
    """
    Usage: li <command> [OPTIONS]
      Commands:

    """ + '    ' + cmdhelp + '\n'
    process.stdout.write help

# Takes a config name, and creates an instance based on that config.
# args[2] is the name of the config
command.create =
  help: "create <config>\t\t\tCreate and deploy and start an instance by config"
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
  help: "destroy <instance> ...\t\tDestroy an instance (or instances)"
  run: (args) ->
    async.forEach args[2...], (item, callback) ->
      Linode.destroy item, ->
        process.stdout.write "Destroyed #{item}\n"
        callback()

# args[2] is the name of the instance to stop
command.stop =
  help: "stop <instance>\t\t\tStop an instance"
  run: (args) ->
    Linode.get args[2], (instance) ->
      instance.stop ->
        process.stdout.write('stopped\n')

# args[2] is the name of the instance to restart
command.restart =
  help: "restart <instance>\t\t\tRestart an instance"
  run: restart = (args) ->
    Linode.get args[2], (instance) ->
      instance.restart ->
        process.stdout.write('restarted\n')

# args[2] is the name of the instance to start
command.start =
  help: "start <instance>\t\t\tStart an existing instance"
  run: (args) ->
    Linode.get args[2], (instance) ->
      instance.start ->
        process.stdout.write('started\n')

# renames the instance args[2] to args[3]
command.rename =
  help: "rename <name> <new-name>\t\tRename an instance"
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
  help: "sh <instance> <cmd>\t\t\tExecute a command on instance"
  run: (args) ->
    Linode.get args[2], (instance) ->
      callback = (code) ->
        process.exit code

      instance.sh (args[3..].join ' '), callback

# ssh into an instance.
# args[2] is the name of the instance.
command.ssh =
  help: "ssh [user@]<instance>\t\tLog in to instance via ssh"
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

# Run all, or a single hook(s) on a specified instance by config
# args[2] is the instance
# args[3] is the config
# args[4] is the optional hook name
command.runhook =
  help: "runhook <instance> <config> [hook]\tRun deployment hook(s)"
  run: (args) ->
    [instance_name, config, hook] = [ args[2], args[3], args[4] ]
    finished = ->
      console.log "runhook finished, exiting by force."
      process.exit 0

    Linode.get instance_name, (instance) ->
      if hook?
        instance.run_one_hook config, hook, finished
      else
        instance.run_config_hooks config, finished

# Makes a comment on an instance
command.comment =
  help: "comment <instance> [comment]\tMake or display a comment"
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
  help: "list [--help] [--verbose]\t\tList instances"
  run: (args) ->
    if args[2] == '--help'
      console.log colour_legend()
    else
      process.stdout.write "Listing instances..."
      if args[2] == '--verbose' or args[2] == '-v'
        verbose = yes
      else
        verbose = no
      Linode.list verbose, (err, list) ->
        process.stdout.write '\r' # so that line gets overwritten
        if err?
          console.log err
        else
          log_one_item item for item in list

log_one_item = (item) ->
  colour = pick_colour item.state
  colour_off = pick_colour()
  ipstuff = ''
  if item.ip_address?
    ipstuff += ' Pub:' + item.ip_address
  if item.private_ip_address? 
    ipstuff += ' Priv:' + item.private_ip_address
  # Disable colour for now as doesn't work with some scripting of li list
  # XXX DO NOT enable without making the colour conditional on it being called by a human
  colour = ''
  colour_off = ''
  console.log "#{colour}#{item.name}#{colour_off} \x1b[22;37m[#{item.config.name}]#{ipstuff}\x1b[0m #{item.comments}"

friendly_state = (state) ->
  if LINODE_STATE[state]?
    LINODE_STATE[state]
  else
    "Unknown state: #{state}"

pick_colour = (state) ->
  # Pick a funky colour for each state (which is the small number used by linode)
  # As a hack, if *state* is not supplied, then the colour-off sequence is returned.
  s = '0'
  if state?
    # Colour ANSI escapes: http://pinterest.com/pin/39476934204045349/
    the_colour =
      '-2': '22;31;40'
      '-1': '22;33;40'
      '0': '22;33'
      '1': '1;32'
      '2': '22;37;40'
      '3': '1;36'
    s = the_colour[state]
  return "\x1b[#{s}m"

colour_legend = () ->
  # Return a string that can be printed out
  # to make a colour legend.
  l = _.map _.pairs(LINODE_STATE), (s) ->
    [n,name] = s
    pick_colour(n) + name + pick_colour()
  l.join ' '


LINODE_STATE =
    '-2': 'Boot Failed'
    '-1': 'Being Created'
    '0' : 'Brand New'
    '1' : 'Running'
    '2' : 'Powered Off'
    '3' : 'Shutting Down'

command.jobs =
  help: "jobs\t\t\t\tList all Linode jobs"
  run: (args) ->
    # Linode lists jobs per instance, so we have to iterate over
    # each of our instances.
    Linode.list no, (err, instances) ->
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
