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

  describe 'matching a kernel', ->
    kernel_id = null
    kernel_nock = nocks.avail_kernels()

    before (done) ->
      Linode._get_kernel '3.2.1', (id) ->
        kernel_id = id
        done()

    it 'calls avail.kernels', ->
      kernel_nock.isDone().should.be.true

    it 'finds a kernel by version number', ->
      kernel_id.should.equal 145

  describe 'when creating an instance with the boxecutor config', ->
    linode = null
    plan_nock = nocks.plans()
    create_nock = nocks.create()
    update_nock = nocks.linode_update()
    create_distro_nock = nocks.create_dist_disk()
    distro_nock = nocks.avail_distro()
    create_config_nock = nocks.create_config()
    kernel_nock = nocks.avail_kernels()

    before (done) ->
      linode = Linode.create 'boxecutor', (res) ->
        done()

    it 'calls linode.create', ->
      create_nock.isDone().should.be.true

    it 'calls linode.update to set the label', ->
      update_nock.isDone().should.be.true

    it 'calls linode.disk.createfromdistribution to create a system disk', ->
      create_distro_nock.isDone().should.be.true

    # Disks should probably be specified in the config
    #it 'calls linode.disk.create to create a data disk'

    it 'calls linode.config.create to set up a Linode config', ->
      create_config_nock.isDone().should.be.true

  describe 'when listing instances', ->
    list = null
    list_nock = nocks.list()

    before (done) ->
      list = Linode.list (res) ->
        list = res
        done()

    it 'calls linode.list', ->
      list_nock.isDone().should.be.true

    it 'outputs an array of instances and their states & IDs', ->
      list.should.be.an.instanceof Array
      list.length.should.equal 2
      list[0].state.should.equal 1
      list[0].id.should.equal 206097
      list[0].name.should.equal 'boxecutor_1'

  describe 'when getting an instance from its name', ->
    list_nock = nocks.list()
    instance = null

    before (done) ->
      Linode._get 'boxecutor_1', (i) ->
          instance = i
          done()

    it 'gets the instance from the name', ->
      instance.id.should.equal 206097

  describe 'when destroying an instance', ->
    delete_nock = nocks.delete()
    list_nock = nocks.list()

    before (done) ->
      Linode.destroy 'boxecutor_1', ->
          done()

    it 'calls linode.delete on the instance', ->
      delete_nock.isDone().should.be.true

  describe 'when starting an instance', ->
    boot_nock = nocks.boot()
    list_nock = nocks.list()

    it 'calls linode.boot on the instance', (done) ->
      Linode._get 'boxecutor_1', (instance) ->
        instance.start ->
          boot_nock.isDone().should.be.true
          done()


  describe 'when stopping an instance', ->
    shutdown_nock = nocks.shutdown()
    list_nock = nocks.list()

    it 'calls linode.shutdown on the instance', (done) ->
      Linode._get 'boxecutor_1', (instance) ->
        instance.stop ->
          shutdown_nock.isDone().should.be.true
          done()

  describe 'when restarting an instance', ->
    reboot_nock = nocks.reboot()
    list_nock = nocks.list()

    it 'calls linode.reboot on the instance', (done) ->
      Linode._get 'boxecutor_1', (instance) ->
        instance.restart ->
          reboot_nock.isDone().should.be.true
          done()
