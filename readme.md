Lithium

Controlling sysadmin insanity

Lithium is a system of configurations and a command line tool to
control cloud based server instances.

To install prequisites:

    npm -f install

(The '-f' ought not to be required, but is, because of a bug in
the linode API).

Activate the environment (fiddles with PATH etc):

    . ./activate

(pro tip: if you use bash then you can type '. activate'
instead.  booyah!)

To run the tests

    mocha

Keep the tests running (BDD mode):

    mocha -w

