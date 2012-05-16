#!/usr/bin/env coffee

exports.main = (args) ->
    # If supplied *args* should be a list of arguments,
    # including args[0], the command name; if not supplied,
    # process.argv will be used.
    if not args?
        args = process.argv[1..]

exports.main()
