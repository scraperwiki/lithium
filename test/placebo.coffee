# run with mocha 

# Mocha tests for the placebo.
# a cloud server, or part of a configuration.
should = require 'should'

class Placebo
  @create: ->
  @destroy: ->
  start: ->
  stop: ->
#TODO: create, destroy args, destroy as instance method?
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
