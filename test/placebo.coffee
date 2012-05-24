# Placebo and its Mocha tests.

should = require 'should'
_      = require 'underscore'

ins    = require '../code/instance'

class Placebo extends ins.Instance
  @instances: []

  @create: (config) ->
    instance = new Placebo config
    @instances.push instance
    instance

  @destroy: (instance) ->
    @instances.pop instance

  # List instances in the cloud
  @list: ->
    _.clone @instances

  start: ->

  stop: ->

  state: ->

describe 'Placebo', ->

  it 'can create a placebo instance with a config', ->
    instance = Placebo.create 'boxecutor'
    instance.should.be.an.instanceof Placebo
    instance.config.name.should.equal 'boxecutor'
    Placebo.list().should.include instance
    Placebo.destroy instance

  describe 'when two instances exist', ->
    l = null

    before ->
      (_ 2).times -> Placebo.create 'vanilla'
      l = Placebo.list()

    it 'can list created instances', ->
      l.should.be.an.instanceof Array
      l.length.should.equal 2
      l[0].should.be.an.instanceof Placebo

      l[1].should.be.an.instanceof Placebo

    it 'can destroy a placebo instance, given its name', ->
      Placebo.destroy Placebo.list()[0]
      Placebo.list().length.should.equal 1

  describe 'a new placebo instance', ->
    placebo = null

    before ->
      placebo = new Placebo 'boxecutor'

    it 'has a start method', ->
      should.exist placebo.start

    it 'has a stop method', ->
      should.exist placebo.stop

  describe 'the shell works', ->
    placebo = null

    before ->
      placebo = new Placebo 'boxecutor'

    it 'can print', ->
      placebo.config.sh('echo Hello').should.equal ['Hello', '']

    it 'can raise errors', ->
      command = 'rmdir nonexistant_directory'
      result = ['', 'rmdir: failed to remove ‘nonexistant_directory’: No such file or directory']
      placebo.config.sh(command).should.equal result

    it 'can create a databox', ->
      placebo.create_box('')

    it 'can can\'t create two databoxes with the same name', ->
      placebo.create_box('pbunyan')
      placebo.create_box('pbunyan').should.throw

    it 'creates the databox in a chroot jail in /home/boxname', ->
      placebo.create_box('

    it '', ->
      

    it '', ->
      

