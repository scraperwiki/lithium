should = require 'should'
sinon = require 'sinon'

Instance = require('instance').Instance
LithiumConfig = require('lithium_config').LithiumConfig

describe 'Instance', ->
  [i, callback] = [null, null]

  beforeEach ->
    i = new Instance 'boxecutor', 12121, 'boxecutor_2'

    callback = ->

    sinon.stub i, '_scp', (_a, _b, cb) -> cb()
    sinon.stub i, '_ssh', (_a, _b, cb) -> cb()
    sinon.stub i, '_local_sh',  (_a, _args, cb) -> cb()

  afterEach ->
    i._scp.restore()
    i._ssh.restore()
    i._local_sh.restore()

  describe 'sh (run a command)', ->

    it 'should find the private key', ->
      key = LithiumConfig.sshkey_private
      key.length.should.be.above 1

    it 'calls ssh', ->
      i.sh 'cat /etc/passwd', callback
      i._ssh.calledOnce.should.be.true

  describe 'cp (copy a file)', ->
    it 'calls scp', ->
      i.cp 'cat /etc/passwd', callback
      i._scp.calledOnce.should.be.true

  describe 'run_hooks (run all hooks associated with config)', ->
    beforeEach (done) ->
      sinon.stub console, 'log'
      i.run_hooks ->
        done()

    afterEach ->
      console.log.restore()

    it 'scps remote hooks to instance', ->
      i._scp.calledThrice.should.be.true

    it 'uses ssh to exec remote hooks', ->
      i._ssh.callCount.should.equal 5

    it 'execs local hooks locally', ->
      i._local_sh.calledTwice.should.be.true

    it 'calls _local_sh with instance name as argument', ->
      i._local_sh.args[1][1][0].should.equal 'boxecutor_2'

    it 'execs hooks of superconfigs'
