sinon = require 'sinon'

li = require 'li'

describe 'li', ->
  mock = null

  beforeEach ->
    mock = sinon.mock process.stdout
    mock.expects 'write'

  describe 'help', ->
    it 'offers help', ->
      li.main ['li', 'help']
      mock.verify()
