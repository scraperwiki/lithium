# run with mocha 

# Mocha tests for the classes.  Each class is a configuration of
# a cloud server, or part of a configuration.

fs = require 'fs'
cf = require 'config'

config = null

describe 'Vanilla Config', ->
  it 'should exist', ->
    f = fs.openSync('test/class/vanilla/config.json', 'r')

describe 'Config inclusion', ->

  describe 'When vanilla config is accessed', ->
    before ->
      config = new cf.Config 'vanilla'

    it 'should contain the fields for vanilla', ->
      config.name.should.equal 'vanilla'
      config.description.should.equal 'A fairly plain Linux cloud server'
      config.ram.should.equal 512
      config.disk_size.should.equal 20
      config.swap_size.should.equal 1

  describe 'When boxecutor config is accessed', ->
    before ->
      config = new cf.Config 'boxecutor'

    it 'should contain included fields from vanilla', ->
      config.ram.should.equal 512
      config.disk_size.should.equal 20
      config.swap_size.should.equal 1
    
    it 'should not have its own fields overriden', ->
      config.name.should.equal 'boxecutor'

describe 'Hooks', ->
  describe 'when a hooks directory exists for a config', ->

    before ->
      config = new cf.Config 'linode_custom_kernel'

    it 'should find all hooks in the hooks directory', ->

    it 'should not find any hooks that are not correctly specified', ->

    it 'sorts the hooks in ascending order', ->

  describe 'when a hooks directory does not exist', ->
    it 'should not error', ->
      config = new cf.Config 'vanilla'
