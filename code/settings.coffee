fs = require 'fs'

load_settings = ->
  env = process.env
  if env.NODE_ENV is 'test'
    path = "#{env.LITHIUM_PATH}/#{env.NODE_ENV}/settings.json"
  else
    path = "#{env.LITHIUM_PATH}/settings.json"

  JSON.parse fs.readFileSync(path)

module.exports = load_settings()
