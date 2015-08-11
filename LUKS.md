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

The easiest way that I find for searching for USB attached disks is the `/dev/disk/by-id` path under Linux.
If you sort by modification time, the most recently plugged in drive will be at the top of the list.

For example, here is the 5TB Hitachi drive that I just plugged into my external USB enclosure:

```
$ sudo ls -lt /dev/disk/by-id/ | grep 'usb'
lrwxrwxrwx. 1 root root  9 Aug 11 05:17 usb-HGST_HDN_999999ZZZ999_000000000000-0:0 -> ../../sdp
```

I strongly suggest that you always use the `/dev/disk/by-id/` name to refer to your drives rather
then relying on `/dev/sdX` drive identifiers.  The values under `by-id` are consistent across 
reboots, disconnects, or other changes in which drives are active.  Drive identifiers like `sda`, 
on the other hand, can and will frequently change.

However, if you have partitions on the disk, an alternative is to use the `/dev/disk/by-uuid/` values
which are also consistent across reboots and system changes.

## Partition it with `parted`

`$ sudo parted /dev/disk/by-id/usb-HGST_HDN_999999ZZZ999_000000000000-0:0`

Assuming the drive is blank, then your first command will be `mklabel gpt`.  You can verify that the
drive is blank, by using the `print` command inside of `parted`.

The rest of commands that I use when setting up a disk are:

- `unit mb` - Switches the units from blocks to megabytes
- `mkpart primary 1 -1` - Creates a maximum size partition that is correctly aligned
- `set 1 hidden on` - Hide the partition
- `print` - Verify your changes
- `quit` - Exit parted

Please note that after partitioning the drive, we refer to the first partition by appending `-part1` to the
end of the `/dev/disk/by-id/` value.  This is important during the `badblocks` and `shred` phase so
that we do not overwrite the partition table that was just created.

## Verify the drive

There is nothing worse then pulling a backup drive out of the padded bag and finding that your
drive won't spin up, or that it has bad sectors, or other forms of bit-rot.  Therefore, I still
recommend a period of "burn-in" where you exercise the drive for a few days before putting it
into active service.  The goal of a "burn-in" is to trigger an early failure for a drive that
is of marginal quality, and to make sure that the drive can handle the load.

`$ sudo badblocks -wsv -p 5 -t random /dev/disk/by-id/usb-HGST_HDN_999999ZZZ999_000000000000-0:0-part1`

That uses the `badblocks` program to write random patterns to the disk over and over again until
at least five passes do not have any errors.  Depending on the size of your drive and whether you
are using USB 2.0 or USB 3.0, this test might take two to five days.  

If you see *any* errors at all during the `badblocks` testing, then you should investigate whether
it is your hard drive, or the USB cable or the USB ports or bad RAM.  Marginal hardware produces
marginal backups -- which can lead to lost data down the road.  Any device that cannot handle
a few days of heavy use during burn-in will likely not hold up over long-term use.

## Shred the drive

Shredding the drive writes a cryptographically strong random pattern to the drive, which will hide
how much of the drive has been used by LUKS for actual data storage.  Against the simple and low
technology attacker it is not important, but it is still strongly suggested.

`$ sudo shred -v /dev/disk/by-id/usb-HGST_HDN_999999ZZZ999_000000000000-0:0-part1`

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

