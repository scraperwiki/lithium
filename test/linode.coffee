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

  describe 'matching a distribution', ->
    distro_id = null
    distro_nock = nocks.avail_distro()

    before (done) ->
      Linode._get_distro 'Ubuntu 12.04 LTS', (id) ->
        distro_id = id
        done()

    it 'calls avail.distributions', ->
      distro_nock.isDone().should.be.true

    it 'finds a distro id by name', ->
      distro_id.should.equal 98

  describe 'when creating an instance with the boxecutor config', ->
    linode = null
    plan_nock = nocks.plans()
    create_nock = nocks.create()
    update_nock = nocks.linode_update()
    create_distro_nock = nocks.create_dist_disk()
    distro_nock = nocks.avail_distro()

    before (done) ->
      linode = Linode.create 'boxecutor', (res) ->
        done()

    it 'calls linode.create', ->
      create_nock.isDone().should.be.true

    it 'calls linode.update to set the label', ->
      update_nock.isDone().should.be.true

    # Disks should probably be specified in the config
    it 'calls linode.disk.createfromdistribution to create a system disk', ->
      create_distro_nock.isDone().should.be.true

    it 'calls linode.disk.create to create a data disk'

    it 'calls avail.kernels to match the config kernel'
    it 'calls linode.config.create to set up a Linode config'
    # Do we need to do this here, could be in a post_create hook
    it 'calls linode.boot to start the instance'

