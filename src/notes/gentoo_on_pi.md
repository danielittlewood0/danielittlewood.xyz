## Gentoo on Raspberry Pi

I have a Raspberry Pi 3A, and I would like to run Gentoo on it.
One complication is that while the 3A has a 64 bit CPU, the kernel maintained
by the Pi Foundation is only 32 bit. I don't know how much of an issue that is,
but I tried installing the 64 bit version and failed, so I'm hoping that since
the 32 bit version is more popular/supported, the journey will be easier.
The reason this is worth documenting at all, is that the Pi CPUs are in general
ARM processors, while most effort for running Gentoo is invested in 32 and 64
bit Intel processors (`x86_32` and `amd64`, respectively).

My hopes for the installation are:

* No need to rely on Raspbian maintainers for packages.
* Learn about cross-compiling and the other aspects of working on an ARM cpu.
* Learn about using gentoo in more resource-constrained environments.

I'll be following the following guides:

* [32 bit installation guide]
* [64 bit installation guide]

## Power Issues

To cut a long and painful story short, **ensure you have sufficient power to
run the Pi**. Like many Pi users, I was previously running it through a
smartphone charger. In general, the Pi requires more power than that in order
to run, and boot time is a particularly power-intensive time. 

## 32 bit installation

### Partitions

The SD card requires 3 partitions: boot, root and swap. Boot should be around
100MB, swap should generally be around double the RAM (so 2GB in my case), and
root should inhabit the rest.

To set these up in `fdisk`, first clear the card, then:
```
n p 1 <next> +128M   # primary boot partition starting at default of size 128MB
t 1 b                # set boot partition type to W95 FAT32
n p 2 <next> +2G     # primary swap partition starting at default of size 2GB
t 2 82               # set boot partition type to Linux swap / Solaris
n p 3 <next> <next>  # primary root partition filling the remainder of the card

gentoo $ fdisk -l /dev/mmcblk0
Disk /dev/mmcblk0: 14.86 GiB, 15931539456 bytes, 31116288 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xff7864ee

Device         Boot   Start      End  Sectors  Size Id Type
/dev/mmcblk0p1         2048   264191   262144  128M  b W95 FAT32
/dev/mmcblk0p2       264192  4458495  4194304    2G 82 Linux swap / Solaris
/dev/mmcblk0p3      4458496 31116287 26657792 12.7G 83 Linux
```

Then you set up the filesystems as in the guide:

```
mkfs.vfat -F 16 /dev/mmcblk0p1
mkfs.fat 4.1 (2017-01-24)

mkswap /dev/mmcblk0p2
Setting up swapspace version 1, size = 2 GiB (2147479552 bytes)
no label, UUID=5d01b560-1bbe-4b7e-a594-1fef8d113f80

mkfs.ext4 /dev/mmcblk0p3
mke2fs 1.45.5 (07-Jan-2020)
Discarding device blocks: done
Creating filesystem with 3332224 4k blocks and 833952 inodes
Filesystem UUID: f7707769-b799-4e65-9962-cb991b7eefd4
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done
```

### Installation

Mount root, and then boot inside of it (I already have a `/mnt/gentoo` directory):

```
mount /dev/mmcblk0p3 /mnt/gentoo
mkdir /mnt/gentoo/boot
mount /dev/mmcblk0p1 /mnt/gentoo/boot
```

Get the stage 3. For me (RPi3A) I went
to the autobuilds at
[http://gentoo.osuosl.org/releases/arm/autobuilds/],
then picked out `current-stage3-arm7a`
(again, deduced from the guide). Picking
the latest, we do:

```
cd /tmp
wget http://gentoo.osuosl.org/releases/arm/autobuilds/current-stage3-armv7a/stage3-armv7a_hardfp-20161129.tar.bz2
tar xfpj stage3-armv7a_hardfp-*.tar.bz2 -C /mnt/gentoo/
```

Installing portage and the kernel went
fine, nothing interesting to note. See
[the guide][32 bit installation guide]
for details.

[32 bit installation guide]: https://wiki.gentoo.org/wiki/Raspberry_Pi/Quick_Install_Guide
[64 bit installation guide]: https://wiki.gentoo.org/wiki/Raspberry_Pi4_64_Bit_Install
