sinon = require 'sinon'

li = require 'li'

describe 'li', ->
  mock = null

  beforeEach ->
    mock = sinon.mock process.stdout
    mock.expects 'write'

  it 'can call main with an empty list', ->
    li.main([])
    mock.verify()

  describe 'help', ->
    it 'offers help', ->
      li.main ['li', 'help']
      mock.verify()

