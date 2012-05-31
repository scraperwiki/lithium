should = require 'should'
sinon = require 'sinon'

Instance = require('instance').Instance
LithiumConfig = require('lithium_config').LithiumConfig

describe 'Instance', ->
  describe 'sh (run a command)', ->
    it 'should find the private key', ->
      key = LithiumConfig.sshkey_private
      key.length.should.be.above 1

    it 'calls ssh', ->
      i = new Instance
      sinon.spy i, '_ssh'
      i.sh 'cat /etc/passwd'
      i._ssh.calledOnce.should.be.true
