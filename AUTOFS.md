# Autofs

https://wiki.archlinux.org/index.php/Autofs

# Global Configuration

# /etc/auto.master

The `auto.master` file is the key file which is used to define what gets mounted where.  The
first column tells autofs where to mount, the second option tells it the filename of the
configuration file for that mount location, and the third column lets you pass parameters
to the autofs mount action.

Example:
```
/mnt/usb4bay            /etc/auto.usb4bay       --timeout=600
/media                  /etc/auto.media         --timeout=1800
/mnt/usbbackup          /etc/auto.usbbackup     --timeout=300
/mnt/usbmediabkp        /etc/auto.usbmediabkp   --timeout=300
```

# /etc/auto.something

For each entry in `/etc/auto.master` you will have one configuration file (named whatever you want).

Example: auto.media
```
MyNTFSDrive -fstype=ntfs-3g,rw,noatime,uid=thomas,gid=thomas,nofail :/dev/disk/by-uuid/9ADEADBEEF75DE67
```
