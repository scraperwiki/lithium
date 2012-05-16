sinon = require 'sinon'

li = require 'li'

describe 'li', ->
  it 'can call main with an empty list', ->
    li.main([])

  describe 'help', ->
    it 'offers help', ->
      mock = sinon.mock process.stdout
      mock.expects 'write'
      li.main ['li', 'help']
      mock.verify()

