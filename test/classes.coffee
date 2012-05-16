# run with mocha 

# Mocha tests for the classes.  Each class is a configuration of
# a cloud server, or part of a configuration.

fs = require 'fs'


describe 'Vanilla Config', ->
  it 'should exist', ->
    f = fs.openSync('class/vanilla/config.json', 'r')

