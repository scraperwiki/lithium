should  = require 'should'

describe 'Linode Instance', ->
  #TODO: handle errors properly from linode
  describe 'when creating an instance with the boxecutor config', ->
    it 'calls avail.LinodePlans to find the closest plan to RAM & disk'
    it 'calls linode.create with the correct plan id, term & datacentre id'
    it 'calls linode.update to set the label'
    it 'calls avail.distributions and matches the config distribution'
    # Disks should probably be specified in the config
    it 'calls linode.disk.createfromdistribution to create a system disk'
    it 'calls linode.disk.create to create a data disk'
    it 'calls avail.kernels to match the config kernel'
    it 'calls linode.config.create to set up a Linode config'
    # Do we need to do this here, could be in a post_create hook
    it 'calls linode.boot to start the instance'

