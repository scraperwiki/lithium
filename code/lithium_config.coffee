fs = require 'fs'

exports.LithiumConfig = JSON.parse fs.readFileSync('settings.json')
