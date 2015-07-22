# rsync2usb
Wrapper script for rsync to export files to USB backup drive

# Basic design goals

- Central global settings file at /etc/rsync2usb.conf
- user-level settings file at ~/.rsync2usb.conf
- job specification files at ~/.rsync2usb/*.job
- jobs get run in random ordering (configurable)
- crontab entry should be as simple as /usr/local/bin/rsync2usb
- need an install script to create the symlink in /usr/local/bin
- need an uninstall script to remove the symlink in /usr/local/bin
- script should capture output and email to admins on error
- check for USB drive running out of space
- automount / encryption is handled by autofs and LUKS, not this package
- use a lock file to control access to USB drive
- allow for multiple backup paths to be specified (one chosen at random)
- needs to work on RHEL5, CentoOS6 and Cygwin64 at a minimum
- depends on the mailx command and rsync command




