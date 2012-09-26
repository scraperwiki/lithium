nock = require 'nock'

# List details of a specific linode
exports.list_ip_specific = ->
  nock('https://api.linode.com')
  .filteringPath(/api_key=[^&]*/g, 'api_key=fakeapikey')
  .get('/?api_key=fakeapikey&api_action=linode.ip.list&LinodeID=206097')
  .reply 200,
    """
    { "ERRORARRAY":[],
      "DATA":[
          {"IPADDRESSID":133212,"RDNS_NAME":"li463-104.members.linode.com",
          "LINODEID":206097,"ISPUBLIC":1,"IPADDRESS":"176.58.105.104"},
          {"IPADDRESSID":133213,"RDNS_NAME":"li104.members.linode.com",
          "LINODEID":206097,"ISPUBLIC":0,"IPADDRESS":"192.168.194.104"}
          ],
      "ACTION":"linode.ip.list" }
    """,
    date: 'Fri, 25 May 2012 09:47:40 GMT'
    'content-type': 'text/html; charset=UTF-8'
    'transfer-encoding': 'chunked'
    connection: 'keep-alive'

# List details of a specific linode
exports.list_ip_specific2 = ->
  nock('https://api.linode.com')
  .filteringPath(/api_key=[^&]*/g, 'api_key=fakeapikey')
  .get('/?api_key=fakeapikey&api_action=linode.ip.list&LinodeID=206102')
  .reply 200,
    """
    { "ERRORARRAY":[],
      "DATA":[
          {"IPADDRESSID":133212,"RDNS_NAME":"li463-104.members.linode.com",
          "LINODEID":206097,"ISPUBLIC":1,"IPADDRESS":"176.58.105.104"}
          ],
      "ACTION":"linode.ip.list" }
    """,
    date: 'Fri, 25 May 2012 09:47:40 GMT'
    'content-type': 'text/html; charset=UTF-8'
    'transfer-encoding': 'chunked'
    connection: 'keep-alive'

# Boot Linode
exports.boot = ->
  nock('https://api.linode.com')
  .filteringPath(/api_key=[^&]*/g, 'api_key=fakeapikey')
  .get('/?api_key=fakeapikey&api_action=linode.boot&LinodeID=206097')
  .reply 200,
    """
    { "ERRORARRAY":[],
      "DATA":{"JobID":7761812},
      "ACTION":"linode.boot"
    }
    """,
    date: 'Fri, 25 May 2012 09:47:40 GMT'
    'content-type': 'text/html; charset=UTF-8'
    'transfer-encoding': 'chunked'
    connection: 'keep-alive'

# Create config
exports.create_config = ->
  nock("https://api.linode.com")
  .filteringPath(/api_key=[^&]*/g, 'api_key=fakeapikey')
  .get("/?api_key=fakeapikey&api_action=linode.config.create&LinodeID=206102&KernelID=145&Label=boxecutor&Comments=Box%20execution%20server&DiskList=953010&RootDeviceNum=1")
  .reply 200,
    """
    { "ERRORARRAY":[],
      "DATA":{"ConfigID":491177},
      "ACTION":"linode.config.create"
    }
    """,
    date: 'Fri, 25 May 2012 09:42:39 GMT'
    'content-type': 'text/html; charset=UTF-8'
    'transfer-encoding': 'chunked'
    connection: 'keep-alive'

# Linode create
exports.create = ->
  nock('https://api.linode.com')
  .filteringPath(/api_key=[^&]*/g, 'api_key=fakeapikey')
  .get('/?api_key=fakeapikey&api_action=linode.create&DatacenterID=7&PlanID=1&PaymentTerm=1')
  .reply 200,
    """
    { "ERRORARRAY":[],
      "DATA":{"LinodeID":206102},
      "ACTION":"linode.create"
    }
    """,
    date: 'Fri, 25 May 2012 09:58:25 GMT'
    'content-type': 'text/html; charset=UTF-8'
    'transfer-encoding': 'chunked'
    connection: 'keep-alive'

# Create disk from distribution
exports.create_dist_disk = ->
  nock('https://api.linode.com')
  .filteringPath (path) ->
    return path
      .replace(/api_key=[^&]*/g, 'api_key=fakeapikey')
      .replace(/rootSSHKey=[^&]*/g, 'rootSSHKey=fakesshkey')
      .replace(/rootPass=[^&]*/g, 'rootPass=fakepass')
  .get('/?api_key=fakeapikey&api_action=linode.disk.createfromdistribution&LinodeID=206102&DistributionID=98&Label=system&Size=20000&rootPass=fakepass&rootSSHKey=fakesshkey')
  .reply 200,
    """
    { "ERRORARRAY":[],
      "DATA":{"JobID":7761742,"DiskID":953010},
      "ACTION":"linode.disk.createfromdistribution"
    }
    """,
    date: 'Fri, 25 May 2012 09:36:45 GMT'
    'content-type': 'text/html; charset=UTF-8'
    'transfer-encoding': 'chunked'
    connection: 'keep-alive'

