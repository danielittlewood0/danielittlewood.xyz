# Important Files
The configuration of portage happens primarily in `/etc/portage`.
There are a number of files in here which are important.

## Make.conf
This is where the most high-level configuration for portage goes.
In particular a number of helpful environment variables are set.
The ones I have are:

```
VIDEO_CARDS="nouveau"
INPUT_DEVICES="libinput keyboard mouse"
USE="X -kde -qt5 alsa pulseaudio elogind -consolekit -systemd"
PYTHON_TARGETS="python3_7"
GRUB_PLATFORMS="efi-64"
```

These help configure the installation of packages, turning on or off features
or versions of a program.

## Package.use
This is a file, or a group of files, which set USE flags for specific packages.
You can switch them on or off, for example:

```
# attempt to remove python2
*/* PYTHON_TARGETS: -* python2_7

# required by www-client/chromium-83.0.4103.61::gentoo
>=net-libs/nodejs-14.2.0 inspector

sys-fs/ntfs3g suid
>=sys-boot/grub-2.04-r1 mount
```

## Package.mask
You can switch off certain packages, perhaps because of a conflict.
I try not to do this very often, so mine is empty.

## Patches
Package-specific patches are stored here.

```
patches/
└── www-client
    └── surf-2.0 -> /home/daniel/apps/surf-2.0/
```





