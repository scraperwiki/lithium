#!/usr/bin/env coffee

Linode = (require 'linode').Linode

help = (args) ->
  process.stdout.write('Very helpful help\n')

start = (args) ->
  # args[1] is 'start'
  # args[2] is 'placebo' (later on it will be 'linode' or 'ec2'
  # or something else or maybe defaulted).
  # args[3] is the configuration of the server to start.

  # if args[2] is 'placebo' then throw 'foo'
  Linode._get args[2], (instance) ->
    instance.start ->
      process.stdout.write('started\n')

create = (args) ->
  process.stdout.write('Creating...\n')
  Linode.create args[2], ->
    process.stdout.write('Possibly created\n')

destroy = (args) ->
  process.stdout.write "Destroying #{args[2]}...\n"
  Linode.destroy args[2], ->
    process.stdout.write "Possibly destroyed\n"

list = (args) ->
  process.stdout.write "Listing instances...\n"
  Linode.list (list) ->
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
    when 'create' then create(args)
    when 'destroy' then destroy(args)
    when 'list' then list(args)
    when undefined then help(args)
    else process.stderr.write("Try li help for help\n")

exports.main()