# ext3 Disk create
exports.create_disk = ->
  nock("https://api.linode.com")
  .filteringPath(/api_key=[^&]*/g, 'api_key=fakeapikey')
  .get('/?api_key=fakeapikey&api_action=linode.disk.create&LinodeID=206097&Label=data&Type=ext3&Size=10000')
  .reply 200,
    """
    { "ERRORARRAY":[],
      "DATA":{"JobID":7761743,"DiskID":953011},
      "ACTION":"linode.disk.create"
    }
    """,
    date: "Fri, 25 May 2012 09:36:45 GMT"
    "content-type": "text/html; charset=UTF-8"
    "transfer-encoding": "chunked"
    connection: "keep-alive"

# Linode list
exports.list = ->
  return nock('https://api.linode.com')
  .filteringPath(/api_key=[^&]*/g, 'api_key=fakeapikey')
  .get('/?api_key=fakeapikey&api_action=linode.list&')
  .reply 200,
    """
    { "ERRORARRAY":[],
      "DATA":[
        {"ALERT_CPU_ENABLED":1,"ALERT_BWIN_ENABLED":1,
         "BACKUPSENABLED":0,"ALERT_CPU_THRESHOLD":90,
         "ALERT_BWQUOTA_ENABLED":1,"LABEL":"boxecutor-0",
         "ALERT_DISKIO_THRESHOLD":1000,"BACKUPWEEKLYDAY":0,
         "BACKUPWINDOW":0,"WATCHDOG":1,"DATACENTERID":7,
         "STATUS":1,"ALERT_DISKIO_ENABLED":1,"TOTALHD":20480,
         "LPM_DISPLAYGROUP":"","TOTALXFER":200,
         "ALERT_BWQUOTA_THRESHOLD":80,"TOTALRAM":512,
         "LINODEID":206097,"ALERT_BWIN_THRESHOLD":5,
         "ALERT_BWOUT_THRESHOLD":5,"ALERT_BWOUT_ENABLED":1
         },
         {"ALERT_CPU_ENABLED":1,"ALERT_BWIN_ENABLED":1,
          "BACKUPSENABLED":0,"ALERT_CPU_THRESHOLD":90,
          "ALERT_BWQUOTA_ENABLED":1,"LABEL":"boxecutor-2",
          "ALERT_DISKIO_THRESHOLD":1000,"BACKUPWEEKLYDAY":0,
          "BACKUPWINDOW":0,"WATCHDOG":1,"DATACENTERID":7,
          "STATUS":0,"ALERT_DISKIO_ENABLED":1,"TOTALHD":20480,
          "LPM_DISPLAYGROUP":"","TOTALXFER":200,
          "ALERT_BWQUOTA_THRESHOLD":80,"TOTALRAM":512,
          "LINODEID":206102,"ALERT_BWIN_THRESHOLD":5,
          "ALERT_BWOUT_THRESHOLD":5,"ALERT_BWOUT_ENABLED":1
          }
       ],
       "ACTION":"linode.list"
    }
    """,
    date: 'Fri, 25 May 2012 09:59:05 GMT'
    'content-type': 'text/html; charset=UTF-8'
    'transfer-encoding': 'chunked'
    connection: 'keep-alive'

# Reboot
exports.reboot = ->
  return nock('https://api.linode.com')
  .filteringPath(/api_key=[^&]*/g, 'api_key=fakeapikey')
  .get('/?api_key=fakeapikey&api_action=linode.reboot&LinodeID=206097')
  .reply 200,
    """
    { "ERRORARRAY":[],
      "DATA":{"JobID":7761849},
      "ACTION":"linode.reboot"
    }
    """,
  date: 'Fri, 25 May 2012 09:52:15 GMT'
  'content-type': 'text/html; charset=UTF-8'
  'transfer-encoding': 'chunked'
  connection: 'keep-alive'

# Shutdown
exports.shutdown = ->
  nock('https://api.linode.com')
  .filteringPath(/api_key=[^&]*/g, 'api_key=fakeapikey')
  .get('/?api_key=fakeapikey&api_action=linode.shutdown&LinodeID=206097')
  .reply 200,
  """
  { "ERRORARRAY":[],
    "DATA":{"JobID":7761850},
    "ACTION":"linode.shutdown"
  }
  """,
  date: 'Fri, 25 May 2012 09:52:15 GMT'
  'content-type': 'text/html; charset=UTF-8'
  'transfer-encoding': 'chunked'
  connection: 'keep-alive'

