fs = require 'fs'
_  = require 'underscore'

exports.Config = class Config
  constructor: (name) ->
    @_load_config(name)
    @

  _load_config: (name) ->
    text = fs.readFileSync "class/#{name}/config.json"
    config = JSON.parse text
    _.each _.keys(config), (key) =>
      @[key] = config[key] if key isnt 'include'
      @_load_config config[key] if key is 'include'

