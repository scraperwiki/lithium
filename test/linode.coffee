should  = require 'should'

describe 'Linode Instance', ->
  describe 'when creating an instance', ->
    it 'calls avail.LinodePlans to find the closest plan to RAM & disk'
    it 'calls linode.create with the correct plan id, term & datacentre id'
    it 'calls linode.update to set the label'