# Linode update
exports.linode_update = ->
  return nock('https://api.linode.com')
  .filteringPath (path) ->
    return path
      .replace(/Label=[^&]*/, 'Label=boxecutor')
      .replace(/api_key=[^&]*/, 'api_key=fakeapikey')
  .get('/?api_key=fakeapikey&api_action=linode.update&LinodeID=206102&Label=boxecutor')
  .reply 200,
   """
   { "ERRORARRAY":[],
     "DATA":{"LinodeID":206097},
     "ACTION":"linode.update"
   }
   """,
  date: 'Fri, 25 May 2012 09:55:42 GMT'
  'content-type': 'text/html; charset=UTF-8'
  'transfer-encoding': 'chunked'
  connection: 'keep-alive'

exports.linode_fresh = ->
  return nock('https://api.linode.com')
  # 206102 must match the LinodeID returned in the call to linode.create.
  .filteringPath(/api_key=[^&]*/g, 'api_key=fakeapikey')
  .get('/?api_key=fakeapikey&api_action=linode.list&LinodeID=206102')
  .reply 200,
    """
    { "ERRORARRAY":[],
      "DATA":
        [
          {"ALERT_CPU_ENABLED":1,"ALERT_BWIN_ENABLED":1,
           "BACKUPSENABLED":0,"ALERT_CPU_THRESHOLD":90,
           "ALERT_BWQUOTA_ENABLED":1,"LABEL":"boxecutor-2",
           "ALERT_DISKIO_THRESHOLD":1000,"BACKUPWEEKLYDAY":0,
           "BACKUPWINDOW":0,"WATCHDOG":1,"DATACENTERID":7,"STATUS":0,
           "ALERT_DISKIO_ENABLED":1,"TOTALHD":20480,"LPM_DISPLAYGROUP":"",
           "TOTALXFER":200,"ALERT_BWQUOTA_THRESHOLD":80,"TOTALRAM":512,
           "LINODEID":206102,"ALERT_BWIN_THRESHOLD":5,
           "ALERT_BWOUT_THRESHOLD":5,"ALERT_BWOUT_ENABLED":1}
         ],
      "ACTION":"linode.list"
    }
    """,
  date: 'Fri, 25 May 2012 10:04:00 GMT'
  'content-type': 'text/html; charset=UTF-8'
  'transfer-encoding': 'chunked'
  connection: 'keep-alive'

exports.linode_running = ->
  nock('https://api.linode.com')
  .filteringPath(/api_key=[^&]*/g, 'api_key=fakeapikey')
  .get('/?api_key=fakeapikey&api_action=linode.list&LinodeID=206097')
  .reply 200,
    """
    { "ERRORARRAY":[],
      "DATA":
        [
          {"ALERT_CPU_ENABLED":1,"ALERT_BWIN_ENABLED":1,
           "BACKUPSENABLED":0,"ALERT_CPU_THRESHOLD":90,
           "ALERT_BWQUOTA_ENABLED":1,"LABEL":"test",
           "ALERT_DISKIO_THRESHOLD":1000,"BACKUPWEEKLYDAY":0,
           "BACKUPWINDOW":0,"WATCHDOG":1,"DATACENTERID":7,"STATUS":2,
           "ALERT_DISKIO_ENABLED":1,"TOTALHD":20480,"LPM_DISPLAYGROUP":"",
           "TOTALXFER":200,"ALERT_BWQUOTA_THRESHOLD":80,"TOTALRAM":512,
           "LINODEID":206097,"ALERT_BWIN_THRESHOLD":5,
           "ALERT_BWOUT_THRESHOLD":5,"ALERT_BWOUT_ENABLED":1}
         ],
      "ACTION":"linode.list"
    }
    """,
  date: 'Fri, 25 May 2012 10:04:00 GMT'
  'content-type': 'text/html; charset=UTF-8'
  'transfer-encoding': 'chunked'
  connection: 'keep-alive'

exports.linode_shutdown = ->
  nock('https://api.linode.com')
  .filteringPath(/api_key=[^&]*/g, 'api_key=fakeapikey')
  .get('/?api_key=fakeapikey&api_action=linode.list&LinodeID=206097')
  .reply 200,
    """
    { "ERRORARRAY":[],
      "DATA":
        [
          {"ALERT_CPU_ENABLED":1,"ALERT_BWIN_ENABLED":1,
           "BACKUPSENABLED":0,"ALERT_CPU_THRESHOLD":90,
           "ALERT_BWQUOTA_ENABLED":1,"LABEL":"test",
           "ALERT_DISKIO_THRESHOLD":1000,"BACKUPWEEKLYDAY":0,
           "BACKUPWINDOW":0,"WATCHDOG":1,"DATACENTERID":7,
           "STATUS":1,"ALERT_DISKIO_ENABLED":1,"TOTALHD":20480,
           "LPM_DISPLAYGROUP":"","TOTALXFER":200,
           "ALERT_BWQUOTA_THRESHOLD":80,"TOTALRAM":512,
           "LINODEID":206097,"ALERT_BWIN_THRESHOLD":5,
           "ALERT_BWOUT_THRESHOLD":5,"ALERT_BWOUT_ENABLED":1
           }
         ],
      "ACTION":"linode.list"
    }
    """,
  date: 'Fri, 25 May 2012 10:03:04 GMT'
  'content-type': 'text/html; charset=UTF-8'
  'transfer-encoding': 'chunked'
  connection: 'keep-alive'

