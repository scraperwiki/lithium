li = require 'li'

describe 'li', ->
  it 'can call main with an empty list', ->
    li.main([])

  describe 'help', ->
    it 'offers help', ->
      li.main(['li', 'help'])
