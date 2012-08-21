#!/usr/bin/env coffee
nock = require 'nock'
nock.recorder.rec()

LinodeClient = (require 'linode-api').LinodeClient

client = new LinodeClient process.env['LINODE_API_KEY']

client.call 'linode.ip.list',
  LinodeID: 206102
  , ->

#client.call 'domain.resource.create',
#  DomainID: 352960
#  Type: 'A'
#  Name: 'abbyy-0'
#  Target: '176.58.107.125'
#  TTL_sec: 3600
# , ->

#client.call 'avail.LinodePlans',null, ->
#client.call 'avail.kernels',null, ->
#client.call 'avail.distributions',null, ->
#
#client.call 'linode.delete',
#  'LinodeID': 206912
#  'skipChecks': true
#  , ->

#client.call 'linode.disk.createfromdistribution',
#client.call 'linode.create',
#  'DatacenterID': 7
#  'PlanID': 1
#  'PaymentTerm': 1
#  , ->
#
#client.call 'linode.list',null, ->
#client.call 'linode.ip.addprivate',
#  'LinodeID': 222837
#  , ->

#client.call 'linode.list',
#  'LinodeID': 206097
#  'asdasdsad': 'asasda'
#  , ->
#
#client.call 'linode.update',
#  'LinodeID': 206097
#  'Label': 'test'
#  , ->
#
#client.call 'linode.disk.createfromdistribution',
#  'LinodeID': 206097
#  'DistributionID': 98 #ubuntu 12.04
#  'Label': 'system'
#  'Size': 5048
#  'rootPass':'r00ter'
#  , ->
#
#client.call 'linode.disk.create',
#  'LinodeID': 206097
#  'Label': 'data'
#  'Type': 'ext3'
#  'Size': 10000
#  , ->
#

#client.call 'linode.config.create',
#  'LinodeID': 206097
#  'KernelID': 121
#  'Label': 'test'
#  'Comments': 'decription'
#  'DiskList': '953010,953011'
#  'RootDeviceNum': 1
#  , ->

#client.call 'linode.boot',
#  'LinodeID': 206097
#  , ->
#
#client.call 'linode.ip.list',
#  'LinodeID': 206097
#  , ->

#client.call 'linode.reboot',
#  'LinodeID': 206097
#  , ->
#
#client.call 'linode.shutdown',
#  'LinodeID': 206097
#  , ->
