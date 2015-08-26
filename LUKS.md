# LUKS (Linux Unified Key Setup)

- what it is
- why you would want to use it

## Reference links

- https://wiki.archlinux.org/index.php/Dm-crypt
- http://ubuntuforums.org/showthread.php?t=837416

# Interaction with Autofs

Interaction with `autofs` is pretty straightforward.  Through `udev` rules,
you can have your USB drive partition automatically attached as
`/dev/mapper/SOMETHING` and just have `autofs` look for that volume instead
of looking for a `/dev/disk/by-id` or `/dev/disk/by-uuid` partiton.

# Using a keyfile to unlock

Whether or not you use keyfiles to protect your USB backup drive is
determined by what threat you are trying to protect against.  For example,
if you are defending against a low-level attacker (i.e. a common pawn-shop
thief), then using a keyfile stored on the server is not a big risk.  On
the other hand, if you have stricter requirements and need to defend
against more sophisticated attackers, then you will need to use a smart-
card / key-fob / hand-enter the password on each mount.

My assumption in this document is that a keyfile, stored in the /root
directory, is secure enough for your purposes.  The protection level here
is such, that if you lose the USB drive in a parking lot, you don't have to
worry that someone who finds the drive will be able to access the contents.

## Creating a keyfile

Creation of a keyfile is not difficult.  The following creates a 256 byte
file (2048 bits) which is overkill for most purposes.  You could get by
with a 64 or 128 byte file, or go a larger with 512 or 1024 byte files.
Note that since this uses `/dev/random` which blocks, it may take dozens of
seconds to create the 256 byte file. Smaller files (64 or 128 byte) will
generate faster.

```
$ sudo dd if=/dev/random of=/root/usb-keyfile bs=256 count=1 iflag=fullblock
$ sudo chown root:root /root/usb-keyfile
$ sudo chmod 0600 /root/usb-keyfile
```

