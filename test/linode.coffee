should  = require 'should'
sinon = require 'sinon'
_ = require 'underscore'

nocks = require './fixtures'

Linode = (require '../code/linode').Linode

describe 'Linode Instance', ->
  #TODO: handle errors properly from linode
  spy = null
  before ->
    spy = sinon.spy Linode.client, 'call'


  describe 'finding the plan', ->
    plan_id = null
    nock = nocks.plans()

    before (done) ->
      Linode._get_plan 512, 20, (err, pid) ->
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
      Linode._get_distro 'Ubuntu 12.04 LTS', (err, id) ->
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
      Linode._get_kernel '3.2.1', (err, id) ->
        kernel_id = id
        done()

    it 'calls avail.kernels', ->
      kernel_nock.isDone().should.be.true 
    it 'finds a kernel by version number', ->
      kernel_id.should.equal 145

  describe 'when creating an instance with the boxecutor config', ->
    linode = null
    last_call = null
    plan_nock = nocks.plans()
    create_nock = nocks.create()
    update_nock = nocks.linode_update()
    addprivate_nock = nocks.addprivate()
    create_distro_nock = nocks.create_dist_disk()
    distro_nock = nocks.avail_distro()
    create_config_nock = nocks.create_config()
    kernel_nock = nocks.avail_kernels()
    nocks.linode_fresh()

    before (done) ->
      Linode.create 'boxecutor', (err, res) ->
        linode = res
        err_from_create = err
        # Find the last call to linode.update
        us = _.filter spy.args, (x) -> x[0] == 'linode.update'
        last_call = us[us.length-1]
        done()

    it 'calls linode.create', ->
      create_nock.isDone().should.be.true

    it 'calls linode.ip.addprivate', ->
      addprivate_nock.isDone().should.be.true

    it 'calls linode.update to set the label', ->
      update_nock.isDone().should.be.true

    it 'calls linode.disk.createfromdistribution to create a system disk', ->
      create_distro_nock.isDone().should.be.true

    # Disks should probably be specified in the config
    #it 'calls linode.disk.create to create a data disk'

    it 'calls linode.config.create to set up a Linode config', ->
      create_config_nock.isDone().should.be.true

    it 'has the right name', ->
      linode.name.should.match /^boxecutor/
      last_call[1].Label.should.equal 'boxecutor-1'

  describe 'when listing instances', ->
    list = null
    list_nock = nocks.list()
    nocks.list_ip_specific()
    nocks.list_ip_specific2()

    before (done) ->
      Linode.list (err, res) ->
        list = res
        done()

    it 'calls linode.list', ->
      list_nock.isDone().should.be.true

    it 'outputs an array of instances and their states & IDs', ->
      list.should.be.an.instanceof Array
      list.length.should.equal 2

    it 'sets the instance members correctly', ->
      list[0].state.should.equal 1
      list[0].id.should.equal 206097
      list[0].name.should.equal 'boxecutor-0'
      list[0].config.name.should.equal 'boxecutor'

  describe 'when getting an instance from its name', ->
    list_nock = nocks.list()
    list_ip_specific = nocks.list_ip_specific()
    nocks.list_ip_specific2()
    instance = null

    before (done) ->
      Linode.get 'boxecutor-0', (i) ->
        instance = i
        done()

    it 'gets the instance from the name', ->
      instance.id.should.equal 206097

  describe 'when renaming an instance', ->
    rename_nock = nocks.update_label()
    error = null

    before (done) ->
      Linode.rename 'boxecutor-0', 'existingname1234', (err) ->
        error = err
        done()

    it 'calls linode.update on the instance', ->
      rename_nock.isDone().should.be.true

    it 'returns an error when the command fails', ->
      error.should.equal "This account already has a Linode with that label. Labels must be unique."

  describe 'when getting the public and private ip address from its linode id', ->
    list_ip_specific = nocks.list_ip_specific()
    public_ip_address = null
    private_ip_address = null

    before (done) ->
      Linode._get_ips 206097, (err, pub_i, priv_i) ->
        public_ip_address = pub_i
        private_ip_address = priv_i
        done()

    it 'calls linode.list on a specific linodeid', ->
      list_ip_specific.isDone().should.be.true

    it 'gets the instance from the name', ->
      public_ip_address.should.equal '176.58.105.104'
      private_ip_address.should.equal '192.168.194.104'

  describe 'when destroying an instance', ->
    delete_nock = nocks.delete()
    list_nock = nocks.list()
    nocks.list_ip_specific()
    nocks.list_ip_specific2()

    before (done) ->
      Linode.destroy 'boxecutor-0', ->
        done()

    it 'calls linode.delete on the instance', ->
      delete_nock.isDone().should.be.true

  describe 'when starting an instance', ->
    boot_nock = nocks.boot()
    list_nock = nocks.list()
    nocks.list_ip_specific()
    nocks.list_ip_specific2()

    it 'calls linode.boot on the instance', (done) ->
      Linode.get 'boxecutor-0', (instance) ->
        instance.start ->
          boot_nock.isDone().should.be.true
          done()


  describe 'when stopping an instance', ->
    shutdown_nock = nocks.shutdown()
    list_nock = nocks.list()
    nocks.list_ip_specific()
    nocks.list_ip_specific()
    nocks.list_ip_specific2()
    nocks.list_ip_specific2()

    before (done) ->
       nocks.list()
       done()

    it 'calls linode.shutdown on the instance', (done) ->
      Linode.get 'boxecutor-0', (instance) ->
        instance.stop ->
          shutdown_nock.isDone().should.be.true
          done()

  describe 'when restarting an instance', ->
    reboot_nock = nocks.reboot()
    list_nock = nocks.list()
    nocks.list_ip_specific()
    nocks.list_ip_specific()
    nocks.list_ip_specific2()
    nocks.list_ip_specific2()
    list_nock = nocks.list()

    it 'calls linode.reboot on the instance', (done) ->
      Linode.get 'boxecutor-0', (instance) ->
        instance.restart ->
          reboot_nock.isDone().should.be.true
          done()
