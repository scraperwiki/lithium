nock = require 'nock'

# List details of a specific linode
nock('https://api.linode.com')
  .get('/?api_key=fakeapikey&api_action=linode.ip.list&LinodeID=206097')
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
nock('https://api.linode.com')
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
nock("https://api.linode.com")
  .get("/?api_key=fakeapikey&api_action=linode.config.create
       &LinodeID=206097&KernelID=121&Label=test&Comments=decription
       &DiskList=953010%2C953011&RootDeviceNum=1")
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
nock('https://api.linode.com')
  .get('/?api_key=fakeapikey&api_action=linode.create&DatacenterID=7
       &PlanID=1&PaymentTerm=1')
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
nock('https://api.linode.com')
  .get('/?api_key=fakeapikey&api_action=linode.disk.createfromdistribution
       &LinodeID=206097&DistributionID=98&Label=system&Size=5048
       &rootPass=r00ter')
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
nock("https://api.linode.com")
  .get('/?api_key=fakeapikey&api_action=linode.disk.create
        &LinodeID=206097&Label=data&Type=ext3&Size=10000')
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
nock('https://api.linode.com')
  .get('/?api_key=fakeapikey&api_action=linode.list&')
  .reply 200,
    """
    { "ERRORARRAY":[],
      "DATA":[
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
         },
         {"ALERT_CPU_ENABLED":1,"ALERT_BWIN_ENABLED":1,
          "BACKUPSENABLED":0,"ALERT_CPU_THRESHOLD":90,
          "ALERT_BWQUOTA_ENABLED":1,"LABEL":"linode206102",
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
nock('https://api.linode.com')
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
nock('https://api.linode.com')
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
nock('https://api.linode.com')
  .get('/?api_key=fakeapikey&api_action=linode.update&LinodeID=206097&Label=test')
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

nock('https://api.linode.com')
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
  'x-powered-by': 'Tiger Blood'

nock('https://api.linode.com')
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
