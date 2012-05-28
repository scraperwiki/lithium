should  = require 'should'

nocks = require './fixtures'

Linode = (require '../code/linode').Linode

describe 'Linode Instance', ->
  #TODO: handle errors properly from linode

  describe 'finding the plan', ->
    plan_id = null
    nock = nocks.plans()
    
    before (done) ->
      Linode._get_plan 512, 20, (pid) ->
        plan_id = pid
        done()

    it 'calls avail.LinodePlans', ->
      nock.isDone().should.be.true

    it 'finds the plan that corresponds to the RAM & disk', ->
      plan_id.should.equal 1

  describe 'when creating an instance with the boxecutor config', ->
    linode = null
    plan_nock = nocks.plans()
    create_nock = nocks.create()
    update_nock = nocks.linode_update()

    before (done) ->
      linode = Linode.create 'boxecutor', (res) ->
        done()

    it 'calls linode.create', ->
      create_nock.isDone().should.be.true

    it 'calls linode.update to set the label', ->
      update_nock.isDone().should.be.true

    it 'calls avail.distributions and matches the config distribution'
    # Disks should probably be specified in the config
    it 'calls linode.disk.createfromdistribution to create a system disk'
    it 'calls linode.disk.create to create a data disk'
    it 'calls avail.kernels to match the config kernel'
    it 'calls linode.config.create to set up a Linode config'
    # Do we need to do this here, could be in a post_create hook
    it 'calls linode.boot to start the instance'

