#!/bin/bash

LOGGER=/usr/bin/logger
CRYPTSETUP=/sbin/cryptsetup

$LOGGER -t "udev_luksOpen.sh" -is "EXECUTE: $0 $1 $2 $3"

$CRYPTSETUP luksOpen --key-file $3 "/dev/disk/by-uuid/$1" "$2"

