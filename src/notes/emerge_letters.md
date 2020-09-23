# What are those weird letters when you emerge a package?

I recently updated. I was faced with:

```
Calculating dependencies... done!
[ebuild  N     ] app-arch/zip-3.0-r3  USE="bzip2 crypt unicode -natspec"
[ebuild   R    ] app-admin/syslog-ng-3.22.1  PYTHON_SINGLE_TARGET="python3_7* -python3_6*"
[ebuild     U  ] dev-python/pygobject-3.34.0 [3.32.1] PYTHON_TARGETS="python3_7* -python2_7* -python3_6* (-python3_9)"
[ebuild   R    ] x11-base/xorg-server-1.20.7  USE="elogind*"
[ebuild   R    ] x11-misc/redshift-1.12-r3  USE="-appindicator%" PYTHON_TARGETS="python3_7* -python3_6*"
[ebuild  rR    ] net-print/cups-filters-1.27.4
[ebuild     U  ] sys-auth/polkit-0.116-r1 [0.115-r4] USE="elogind* -consolekit*"
[ebuild   R    ] net-misc/modemmanager-1.10.0  USE="elogind*"
[ebuild   R    ] dev-java/java-config-2.2.0-r4  PYTHON_TARGETS="python3_7* -python3_6* (-python3_8)"
[ebuild   R    ] media-sound/pulseaudio-13.0  USE="elogind*"
[ebuild   R    ] media-libs/libsdl-1.2.15-r9  USE="pulseaudio*"
[ebuild   R    ] media-libs/libcanberra-0.30-r5  USE="pulseaudio*"
[ebuild     U  ] media-video/ffmpeg-4.2.3 [4.2.2] USE="pulseaudio*"
[ebuild   R    ] media-sound/mpg123-1.25.10-r1  USE="pulseaudio*" ABI_X86="-32*"
[ebuild     U  ] dev-java/icedtea-bin-3.16.0 [3.15.0] USE="pulseaudio*"
[ebuild  N     ] virtual/jdk-1.8.0-r4
[ebuild  N     ] dev-java/icedtea-sound-1.0.1  USE="doc -test"
[ebuild  N     ] virtual/jre-1.8.0-r2
[ebuild   R    ] www-client/chromium-83.0.4103.61  USE="pulseaudio*"

Would you like to merge these packages? [Yes/No]
```

The letters `N R U r` were confusing to me, so I found them in the `emerge`
manpage. In the "OUTPUT" section they say the following:

U = update
R = Re-emerge (probably changed USE?)
rR = Rebuilt to satisfy a slot-operator dependency (?)
N = New to your system, will be emerged for the first time
