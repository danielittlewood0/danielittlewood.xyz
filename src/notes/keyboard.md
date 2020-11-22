---
title: Keyboard Settings under X
date: 5 November 2020
---

The keyboard in Linux has separate settings when running under X and when not.
Under X, there are a number of utilities (xmodmap, xvkbd, xbindkeys, and so on)
which can be used to get additional functionality. Community-driven window
managers also often give functionality to remap keys, but these are less
portable and should be avoided for any bindings not specific to the window
manager itself.

## Keyboard Layout (console)

Under openrc, the console keyboard layout is managed by the `keymaps` service.
The keyboard settings are in `/etc/conf.d/keymaps`, and (on my system) there is
a line `keymap="us"` which should be `keymap="uk"`.

In order to update the changes, we need to restart the `keymaps` service,

```
rc-update add keymaps boot
rc-service keymaps restart
```

## Keyboard Layout with xkb

To set the keyboard layout when X starts, add the following line to your `.xinitrc`.

```
setxkbmap -layout gb
```

[XKB](https://wiki.archlinux.org/index.php/X_keyboard_extension) can be used
for sophisticated remapping of the keyboard, but the rules it requires are more
complex than for xmodmap (described below).

## Remapping keys with xmodmap

If you want to augment your keyboard layout by remapping some keys, you should
use the tool xmodmap. From the manual,

>      The  xmodmap program is used to edit and display the keyboard modifier
>      map and keymap table that are used by client applications to convert
>      event  keycodes  into  keysyms.  It  is  usually  run from the user's
>      session startup script to configure the keyboard according to personal
>      tastes.

To see the syntax for xmodmap, and to set yourself up with a config file, run:

```
# Initalise a config file
xmodmap -pke > $HOME/.xmodmaprc
```

You can remove lines you don't want to change, but you should keep a backup of
the original configuration in case you make a mistake. The syntax of each line
is like the following:

```
keycode 65 = space space Return BackSpace
```

The left hand side refers to a "keycode". This is an integer which determines a
key on your keyboard. To see which keycode is sent when you press a particular
key, run the xev command. For example, if I open xev and press the space bar, I
see the output:

```
KeyPress event, serial 33, synthetic NO, window 0x3000001,
    root 0x17e, subw 0x0, time 193595320, (116,168), root:(1077,718),
    state 0x0, keycode 65 (keysym 0x20, space), same_screen YES,
    XLookupString gives 1 bytes: (20) " "
    XmbLookupString gives 1 bytes: (20) " "
    XFilterEvent returns: False
```

The output can be very hard to read, because it processes every input it
receives (including mouse movements). We see that the space bar has keycode 65,
and keysym "space". The line `keycode 65 = space` tells xmodmap to process the
space bar as a "space" key press. If we changed it to `keycode 65 = h`, then
pressing the space bar would be equivalent to pressing the h key.

The extra columns refer to when certain modifier keys are pressed. Column 1
refers to pressing `key` with no modifiers. Column 2 refers to `Shift+key`,
column 3 is `Mode_switch+key`, and column 4 is `Mode_switch+Shift+key`. Shift is
the normal shift key on your keyboard, and Mode_switch is a special key
designated for changing keyboard layout - normally the AltGr key on your
keyboard, if it has one.

So, for a normal letter on the keyboard, the line might look something like this:

```
keycode  31 = i I i I rightarrow idotless rightarrow
```

columns beyond the first four are non-standard (see the manual). This key
behaves like the usual I key on your keyboard - if Shift is pressed, it sends
`I`, and if not then it sends `i`. It ignores the Mode_switch key.  To see a
line that takes advantage of Mode_switch, recall the example from above:

```
keycode 65 = space space Return BackSpace
```

So key 65 (the space bar) reports a "space" keysym if Mode_switch is not
pressed, and otherwise reports Return, unless Shift is pressed, in which case
it reports BackSpace. In case your keyboard does not have an AltGr key, or you don't like its position, you can remap it like so:

```
keycode  66 = Mode_switch NoSymbol Mode_switch
```

This snippet sets my Caps Lock key to be Mode_switch, but I don't use that key
anyway so it's not big loss. My final xmodmaprc looks like so:

```
keycode  43 = h H Left Left
keycode  44 = j J Down Page_Down
keycode  45 = k K Up Page_Up
keycode  46 = l L Right Right
keycode  65 = space space Return BackSpace
keycode  66 = Mode_switch NoSymbol Mode_switch
```

To source this file on startup, add the following line to your xinitrc file.

```
xmodmap $HOME/.xmodmaprc
```

## Binding keys to scripts with xbindkeys

For jobs more complex than simply remapping keys, you should use `xbindkeys`.
With this tool, a specific key or key sequence can be mapped to an arbitrary
command or script. When `xbindkeys` is run, it reads the default configuration
file at `$HOME/xbindkeysrc`. You can generate a default file with helpful
comments by running `xbindkeys --defaults`.

The required syntax is:

```
"cmd"
  key
```

## Application: Multimedia Keys

My volume keys (Mute, Up, Down) do not work out of the box, so here is an
example to fix them.

To find the key, I first run `xbindkeys -k` or `xev`. Pressing each of Fn+F1-6,
I get:

```
XF86AudioMute
XF86AudioLowerVolume
XF86AudioRaiseVolume
XF86AudioMicMute
XF86MonBrightnessDown
XF86MonBrightnessUp
```

If you get something like "No response" or "Focusin/Focusout", then an
application is intercepting the key press. For example, when xbindkeys is
running, I get no response. Your window manager may be swallowing the keys
instead. Unfortunately, you have to find out what application is responsible by
yourself.

### Brightness

Once you have identified the appropriate key, you need a shell command which
will adjust the volume/brightness. For brightness, we can use the `xbrightness`
tool:

```
# $HOME/.xbindkeysrc
"xbacklight -inc 10"
  XF86MonBrightnessUp
"xbacklight -dec 10"
  XF86MonBrightnessDown
```

### Volume

For volume, I have PulseAudio installed on my system so I use the tool `pactl`
to adjust the volume. For the sinks (speakers), we have:

```
$ pactl list short sinks
0       alsa_output.pci-0000_00_03.0.hdmi-stereo        module-alsa-card.c      s16le 2ch 44100Hz       IDLE
1       alsa_output.pci-0000_00_1b.0.analog-stereo      module-alsa-card.c      s16le 2ch 44100Hz       IDLE

$ pactl list short sources
0       alsa_output.pci-0000_00_03.0.hdmi-stereo.monitor        module-alsa-card.c      s16le 2ch 44100Hz       RUNNING
1       alsa_output.pci-0000_00_1b.0.analog-stereo.monitor      module-alsa-card.c      s16le 2ch 44100Hz       RUNNING
2       alsa_input.pci-0000_00_1b.0.analog-stereo       module-alsa-card.c      s16le 2ch 44100Hz       RUNNING
```

You can probably identify the correct card by reading the short name - I am
interested in the analog input and output channels. The configuration will
therefore be:

```
# $HOME/.xbindkeysrc
"pactl set-sink-mute alsa_output.pci-0000_00_1b.0.analog-stereo toggle"
  XF86AudioMute
"pactl set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo -10%"
  XF86AudioLowerVolume
"pactl set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo +10%"
  XF86AudioRaiseVolume
"pactl set-source-mute alsa_input.pci-0000_00_1b.0.analog-stereo toggle"
  XF86AudioMicMute
```

### Screenshots

There is a very nice and simple program named [scrot][scrot] that takes
screenshots. I am accustomed to the PrintScreen button taking a screenshot of
the current window, and Shift+PrintScreen taking an "interactive" screenshot
(where you draw a rectangle on the screen).

The following setup will do exactly that, with screenshots being sent to your
home directory by default. To send them to a special folder, check out `man
scrot`.

```
# $HOME/.xbindkeysrc
"scrot"
  Print
"scrot -s"
  Shift+Print
```

[scrot]: https://github.com/resurrecting-open-source-projects/scrot
