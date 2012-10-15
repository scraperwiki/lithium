fs = require 'fs'

exports.settings = JSON.parse fs.readFileSync("#{process.env.LITHIUM_PATH}/settings.json")
