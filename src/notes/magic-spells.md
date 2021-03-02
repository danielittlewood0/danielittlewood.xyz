---
title: Magic Spells
date: 2 March 2021
---

## Portage @world update

To upgrade a gentoo system.

```
emerge -aqvuDU --keep-going=y @world
```

* `-a`: *Ask* before running.
* `-q`: *Quiet* (don't show build output).
* `-v`: *Verbose* (show USE flag changes).
* `-u`: *Upgrade* all packages to the most recent version.
* `-D`: Look *deep* in the dependency tree to find updated libraries.
* `-U`: Include packages with *changed USE flags*.
* `--keep-going=y`: If a package fails to install, continue trying to install the rest.

## Kernel upgrade

Upgrading the Linux kernel [guide](https://wiki.gentoo.org/wiki/Kernel/Upgrade).
After selecting the new sources, run:

```
genkernel all -j4
```

## Rsync backup

To backup a filesystem with rsync.

```
rsync -aAXvP SRC DEST
```

* `-a`: Copy in *archive* mode, preserving modification times, permissions, etc.
* `-A`: Preserve *ACLs* (i.e. file permissions).
* `-X`: Copy all *extended attributes*.
* `-v`: *Verbose* (show all file changes).
* `-P`: *Progress* (show copying progress).

## ffmpeg quick compression/conversion

Raw recorded video is too big, and most compression snippets you find convert
to patented formats with proprietary standards. I prefer:

```
ffmpeg -i input.mkv -codec:v libtheora -qscale:v 7 -codec:a libvorbis -qscale:a 5 output.ogv
```

* `-codec:v libtheora`: Use the free video codec [Theora](https://xiph.org/theora/).
* `-qscale:v 7`: Set the video quality scale (0-10).
* `-codec:a libvorbis`: Use the free audio codec [Vorbis](https://xiph.org/vorbis/).
* `-qscale:a 5`: Set the audio quality scale (0-10).

[Source](https://trac.ffmpeg.org/wiki/TheoraVorbisEncodingGuide)