After creating the keyfile, you should use GPG to encrypt
it and then mail a copy to yourself.  Or place a copy on a 
[M-Disc](https://en.wikipedia.org/wiki/M-DISC) and store that disc in a secure
location (safe, safe deposit box).  Without the keyfile or the password
used to encrypt the LUKS volume, you will not be able to recover the
contents of the USB drive.

## Choose a passphrase

The size of the passphrase that you choose should be at least 128 bits, and
preferably 160 bits. If you use a tool that generates completely random
output using upper-case letters, lower-case letters and numbers, then you
can use a passphrase as short as 32-35 characters.  But I suggest something
in the 40-50 character range (or longer) for safety.  A suitable one-liner
that generates a random passphrase is:

```
$ echo $(dd if=/dev/random bs=256 count=1 iflag=fullblock 2>/dev/null | tr -dc 'a-zA-Z0-9')
pkjZ92N8eNETvUxLfeYWlYdXBarLpN8XmdJigbQLepHs5tVWVQTJmZSRuQPqek7v
```

As with the keyfile, you should plan on storing this password somewhere
secure (i.e. with GPG) and don't leave it laying around in plain-text
anywhere.  Consider this to be your recovery password in case the keyfile
gets lost or destroyed.

# Preparing the drive

## Find the drive

The easiest way that I find for searching for USB attached disks is the
`/dev/disk/by-id` path under Linux. If you sort by modification time, the
most recently plugged in drive will be at the top of the list.

For example, here is the 5TB Hitachi drive that I just plugged into my external USB enclosure:

```
$ sudo ls -lt /dev/disk/by-id/ | grep 'usb'
lrwxrwxrwx. 1 root root  9 Aug 11 05:17 usb-HGST_HDN_1234ABC789_123456-0:0 -> ../../sdp
```

I strongly suggest that you always use the `/dev/disk/by-id/` name to refer
to your drives rather then relying on `/dev/sdX` drive identifiers.  The
values under `by-id` are consistent across reboots, disconnects, or other
changes in which drives are active.  Drive identifiers like `sda`, on the
other hand, can and will frequently change.

However, if you have partitions on the disk, an alternative is to use the
`/dev/disk/by-uuid/` values which are also consistent across reboots and
system changes.

## Partition it with `parted`

`$ sudo parted /dev/disk/by-id/usb-HGST_HDN_1234ABC789_123456-0\:0`

Assuming the drive is blank, then your first command will be `mklabel gpt`.
You can verify that the drive is blank, by using the `print` command inside
of `parted`.

The rest of commands that I use when setting up a disk are:

- `unit mb` - Switches the units from blocks to megabytes
- `mkpart primary 1 -1` - Creates a maximum size partition that is correctly aligned
- `set 1 hidden on` - Hide the partition
- `print` - Verify your changes
- `quit` - Exit parted

Please note that after partitioning the drive, we refer to the first
partition by appending `-part1` to the end of the `/dev/disk/by-id/` value.
This is important during the `badblocks` and `shred` phase so that we do
not overwrite the partition table that was just created.

## Verify the drive

There is nothing worse then pulling a backup drive out of the padded bag
and finding that your drive won't spin up, or that it has bad sectors, or
other forms of bit-rot.  Therefore, I still recommend a period of "burn-in"
where you exercise the drive for a few days before putting it into active
service.  The goal of a "burn-in" is to trigger an early failure for a
drive that is of marginal quality, and to make sure that the drive can
handle the load.

`$ sudo badblocks -wsv -p 5 -t random /dev/disk/by-id/usb-HGST_HDN_1234ABC789_123456-0\:0-part1`

That uses the `badblocks` program to write random patterns to the disk over
and over again until at least five passes do not have any errors.
Depending on the size of your drive and whether you are using USB 2.0 or
USB 3.0, this test might take two to five days.  

If you see *any* errors at all during the `badblocks` testing, then you
should investigate whether it is your hard drive, or the USB cable or the
USB ports or bad RAM.  Marginal hardware produces marginal backups -- which
can lead to lost data down the road.  Any device that cannot handle a few
days of heavy use during burn-in will likely not hold up over long-term use.

## Shred the drive

Shredding the drive writes a cryptographically strong random pattern to the
drive, which will hide how much of the drive has been used by LUKS for
actual data storage.  Against the simple and low technology attacker it is
not important, but it is still strongly suggested.

`$ sudo shred -v /dev/disk/by-id/usb-HGST_HDN_1234ABC789_123456-0\:0-part1`

## Format with `cryptsetup`

`$ sudo cryptsetup luksFormat /dev/disk/by-id/usb-HGST_HDN_1234ABC789_123456-0\:0-part1`

You will be prompted for a passphrase which can be used to unlock the volume.

## Add the keyfile

LUKS volumes can have multiple passphrases or keyfiles associated with
them, any one of those can be used to unlock the volume.  Since you
probably want the volume to unlock automatically when it is attached to the
host system, you will now add the keyfile to the LUKS volume.

`$ sudo cryptsetup luksAddKey /dev/disk/by-id/usb-HGST_HDN_1234ABC789_123456-0\:0-part1 /root/usb-keyfile`

You will be prompted for the volume's passphrase.

## Use luksOpen

Before using `luksOpen` you should decide on a naming scheme for your USB backup drives.
The `sync2usb` script assumes that you are going to put the same content on one or more
USB drives that share a naming scheme.  Example naming schemes are:

- USBBKP1A, USBBKP1B, USBBKP1C, USBBKP1D
- BKP2015A, BKP2015B, BKP2015C
- OFFSITE1, OFFSITE2, OFFSITE3, OFFSITE4

In this example, I am using the naming scheme of "USBBKP1#" where "#" is "A..Z".

`$ sudo cryptsetup luksOpen --key-file /root/usb-keyfile /dev/disk/by-id/usb-HGST_HDN_1234ABC789_123456-0\:0-part1 USBBKP1A`

The last part of that `luksOpen` statement is the device name that will be created
under the `/dev/mapper` directory and is needed in the next section.

## Format the LUKS volume

You can use whatever file system you want on your encrypted LUKS volume.  I like
to stick with ext4 because it is widely supported and reasonably robust.

`mkfs.ext4 -L TGH15B -J size=1024 -b 4096 -i 8192 /dev/mapper/USBBKP1A`

# Auto-mounting using Autfs/UDEV



## luksOpen/luksClose scripts

## Modify udev.d rules

(and trigger the UDEV system)

## Modify autofs configuration file

## mkfs

# UDEV(cap?) rules

# Updating AutoFS(?)

# Using the drive

