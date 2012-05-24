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

    it 'has a sh method', ->
      should.exist placebo.sh

    it 'returns stdout when you run shell commands', ->
      placebo.sh('echo Hello').should.equal ['Hello', '']

    it 'returns stderr when you run shell commands', ->
      command = 'cat this_file_does_not_exist'
      result = ['', 'cat: foo: input file is output file']
      placebo.sh(command).should.equal result

    it 'throws an exception when shell commands exit nonzero', ->
      placebo.sh('exit 1').should.throw

    it 'does not throw an exception when shell commands exit zero', ->
      placebo.sh('exit 0').should.not.throw
