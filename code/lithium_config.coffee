fs = require 'fs'

exports.LithiumConfig = class LithiumConfig
  @sshkey_public: ->
    fs.readFileSync "#{process.env['HOME']}/swops-secret/id_dsa.pub", 'ascii'

  @sshkey_private:
    "#{process.env['HOME']}/swops-secret/id_dsa"

  @server_class_path: ->
    if process.env['LITHIUM_CONFIG_PATH']
      return process.env['LITHIUM_CONFIG_PATH']
    else
      return 'test/class'
