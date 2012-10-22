# Placebo and its Mocha tests.

should  = require 'should'
_       = require 'underscore'

Placebo =  require '../code/placebo'
settings = require 'settings'

describe 'Placebo', ->

  settings.linode_api_key = 'fakeapikey'
  settings.config_path = 'test/class'

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
