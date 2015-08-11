# LUKS (Linux Unified Key Setup)

- what it is
- why you would want to use it

# Interaction with Autofs

# Creating a keyfile

Whether or not you use keyfiles to protect your USB backup drive is determined by what
threat you are trying to protect against.  For example, if you are defending against
a non-sophisicated attacker (i.e. a common pawn-shop thief), then using a keyfile stored
on the server is not a big risk.  On the other hand, if you have stricter requirements
and need to defend against more sophisticated attackers, then you will need to use
a smart-card / key-fob / hand-enter the password on each mount.

My assumption in this document is that a keyfile, stored in the /root directory, is
secure enough for your purposes.  The protection level here is such, that if you 
lose the USB drive in a parking lot, you don't have to worry that someone who
finds the drive will be able to access the contents.

## Creating a keyfile

(insert command to create a new keyfile, and chmod/chown it properly)

# Preparing the drive

## Find the drive

## Partition it with `parted`

## Verify the drive

## Shred the drive

## Format with `cryptsetup`

## Add the keyfile

## Modify udev.d rules

(and trigger the UDEV system)

## Modify autofs configuration file

## mkfs

# luksOpen/luksClose scripts

# UDEV(cap?) rules

# Updating AutoFS(?)

# Using the drive

