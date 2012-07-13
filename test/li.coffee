sinon = require 'sinon'

li = require 'li'
should = require 'should'

describe 'li', ->
  mock = null

  describe 'help', ->

    beforeEach ->
      mock = sinon.mock process.stdout
      mock.expects 'write'

    it 'offers help', ->
      li.main ['li', 'help']
      mock.verify()