# Available distributions
exports.avail_distro = ->
  return nock("https://api.linode.com")
    .filteringPath(/api_key=[^&]*/g, 'api_key=fakeapikey')
    .get("/?api_key=fakeapikey&api_action=avail.distributions&")
    .reply 200,
      """
      {"ERRORARRAY":[],
        "DATA":
          [
            {"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":90,"IS64BIT":0,
            "LABEL":"Arch Linux 2011.08","MINIMAGESIZE":500,
            "CREATE_DT":"2011-09-26 17:18:05.0"},
            {"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":91,"IS64BIT":1,"LABEL":"Arch Linux 2011.08 64bit","MINIMAGESIZE":500,"CREATE_DT":"2011-09-26 17:18:05.0"},
            {"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":88,"IS64BIT":0,"LABEL":"CentOS 6.2","MINIMAGESIZE":800,"CREATE_DT":"2011-07-19 11:38:20.0"},
            {"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":89,"IS64BIT":1,"LABEL":"CentOS 6.2 64bit","MINIMAGESIZE":800,"CREATE_DT":"2011-07-19 11:38:20.0"},
            {"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":77,"IS64BIT":0,"LABEL":"Debian 6","MINIMAGESIZE":550,"CREATE_DT":"2011-02-08 16:54:31.0"},
            {"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":78,"IS64BIT":1,"LABEL":"Debian 6 64bit","MINIMAGESIZE":550,"CREATE_DT":"2011-02-08 16:54:31.0"},
            {"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":94,"IS64BIT":0,"LABEL":"Fedora 16","MINIMAGESIZE":1000,"CREATE_DT":"2012-04-09 14:12:04.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":95,"IS64BIT":1,"LABEL":"Fedora 16 64bit","MINIMAGESIZE":1000,"CREATE_DT":"2012-04-09 14:12:32.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":72,"IS64BIT":0,"LABEL":"Gentoo","MINIMAGESIZE":1000,"CREATE_DT":"2010-09-13 00:00:00.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":53,"IS64BIT":1,"LABEL":"Gentoo 64bit","MINIMAGESIZE":1000,"CREATE_DT":"2009-04-04 00:00:00.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":96,"IS64BIT":0,"LABEL":"openSUSE 12.1","MINIMAGESIZE":1000,"CREATE_DT":"2012-04-13 11:43:30.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":97,"IS64BIT":1,"LABEL":"openSUSE 12.1 64bit","MINIMAGESIZE":1000,"CREATE_DT":"2012-04-13 11:43:30.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":86,"IS64BIT":0,"LABEL":"Slackware 13.37","MINIMAGESIZE":600,"CREATE_DT":"2011-06-05 15:11:59.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":87,"IS64BIT":1,"LABEL":"Slackware 13.37 64bit","MINIMAGESIZE":600,"CREATE_DT":"2011-06-05 15:11:59.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":64,"IS64BIT":0,"LABEL":"Ubuntu 10.04 LTS","MINIMAGESIZE":450,"CREATE_DT":"2010-04-29 00:00:00.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":65,"IS64BIT":1,"LABEL":"Ubuntu 10.04 LTS 64bit","MINIMAGESIZE":450,"CREATE_DT":"2010-04-29 00:00:00.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":92,"IS64BIT":0,"LABEL":"Ubuntu 11.10","MINIMAGESIZE":750,"CREATE_DT":"2011-10-14 14:29:42.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":93,"IS64BIT":1,"LABEL":"Ubuntu 11.10 64bit","MINIMAGESIZE":850,"CREATE_DT":"2011-10-14 14:29:42.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":98,"IS64BIT":0,"LABEL":"Ubuntu 12.04 LTS","MINIMAGESIZE":600,"CREATE_DT":"2012-04-26 17:25:16.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":99,"IS64BIT":1,"LABEL":"Ubuntu 12.04 LTS 64bit","MINIMAGESIZE":600,"CREATE_DT":"2012-04-26 17:25:16.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":59,"IS64BIT":0,"LABEL":"CentOS 5.6","MINIMAGESIZE":950,"CREATE_DT":"2009-08-17 00:00:00.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":60,"IS64BIT":1,"LABEL":"CentOS 5.6 64bit","MINIMAGESIZE":950,"CREATE_DT":"2009-08-17 00:00:00.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":50,"IS64BIT":0,"LABEL":"Debian 5.0","MINIMAGESIZE":350,"CREATE_DT":"2009-02-19 00:00:00.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":51,"IS64BIT":1,"LABEL":"Debian 5.0 64bit","MINIMAGESIZE":350,"CREATE_DT":"2009-02-19 00:00:00.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":84,"IS64BIT":0,"LABEL":"Fedora 15","MINIMAGESIZE":900,"CREATE_DT":"2011-05-25 18:57:36.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":85,"IS64BIT":1,"LABEL":"Fedora 15 64bit","MINIMAGESIZE":900,"CREATE_DT":"2011-05-25 18:58:07.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":79,"IS64BIT":0,"LABEL":"openSUSE 11.4","MINIMAGESIZE":650,"CREATE_DT":"2011-03-10 11:36:46.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":80,"IS64BIT":1,"LABEL":"openSUSE 11.4 64bit","MINIMAGESIZE":650,"CREATE_DT":"2011-03-10 11:36:46.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":68,"IS64BIT":0,"LABEL":"Slackware 13.1","MINIMAGESIZE":512,"CREATE_DT":"2010-05-10 00:00:00.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":69,"IS64BIT":1,"LABEL":"Slackware 13.1 64bit","MINIMAGESIZE":512,"CREATE_DT":"2010-05-10 00:00:00.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":82,"IS64BIT":0,"LABEL":"Ubuntu 11.04","MINIMAGESIZE":500,"CREATE_DT":"2011-04-28 16:28:48.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":83,"IS64BIT":1,"LABEL":"Ubuntu 11.04 64bit","MINIMAGESIZE":500,"CREATE_DT":"2011-04-28 16:28:48.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":41,"IS64BIT":0,"LABEL":"Ubuntu 8.04 LTS","MINIMAGESIZE":350,"CREATE_DT":"2008-04-23 15:11:29.0"},{"REQUIRESPVOPSKERNEL":1,"DISTRIBUTIONID":42,"IS64BIT":1,"LABEL":"Ubuntu 8.04 LTS 64bit","MINIMAGESIZE":350,"CREATE_DT":"2008-06-03 12:51:11.0"}],"ACTION":"avail.distributions"}
            """,
  date: "Mon, 28 May 2012 08:42:10 GMT"
  "content-type": "text/html; charset=UTF-8"
  "transfer-encoding": "chunked"
  connection: "keep-alive"

