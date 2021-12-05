---
title: danielittlewood
---

Welcome to my site - I like [Gentoo Linux][gentoo] and [Free
Software][fsf], so expect content about that.

## Notes
I often have problems configuring my system, and if the problem is not
easily solved then I tend to write notes to myself about how to fix it.
If I put them here, then (selfishly) I can access them easily in
multiple places, and (selflessly) other people in similar situations
might benefit from reading the things I tried.

I usually write the notes themselves in [Markdown] and then
post-process them into HTML using [pandoc].


<details>
<summary> [How does this site work?] </summary>
Setting up a website is more complicated than I expected, so I compiled
some pointers together in case someone else wants to copy what
I've done.
</details>

<details>
<summary> [Magic Spells] </summary>
A cheat-sheet for long commands with many options that I don't
like searching the internet or reading the manual to find over
and over.
</details>

<details>
<summary> [ Controlling CPU Frequency and Temperature in Gentoo ] </summary>
When I switched to Gentoo, my laptop was warmer than I expected
during normal use. It turned out that my CPU was running at max
frequency all the time, which was making it consume more power
(and hence warm up).
</details>

<details>
<summary> [ Keyboard Settings under X ] </summary>
Explanation of how to remap keys, assign scripts to certain key
combinations, and fix broken multimedia keys on a system running
X.
</details>


## Free Software

This covers anything to do with Free software which I either think
is worth publicising, that I use personally and patch, or that I have
written and maintain myself. 

I also plan to keep my *dotfiles* (configuration files for various packages)
indexed here.


<details>
<summary> [st - simple terminal][my-st] </summary>
st is a simple terminal emulator for X which [sucks less][st] It is
configured by patching the source code, which is written in C. To see
the changes I've made, plus an explanation of how they work, take a
look at [my fork][my-st] on Github.
</details>


[gentoo]: https://www.gentoo.org
[fsf]: https://www.fsf.org/
[markdown]: https://en.wikipedia.org/wiki/Markdown
[pandoc]: https://pandoc.org/
[st]: https://st.suckless.org/
[my-st]: https://github.com/danielittlewood0/st
[How does this site work?]: notes/website-documentation.html
[Magic Spells]: notes/magic-spells.html
[Controlling CPU Frequency and Temperature in Gentoo]: notes/cpu-and-temperature.html
[Keyboard Settings under X]: notes/keyboard.html
