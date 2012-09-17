# Lithium

## Controlling sysadmin insanity

Lithium is a system of configurations and a command line tool to 
control cloud based server instances. Currently it supports Linode.

### Install ###
To install prequisites:

    npm -f install

(The '-f' ought not to be required, but is, because of a bug in 
the linode-api package).

### Keeping Current ###

Every now and then you'll need to get fresh copies of the
sources (when they change, for example).  There are lots of
interlinked repositories.  Assuming these have already been set
up in adjacent directories and you are already in the directory
that contains them all, then:

    for a in lithium/ swops/ swops-secret/ cobalt/
    do
        (cd $a;git pull)
    done

### Usage ###

Activate the environment (fiddles with PATH etc):

    . activate

The environment variables LINODE\_API\_KEY and LITHIUM\_CONFIG\_PATH
need to be set, but usually the activate script will set these
as long as it finds the 'swops-secret' repository alongside this
one.

    Usage: li <command> OPTIONS
            list      List instances
            create    Create a instance by config
            destroy   Destroy an instance

            start     Start an instance
            stop      Stop an instance
            restart   Restart an instance
            sh        Execute a command on an instance
            deploy    Run deployment hooks on an instance [OBSOLESCENT]

### Tests ###

Note: Make sure LITHIUM\_CONFIG\_PATH and LINODE\_API\_KEY are unset before running the tests.

To run the tests

    LITHIUM_CONFIG_PATH= mocha

Keep the tests running 

    mocha -w


### Using Lithium ###

Using lithium spends money.  Not much.

    li
    li list
    li create boxecutor
    li start boxecutor_1
    li deploy boxecutor_1

### Server States ###

                              .---------stop----------.
                              v                       |
    +-----+            +-------------+           +---------+
    |     | --create-> | not running | --start-> | running |
    +-----+            +-------------+           +---------+
       ^                      |                       |
       `-------------------destroy--------------------'
                            