# Linode plans
exports.plans = ->
  return nock("https://api.linode.com:443")
  .filteringPath(/api_key=[^&]*/g, 'api_key=fakeapikey')
  .get("/?api_key=fakeapikey&api_action=avail.LinodePlans&")
  .reply 200,
    """
    { "ERRORARRAY":[],
      "DATA":
        [{"PRICE":19.95,"RAM":512,"XFER":200,"PLANID":1,"LABEL":"Linode 512","AVAIL":{"3":322,"2":394,"7":293,"6":506,"4":271,"8":112},"DISK":20},{"PRICE":29.95,"RAM":768,"XFER":300,"PLANID":2,"LABEL":"Linode 768","AVAIL":{"3":313,"2":174,"7":109,"6":167,"4":192,"8":267},"DISK":30},{"PRICE":39.95,"RAM":1024,"XFER":400,"PLANID":3,"LABEL":"Linode 1024","AVAIL":{"3":33,"2":65,"7":96,"6":55,"4":109,"8":73},"DISK":40},{"PRICE":59.95,"RAM":1536,"XFER":600,"PLANID":4,"LABEL":"Linode 1536","AVAIL":{"3":21,"2":96,"7":106,"6":21,"4":43,"8":23},"DISK":60},{"PRICE":79.95,"RAM":2048,"XFER":800,"PLANID":5,"LABEL":"Linode 2048","AVAIL":{"3":16,"2":72,"7":80,"6":16,"4":32,"8":17},"DISK":80},{"PRICE":159.95,"RAM":4096,"XFER":1600,"PLANID":6,"LABEL":"Linode 4GB","AVAIL":{"3":2,"2":4,"7":6,"6":6,"4":3,"8":2},"DISK":160},{"PRICE":319.95,"RAM":8192,"XFER":2000,"PLANID":7,"LABEL":"Linode 8GB","AVAIL":{"3":3,"2":7,"7":12,"6":11,"4":6,"8":3},"DISK":320},{"PRICE":479.95,"RAM":12288,"XFER":2000,"PLANID":8,"LABEL":"Linode 12GB","AVAIL":{"3":3,"2":7,"7":12,"6":11,"4":6,"8":3},"DISK":480},{"PRICE":639.95,"RAM":16384,"XFER":2000,"PLANID":9,"LABEL":"Linode 16GB","AVAIL":{"3":3,"2":7,"7":12,"6":11,"4":6,"8":3},"DISK":640},{"PRICE":799.95,"RAM":20480,"XFER":2000,"PLANID":10,"LABEL":"Linode 20GB","AVAIL":{"3":3,"2":7,"7":12,"6":11,"4":6,"8":3},"DISK":800}],"ACTION":"avail.LinodePlans"}
    """,
  date: "Mon, 28 May 2012 08:42:11 GMT"
  "content-type": "text/html; charset=UTF-8"
  "transfer-encoding": "chunked"
  connection: "keep-alive"

