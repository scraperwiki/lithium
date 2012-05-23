# run with mocha 

# Mocha tests for the placebo.
# a cloud server, or part of a configuration.
should = require 'should'
_      = require 'underscore'

class Placebo
  @instances: []

  # TODO: Which methods should have what arguments? Should
  # destroy be an instance method?

  # Create a server ready to run. Somewhere on the internet.
  # Servers are created in the "stopped" state.
  @create: ->
    @instances.push new Placebo

  # Destroy a previously created server.
  @destroy: ->

  # List instances in the cloud
  @list: ->
    @instances

  # Start the server. Immediately go into the 'starting' state,
  # and if everything goes okay, then sometime later it will be
  # in the 'running' state.
  start: ->

  # Stop the server. Immediately go into the 'stopping' state,
  # and if everything goes okay, then sometime later it will be
  # in the 'stopped' state.
  stop: ->

  # Return the state of the server.  Will be one of:
  # 'stopped', 'running', 'starting', 'stopping', and probably
  # others.
  state: ->

describe 'Placebo', ->

  it 'can create a placebo instance with a config', ->
    should.exist Placebo.create

  it 'can destroy a placebo instance, given its name', ->
    should.exist Placebo.destroy
  
  describe 'when two instances exist', ->
    before ->
      (_ 2).times -> Placebo.create()

    it 'can list created instances', ->
      l = Placebo.list()
      l.should.be.an.instanceof Array
      l.length.should.equal 2
      l[0].should.be.an.instanceof Placebo
      l[1].should.be.an.instanceof Placebo

  describe 'a new placebo instance', ->
    placebo = null

    before ->
      placebo = new Placebo

    it 'has a start method', ->
      should.exist placebo.start

    it 'has a stop method', ->
      should.exist placebo.stop
