#!/usr/bin/env coffee

_s = require 'underscore.string'

Linode = (require 'linode').Linode

help = (args) ->
  process.stdout.write('Very helpful help\n')

start = (args) ->
  # args[1] is 'start'
  # args[2] is 'placebo' (later on it will be 'linode' or 'ec2'
  # or something else or maybe defaulted).
  # args[3] is the configuration of the server to start.

  # if args[2] is 'placebo' then throw 'foo'
  Linode.get args[2], (instance) ->
    instance.start ->
      process.stdout.write('started\n')

stop = (args) ->
  Linode.get args[2], (instance) ->
    instance.stop ->
      process.stdout.write('stopped\n')

restart = (args) ->
  Linode.get args[2], (instance) ->
    instance.restart ->
      process.stdout.write('restarted\n')

create = (args) ->
  process.stdout.write('Creating...\n')
  Linode.create args[2], ->
    process.stdout.write('Possibly created\n')

destroy = (args) ->
  process.stdout.write "Destroying #{args[2]}...\n"
  Linode.destroy args[2], ->
    process.stdout.write "Possibly destroyed\n"

sh = (args) ->
  Linode.get args[2], (instance) ->
    instance.sh (args[3..].join ' '), (e, out, err) ->
      process.stdout.write out if out
      process.stdout.write err if err
      process.stdout.write e if e

list = (args) ->
  process.stdout.write "Listing instances...\n"
  Linode.list (err, list) ->
    if err?
      console.log err
    else
      console.log item for item in list

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
    when undefined then help(args)
    else process.stderr.write("Try li help for help, not #{args}\n")

if _s.endsWith process.argv[1], 'li.coffee'
  exports.main()
