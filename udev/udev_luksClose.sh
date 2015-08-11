#!/bin/bash

LOGGER=/usr/bin/logger
CRYPTSETUP=/sbin/cryptsetup

$LOGGER -t "udev_luksClose.sh" -is "EXECUTE: $0 $1 $2"

umount "/mnt/$1/$2"
$CRYPTSETUP luksClose "/dev/mapper/$2"

