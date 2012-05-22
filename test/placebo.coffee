# run with mocha 

# Mocha tests for the placebo.
# a cloud server, or part of a configuration.
should = require 'should'

class Placebo
  # TODO: Which methods should have what arguments? Should
  # destroy be an instance method?

  # Create a server ready to run. Somewhere on the internet.
  # Servers are created in the "stopped" state.
  @create: ->
  # Destroy a previously created server.
  @destroy: ->
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
  it 'should exist', ->
    should.exist Placebo

  it 'has a create method', ->
    should.exist Placebo.create

  it 'has a destroy method', ->
    should.exist Placebo.destroy

  describe 'a new placebo instance', ->
    placebo = null

    before ->
      placebo = new Placebo

    it 'has a start method', ->
      should.exist placebo.start

    it 'has a stop method', ->
      should.exist placebo.stop
