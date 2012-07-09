# run with mocha 

# Mocha tests for the classes.  Each class is a configuration of
# a cloud server, or part of a configuration.

fs = require 'fs'
cf = require 'config'

config = null

describe 'Vanilla Config', ->
  it 'should exist', ->
    f = fs.openSync('class/vanilla/config.json', 'r')

describe 'Config inclusion', ->

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

describe 'Hooks', ->
  describe 'when a hooks directory exists for a config', ->

    before ->
      config = new cf.Config 'linode_custom_kernel'

    it 'should find all hooks in the hooks directory', ->
      config.hooks.should.include '010_install_custom_kernel.r.sh'
      config.hooks.should.include '020_update_linode_config.l.coffee'
      config.hooks.should.include '030_reboot_instance.l.sh'
      config.hooks.should.include '040_check_kernel_version.l.sh'

    it 'should not find any hooks that are not correctly specified', ->
      config.hooks.should.not.include 'no_order_number.r.sh'
      config.hooks.should.not.include '050_no_local_or_remote_ext.sh'

    it 'sorts the hooks in ascending order', ->
      config.hooks[0].should.equal '010_install_custom_kernel.r.sh'
      config.hooks[3].should.equal '040_check_kernel_version.l.sh'

  describe 'when a hooks directory does not exist', ->
    it 'should not error', ->
      config = new cf.Config 'vanilla'
