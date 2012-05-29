fs = require 'fs'

exports.LithiumConfig = class LithiumConfig
  @sshkey_public: ->
    text = fs.readFileSync "#{process.env['HOME']}/swops-secret/keys.json"
    keys = JSON.parse text
    keys['keys']['swops-public']
