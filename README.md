# sync2usb
Wrapper script for rsync to export files to one or more USB backup drive(s).  

This is not a backup script itself, but is designed to copy existing backup
files off the local system and onto a removable USB drive.  Therefore, it makes
a few assumptions:

- You have already written your backup to disk somewhere.
- The backup files are collected in a directory.
- You want to write the files to a similarly named directory on the USB drive.
- In the case of multiple USB drives, they all have similar names.
- If two or more drives are hooked up, it's okay to randomly pick one.

The script offers optional support for LVM snapshots.  If your backup files are
located on a Logical Volume (LV), then sync2usb can create a snapshot of the LV
before starting the rsync.  This should result in your backup files being
internally consistent on the USB drive.

# Auto-mounting of USB drives

See AUTOFS.md and LUKS.md.

# Basic design goals

- Central global settings file at /etc/rsync2usb.conf
- user-level settings file at ~/.rsync2usb.conf
- job specification files at ~/.rsync2usb/*.job
- jobs get run in random ordering (configurable)
- crontab entry should be as simple as /usr/local/bin/rsync2usb
- need an install script to create the symlink in /usr/local/bin
- need an uninstall script to remove the symlink in /usr/local/bin
- check for USB drive running out of space
- automount / encryption is handled by autofs and LUKS, not this package
- use a lock file to control access to USB drive
- allow for multiple backup paths to be specified (one chosen at random)
- needs to work on RHEL5, CentoOS6 and Cygwin64 at a minimum
- depends on the rsync command




