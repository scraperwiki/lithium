fs = require 'fs'

exports.Config = class Config
  constructor: (name) ->
    @_load_config(name)
    @

  _load_config: (name) ->
    text = fs.readFileSync "class/#{name}/config.json"
    config = JSON.parse text
    if config.include?
      @_load_config config.include
    for key, value of config
      do (key, value) =>
        if key isnt 'include' then @[key] = value