exports.avail_kernels = ->
  return nock("https://api.linode.com")
  .filteringPath(/api_key=[^&]*/g, 'api_key=fakeapikey')
  .get("/?api_key=fakeapikey&api_action=avail.kernels&")
  .reply 200,
    """
    {"ERRORARRAY":[],"DATA":[{"LABEL":"Latest 3.0 (3.0.18-linode43)","ISXEN":1,"ISPVOPS":1,"KERNELID":137},{"LABEL":"3.0.18-linode43","ISXEN":1,"ISPVOPS":1,"KERNELID":149},{"LABEL":"3.1.10-linode42","ISXEN":1,"ISPVOPS":1,"KERNELID":148},{"LABEL":"3.2.1-linode40","ISXEN":1,"ISPVOPS":1,"KERNELID":145},{"LABEL":"Latest 3.0 (3.0.18-x86_64-linode24)","ISXEN":1,"ISPVOPS":1,"KERNELID":138},{"LABEL":"3.0.18-x86_64-linode24","ISXEN":1,"ISPVOPS":1,"KERNELID":150},{"LABEL":"3.2.1-x86_64-linode23","ISXEN":1,"ISPVOPS":1,"KERNELID":146},{"LABEL":"pv-grub-x86_32","ISXEN":1,"ISPVOPS":0,"KERNELID":92},{"LABEL":"pv-grub-x86_64","ISXEN":1,"ISPVOPS":0,"KERNELID":95},{"LABEL":"Recovery - Finnix (kernel)","ISXEN":1,"ISPVOPS":0,"KERNELID":61},{"LABEL":"Latest 2.6 (2.6.39.1-linode34)","ISXEN":1,"ISPVOPS":1,"KERNELID":110},{"LABEL":"Latest Legacy (2.6.18.8-linode22)","ISXEN":1,"ISPVOPS":0,"KERNELID":60},{"LABEL":"2.6.18.8-domU-linode7","ISXEN":1,"ISPVOPS":0,"KERNELID":81},{"LABEL":"2.6.18.8-linode10","ISXEN":1,"ISPVOPS":0,"KERNELID":89},{"LABEL":"2.6.18.8-linode16","ISXEN":1,"ISPVOPS":0,"KERNELID":98},{"LABEL":"2.6.18.8-linode19","ISXEN":1,"ISPVOPS":0,"KERNELID":103},{"LABEL":"2.6.18.8-linode22","ISXEN":1,"ISPVOPS":0,"KERNELID":113},{"LABEL":"2.6.24.4-linode8","ISXEN":1,"ISPVOPS":1,"KERNELID":84},{"LABEL":"2.6.25-linode9","ISXEN":1,"ISPVOPS":1,"KERNELID":88},{"LABEL":"2.6.25.10-linode12","ISXEN":1,"ISPVOPS":1,"KERNELID":90},{"LABEL":"2.6.26-linode13","ISXEN":1,"ISPVOPS":1,"KERNELID":91},{"LABEL":"2.6.27.4-linode14","ISXEN":1,"ISPVOPS":1,"KERNELID":93},{"LABEL":"2.6.28-linode15","ISXEN":1,"ISPVOPS":1,"KERNELID":96},{"LABEL":"2.6.28.3-linode17","ISXEN":1,"ISPVOPS":1,"KERNELID":99},{"LABEL":"2.6.29-linode18","ISXEN":1,"ISPVOPS":1,"KERNELID":101},{"LABEL":"2.6.30.5-linode20","ISXEN":1,"ISPVOPS":1,"KERNELID":105},{"LABEL":"2.6.31.5-linode21","ISXEN":1,"ISPVOPS":1,"KERNELID":109},{"LABEL":"2.6.32-linode23","ISXEN":1,"ISPVOPS":1,"KERNELID":115},{"LABEL":"2.6.32.12-linode25","ISXEN":1,"ISPVOPS":1,"KERNELID":119},{"LABEL":"2.6.32.16-linode28","ISXEN":1,"ISPVOPS":1,"KERNELID":123},{"LABEL":"2.6.33-linode24","ISXEN":1,"ISPVOPS":1,"KERNELID":117},{"LABEL":"2.6.34-linode27","ISXEN":1,"ISPVOPS":1,"KERNELID":120},{"LABEL":"2.6.35.7-linode29","ISXEN":1,"ISPVOPS":1,"KERNELID":126},{"LABEL":"2.6.37-linode30","ISXEN":1,"ISPVOPS":1,"KERNELID":127},{"LABEL":"2.6.38-linode31","ISXEN":1,"ISPVOPS":1,"KERNELID":128},{"LABEL":"2.6.38.3-linode32","ISXEN":1,"ISPVOPS":1,"KERNELID":130},{"LABEL":"2.6.39-linode33","ISXEN":1,"ISPVOPS":1,"KERNELID":131},{"LABEL":"2.6.39.1-linode34","ISXEN":1,"ISPVOPS":1,"KERNELID":134},{"LABEL":"3.0.0-linode35","ISXEN":1,"ISPVOPS":1,"KERNELID":135},{"LABEL":"3.0.17-linode41","ISXEN":1,"ISPVOPS":1,"KERNELID":147},{"LABEL":"3.0.4-linode36","ISXEN":1,"ISPVOPS":1,"KERNELID":139},{"LABEL":"3.0.4-linode37","ISXEN":1,"ISPVOPS":1,"KERNELID":141},{"LABEL":"3.0.4-linode38","ISXEN":1,"ISPVOPS":1,"KERNELID":142},{"LABEL":"3.1.0-linode39","ISXEN":1,"ISPVOPS":1,"KERNELID":143},{"LABEL":"Latest 2.6 (2.6.39.1-x86_64-linode19)","ISXEN":1,"ISPVOPS":1,"KERNELID":111},{"LABEL":"Latest Legacy (2.6.18.8-x86_64-linode10)","ISXEN":1,"ISPVOPS":0,"KERNELID":107},{"LABEL":"2.6.16.38-x86_64-linode2","ISXEN":1,"ISPVOPS":0,"KERNELID":85},{"LABEL":"2.6.18.8-x86_64-linode1","ISXEN":1,"ISPVOPS":0,"KERNELID":86},{"LABEL":"2.6.18.8-x86_64-linode10","ISXEN":1,"ISPVOPS":0,"KERNELID":114},{"LABEL":"2.6.18.8-x86_64-linode7","ISXEN":1,"ISPVOPS":0,"KERNELID":104},{"LABEL":"2.6.27.4-x86_64-linode3","ISXEN":1,"ISPVOPS":1,"KERNELID":94},{"LABEL":"2.6.28-x86_64-linode4","ISXEN":1,"ISPVOPS":1,"KERNELID":97},{"LABEL":"2.6.28.3-x86_64-linode5","ISXEN":1,"ISPVOPS":1,"KERNELID":100},{"LABEL":"2.6.29-x86_64-linode6","ISXEN":1,"ISPVOPS":1,"KERNELID":102},{"LABEL":"2.6.30.5-x86_64-linode8","ISXEN":1,"ISPVOPS":1,"KERNELID":106},{"LABEL":"2.6.31.5-x86_64-linode9","ISXEN":1,"ISPVOPS":1,"KERNELID":112},{"LABEL":"2.6.32-x86_64-linode11","ISXEN":1,"ISPVOPS":1,"KERNELID":116},{"LABEL":"2.6.32.12-x86_64-linode12","ISXEN":1,"ISPVOPS":1,"KERNELID":118},{"LABEL":"2.6.32.12-x86_64-linode15","ISXEN":1,"ISPVOPS":1,"KERNELID":124},{"LABEL":"2.6.34-x86_64-linode13","ISXEN":1,"ISPVOPS":1,"KERNELID":121},{"LABEL":"2.6.34-x86_64-linode14","ISXEN":1,"ISPVOPS":1,"KERNELID":122},{"LABEL":"2.6.35.4-x86_64-linode16","ISXEN":1,"ISPVOPS":1,"KERNELID":125},{"LABEL":"2.6.38-x86_64-linode17","ISXEN":1,"ISPVOPS":1,"KERNELID":129},{"LABEL":"2.6.39-x86_64-linode18","ISXEN":1,"ISPVOPS":1,"KERNELID":132},{"LABEL":"2.6.39.1-x86_64-linode19","ISXEN":1,"ISPVOPS":1,"KERNELID":133},{"LABEL":"3.0.0-x86_64-linode20","ISXEN":1,"ISPVOPS":1,"KERNELID":136},{"LABEL":"3.0.4-x86_64-linode21","ISXEN":1,"ISPVOPS":1,"KERNELID":140},{"LABEL":"3.1.0-x86_64-linode22","ISXEN":1,"ISPVOPS":1,"KERNELID":144}],"ACTION":"avail.kernels"}
    """,
  date: "Mon, 28 May 2012 08:42:11 GMT"
  "content-type": "text/html; charset=UTF-8"
  "transfer-encoding": "chunked"
  connection: "keep-alive"

