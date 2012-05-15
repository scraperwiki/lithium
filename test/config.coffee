# run with mocha --compilers coffee:coffee-script

fs = require 'fs'

# https://github.com/visionmedia/should.js/
should = require 'should'
mocha = require 'mocha'

describe 'Vanilla Config', ->
  it 'should exist', ->
    f = fs.openSync('vanilla.json', 'r')
    should.exist(f)
