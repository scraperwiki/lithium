#!/usr/bin/env coffee

help = (args) ->
  process.stdout.write('Very helpful help\n')

exports.main = (args) ->
  # If supplied *args* should be a list of arguments,
  # including args[0], the command name; if not supplied,
  # process.argv will be used.
  if not args?
    args = process.argv[1..]

  switch args[1]
    when 'help' then help(args)
    when undefined then help(args)
    else process.stderr.write("Try li help for help\n")

exports.main()