exports.delete = ->
  nock('https://api.linode.com')
  .filteringPath(/api_key=[^&]*/g, 'api_key=fakeapikey')
  .get('/?api_key=fakeapikey&api_action=linode.delete&LinodeID=206097&skipChecks=true')
  .reply 200,
  """
  {"ERRORARRAY":[],"DATA":{"LinodeID":206097},"ACTION":"linode.delete"}
  """,
  date: "Tue, 29 May 2012 10:01:12 GMT"
  "content-type": "text/html; charset=UTF-8"
  "transfer-encoding": "chunked"
  connection: "keep-alive"

exports.update_label = ->
  nock('https://api.linode.com')
  .filteringPath(/api_key=[^&]*/g, 'api_key=fakeapikey')
  .get('/?api_key=fakeapikey&api_action=linode.update&LinodeID=206097&Label=existingname1234')
  .reply 200,
  """
  {"ERRORARRAY":[{"ERRORCODE":8,"ERRORMESSAGE":"This account already has a Linode with that label. Labels must be unique."}],"DATA":{},"ACTION":"linode.update"}
  """,
  date: "Tue, 29 May 2012 10:01:12 GMT"
  "content-type": "text/html; charset=UTF-8"
  "transfer-encoding": "chunked"
  connection: "keep-alive"

