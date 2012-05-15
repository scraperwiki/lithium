# run with mocha --compilers coffee:coffee-script

# Mocha tests for the classes.  Each class is a configuration of
# a cloud server, or part of a configuration.

fs = require 'fs'

# https://github.com/visionmedia/should.js/
should = require 'should'
# http://visionmedia.github.com/mocha/#assertions
mocha = require 'mocha'

describe 'Vanilla Config', ->
  it 'should exist', ->
    f = fs.openSync('class/vanilla.json', 'r')
    should.exist(f)

