# Placebo and its Mocha tests.

should = require 'should'
_      = require 'underscore'

ins    = require '../code/instance'

class Placebo extends ins.Instance
  @instances: []

  @create: ->
    @instances.push new Placebo

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
    should.exist Placebo.create

  describe 'when two instances exist', ->
    l = null

    before ->
      (_ 2).times -> Placebo.create()
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
      placebo = new Placebo

    it 'has a start method', ->
      should.exist placebo.start

    it 'has a stop method', ->
      should.exist placebo.stop