# Linode addprivate
exports.addprivate = ->
  return nock("https://api.linode.com")
  .filteringPath(/api_key=[^&]*/g, 'api_key=fakeapikey')
  .get("/?api_key=fakeapikey&api_action=linode.ip.addprivate&LinodeID=206102")
  .reply 200,
    """
      {"ERRORARRAY":[],
       "DATA":{"IPAddressID":48606},
       "ACTION":"linode.ip.addprivate"}
    """,
  date: "Thu, 19 Jul 2012 10:16:00 GMT"
  "content-type": "text/html; charset=UTF-8"
  "transfer-encoding": "chunked"
  connection: "keep-alive"

# Linode DNS create A record
exports.create_dns_a_record_nock = ->
  return nock("https://api.linode.com")
  .filteringPath(/api_key=[^&]*/g, 'api_key=fakeapikey')
  .get("/?api_key=fakeapikey&api_action=domain.resource.create&DomainID=352960&Type=A&Name=boxecutor-1&Target=176.58.105.104&TTL_sec=3600")
  .reply 200,
    """
      {"ERRORARRAY":[],
       "DATA":{"ResourceID":2455048},
       "ACTION":"domain.resource.create"}
    """,
  date: "Tue, 21 Aug 2012 10:31:06 GMT"
  "content-type": "text/html; charset=UTF-8"
  "transfer-encoding": "chunked"

# List a domain's resources
exports.domain_resource_list = ->
  return nock("https://api.linode.com")
  .filteringPath(/api_key=[^&]*/g, 'api_key=fakeapikey')
  .get("/?api_key=fakeapikey&api_action=domain.resource.list&DomainID=352960")
  .reply 200,
    """
      {"ERRORARRAY":[],
       "DATA":[
         {"DOMAINID":352960,"PORT":80,"RESOURCEID":2454924,
          "NAME":"","WEIGHT":5,"TTL_SEC":0,"TARGET":"46.43.55.85",
          "PRIORITY":10,"PROTOCOL":"","TYPE":"A"},
         {"DOMAINID":352960,"PORT":0,"RESOURCEID":2454925,"NAME":"",
          "WEIGHT":0,"TTL_SEC":0,"TARGET":"custmx.cscdns.net",
          "PRIORITY":5,"PROTOCOL":"","TYPE":"MX"},
         {"DOMAINID":352960,"PORT":80,"RESOURCEID":2455909,"NAME":"boxecutor-0",
          "WEIGHT":5,"TTL_SEC":0,"TARGET":"176.58.114.80","PRIORITY":10,
          "PROTOCOL":"","TYPE":"a"},
         {"DOMAINID":352960,"PORT":80,"RESOURCEID":2455777,"NAME":"vanilla-1",
          "WEIGHT":5,"TTL_SEC":3600,"TARGET":"176.58.121.92","PRIORITY":10,
          "PROTOCOL":"","TYPE":"A"},
         {"DOMAINID":352960,"PORT":80,"RESOURCEID":2454926,"NAME":"www",
          "WEIGHT":5,"TTL_SEC":0,"TARGET":"46.43.55.85","PRIORITY":10,
          "PROTOCOL":"","TYPE":"A"}
         ],
        "ACTION":"domain.resource.list"}
    """,
  date: "Wed, 22 Aug 2012 08:25:03 GMT"
  "content-type": "text/html; charset=UTF-8"
  "transfer-encoding": "chunked"
  connection: "keep-alive"

exports.domain_resource_delete = ->
  return nock("https://api.linode.com")
  .filteringPath(/api_key=[^&]*/g, 'api_key=fakeapikey')
  .get("/?api_key=fakeapikey&api_action=domain.resource.delete&DomainID=352960&ResourceID=2455909")
  .reply 200,
    """
      {"ERRORARRAY":[],
       "DATA":{"ResourceID":2455909},
       "ACTION":"domain.resource.delete"}
    """,
  date: "Wed, 22 Aug 2012 08:30:08 GMT"
  "content-type": "text/html; charset=UTF-8"
  "transfer-encoding": "chunked"
  connection: "keep-alive"
