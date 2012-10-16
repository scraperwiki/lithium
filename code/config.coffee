fs   = require 'fs'
path = require 'path'
_    = require 'underscore'

settings = (require 'settings').settings
exists = fs.existsSync or path.existsSync

exports.Config = class Config
  hooks: []
  parent: null

  constructor: (name) ->
    @_load_config name
    @_load_hooks()
    @

  _load_config: (name) ->
    config_path = "#{settings.config_path}/#{name}/config.json"
    throw "config #{name} doesn't exist!" unless exists(config_path)
    text = fs.readFileSync config_path
    config = JSON.parse text

    if config.include?
      @parent = new Config config.include unless @parent?
      @_load_config config.include

    for key, value of config
      do (key, value) =>
        @[key] = value if key isnt 'include'

  _load_hooks: ->
    @hooks_dir = "#{settings.config_path}/#{@name}/hooks"
