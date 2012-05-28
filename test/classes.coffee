# run with mocha 

# Mocha tests for the classes.  Each class is a configuration of
# a cloud server, or part of a configuration.

fs = require 'fs'
cf = require '../code/config'

describe 'Vanilla Config', ->
  it 'should exist', ->
    f = fs.openSync('class/vanilla/config.json', 'r')

describe 'Config inclusion', ->
  config = null

  describe 'When vanilla config is accessed', ->
    before ->
      config = new cf.Config 'vanilla'

    it 'should contain the fields for vanilla', ->
      config.name.should.equal 'vanilla'
      config.description.should.equal 'A fairly plain Linux cloud server'
      config.ram.should.equal 512
      config.disk_size.should.equal 20

  describe 'When boxecutor config is accessed', ->
    before ->
      config = new cf.Config 'boxecutor'

    it 'should contain included fields from vanilla', ->
      config.ram.should.equal 512
      config.disk_size.should.equal 20
    
    it 'should not have its own fields overriden', ->
      config.name.should.equal 'boxecutor'


