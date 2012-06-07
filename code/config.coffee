fs   = require 'fs'
path = require 'path'
_    = require 'underscore'

exports.Config = class Config
  hooks: []

  constructor: (name) ->
    @_load_config(name)
    @_load_hooks()
    @

  _load_config: (name) ->
    return unless path.existsSync "class/#{name}/config.json"
    text = fs.readFileSync "class/#{name}/config.json"
    config = JSON.parse text
    if config.include?
      @_load_config config.include
    for key, value of config
      do (key, value) =>
        @[key] = value if key isnt 'include'

  _load_hooks: ->
    hooks_dir = "class/#{@name}/hooks"
    return unless path.existsSync hooks_dir
    files = fs.readdirSync hooks_dir
    @hooks = (_.select files, (f) ->
      /^\d+_.+\.(l|r)\.\w/.test f
    ).sort()
