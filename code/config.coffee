fs   = require 'fs'
path = require 'path'
_    = require 'underscore'

li_cfg = (require 'lithium_config').LithiumConfig

exports.Config = class Config
  hooks: []
  parent: null

  constructor: (name) ->
    @_load_config name
    @_load_hooks()
    @

  _load_config: (name) ->
    config_path = "#{li_cfg.server_class_path()}/#{name}/config.json"
    return unless path.existsSync config_path
    text = fs.readFileSync config_path
    config = JSON.parse text
    if config.include?
      @parent = new Config config.include unless @parent?
      @_load_config config.include

    for key, value of config
      do (key, value) =>
        @[key] = value if key isnt 'include'

  _load_hooks: ->
    hooks_dir = "#{li_cfg.server_class_path()}/#{@name}/hooks"
    return unless path.existsSync hooks_dir
    files = fs.readdirSync hooks_dir
    @hooks = (_.select files, (f) ->
      /^\d+_.+\.(l|r)\.\w/.test f
    ).sort()
