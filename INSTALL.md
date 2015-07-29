Installation from GitHub via git
=============

You will need 'git' to be installed on the system.

Read-only anonymous clone (users):
------
Use this method if you do not have write-access to the repository.  
This is the best method if you just want to use the software.

    $ git clone https://github.com/tgharold/sync2usb.git
    $ cd sync2usb/
    $ git checkout master

Developer clone:
------
Use this method if you have write-access to the repository.  

    $ git clone git@github.com:tgharold/sync2usb.git
    $ cd sync2usb/
    $ git checkout master


Updating the local working copy:
------
    $ git fetch origin
    $ git checkout master
    $ git merge --ff-only origin/master

