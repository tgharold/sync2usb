Installation from GitHub via git

You will need 'git' to be installed on the system.

Read-only anonymous clone:
$ git clone https://github.com/tgharold/rsync2usb.git
$ cd rsync2usb/
$ git checkout master

Updating the local working copy:
$ git fetch origin
$ git checkout master
$ git merge --ff-only origin/master

