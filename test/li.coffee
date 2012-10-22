sinon = require 'sinon'
should = require 'should'

li = require 'li'
Instance = require 'instance'
Linode = require 'linode'

describe 'li', ->
  mock = null

  describe 'help', ->

    beforeEach ->
      mock = sinon.mock process.stdout
      mock.expects 'write'

    it 'offers help', ->
      li.main ['li', 'help']
      mock.verify()

  describe 'runhook <config> [hook]', ->
    ch_stub = null
    cp_stub = null
    rc_stub = null
    get_stub = null

    before ->
      #sinon.stub process.stderr, 'write'
      i = new Instance 'boxecutor', 12121, 'boxecutor_2'
      ch_stub = sinon.stub i, '_call_hook', (hook, cb) -> cb()
      cp_stub = sinon.stub i, 'cpdir', (dir, cb) -> cb 0
      rc_stub = sinon.stub i, 'run_config_hooks', (config, cb) -> cb()
      get_stub = sinon.stub Linode, 'get', (name, cb) -> cb i

    after ->
      #process.stderr.write.restore()

    describe 'when a config is specified', ->
        before ->
          li.main ['li', 'runhook', 'boxecutor_2', 'boxecutor']

        it 'calls all hooks for a config', ->
          rc_stub.calledOnce.should.be.true

      describe 'when a hook is specified', ->
        before ->
          li.main ['li', 'runhook', 'boxecutor_2', 'boxecutor', '010_install_pam_chroot.r.sh']

        it 'calls the hook', ->
          cp_stub.calledOnce.should.be.true
          ch_stub.calledOnce.should.be.true

    describe "when a config isn't specified", ->
      before ->
        li.main ['li', 'runhook']

      it 'displays usage info'
