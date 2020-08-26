I recently found out that my keyboard is wrong in Gentoo.

The keyboard settings are in `/etc/conf.d/keymaps` for openrc, which is me.
There is a line `keymap="us"` which should be `keymap="uk"`.

In order to update the changes, we need to restart the `keymaps` service,

```
rc-update add keymaps boot
rc-service keymaps restart
```

I misread! At first I thought this hadn't worked. On closer inspection, these
settings are only used for the console. But I'm running X, so I need to
configure it that way. This will either involve messing with my xsession file,
or by configuring dwm.

You need to use the command `setxkbmap`, and add the line: 

```
setxkbmap -layout gb
```

to your `.xsession`.
