should = require 'should'
sinon = require 'sinon'

Instance = require('instance').Instance
LithiumConfig = require('lithium_config').LithiumConfig

describe 'Instance', ->
  [i, callbacks] = [null, null]

  beforeEach ->
    i = new Instance 'linode_custom_kernel'

    callbacks =
      stdout: ->
      stderr: ->
      exit: ->

    sinon.stub i, '_scp'
    sinon.stub i, '_ssh'
    sinon.stub i, '_local_sh'

  afterEach ->
    i._scp.restore()
    i._ssh.restore()
    i._local_sh.restore()

  describe 'sh (run a command)', ->

    it 'should find the private key', ->
      key = LithiumConfig.sshkey_private
      key.length.should.be.above 1

    it 'calls ssh', ->
      i.sh 'cat /etc/passwd', callbacks
      i._ssh.calledOnce.should.be.true

  describe 'cp (copy a file)', ->
    it 'calls scp', ->
      i.cp 'cat /etc/passwd', callbacks
      i._scp.calledOnce.should.be.true

  describe 'run_hooks (run all hooks associated with config)', ->
    beforeEach ->
      i.run_hooks()

    it 'scps remote hooks to instance', ->
      i._scp.calledOnce.should.be.true

    it 'uses ssh to exec remote hooks', ->
      i._ssh.calledTwice.should.be.true

    it 'execs local hooks locally', ->
      i._local_sh.calledTwice.should.be.true

    it 'execs hooks of superest superclass'
