# Lithium

## Controlling sysadmin insanity

Lithium is a system of configurations and a command line tool to 
control cloud based server instances.

### Install ###
To install prequisites:

    npm -f install

(The '-f' ought not to be required, but is, because of a bug in 
the linode API).

### Usage ###

Activate the environment (fiddles with PATH etc):

    . activate

Note, you need to set LINODE\_API\_KEY and LITHIUM\_CONFIG\_PATH.

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

    mocha

Keep the tests running 

    mocha -w

