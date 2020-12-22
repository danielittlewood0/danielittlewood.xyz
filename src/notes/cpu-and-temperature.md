---
title: CPU Frequency Scaling and Temperature
date: 13 September 2020
---
## The problem

I'm getting annoyed/confused because my laptop gets hotter on Gentoo than it
used to on Ubuntu, even when relatively idle. For example, all morning my CPU
consumption has been below 10%, but:

```
$ sensors | grep temp1
temp1:        +53.5°C
temp1:        +48.0°C
temp1:        +52.0°C
temp1:        +52.0°C  (crit = +128.0°C)
```

This by no means is an issue in terms of damaging the laptop, but it's warm to
the touch and that's unusual for me if the CPU is not maxed out.

## My understanding

As far as I can tell, all the hard work that my laptop does (in terms of
consuming power) is done by the CPU. The power consumption of the CPU is
related to its voltage, and its voltage goes up when the CPU frequency goes up.
If I run

```
watch -n1 "lscpu | grep 'MHz' | awk '{print $1}'"
```

then I get a cute little in-terminal view of my CPU frequency. I would expect
it to be scaled down when idle, but it is not.

## Frequency Scaling

There are two relevant automatic measures for scaling down the CPU frequency
when idle. There is a thing called a "CPU governor", which is basically an
algorithm in the kernel which utilises information provided by the CPU in order
to decide how much strain it's under, and therefore how to tweak the clock
speed. For example, the "performance" governor has the simple algorithm of
ignoring the current strain of the system in order to maximise the speed of all
computation. Contrastingly, "powersave" will sacrifice some speed in order to
reduce power consumption. For some intel CPUs, and mine is included in this
list, there is a driver called "intel_pstate". This uses some non-portable
information provided by the CPU to control the frequency. The Arch wiki
[states][arch-wiki-cpu-gov]:

> The pstate power scaling driver is used automatically for modern Intel CPUs
> instead of the other drivers below. This driver takes priority over other
> drivers and is built-in as opposed to being a module. This driver is currently
> automatically used for Sandy Bridge and newer CPUs. If you encounter a problem
> while using this driver, add intel_pstate=disable to your kernel line. You can
> use the same user space utilities with this driver, but cannot control it.

There are useful articles in the Linux Kernel docs about [CPU Frequency scaling
in general][cpu-frequency] and [Intel P States in particular][intel-p-state].

## Active mode for Intel P States

The above quote from Arch wiki agrees with the following
[quote][intel-p-state-active-mode] from the Linux Kernel docs:

> (Active mode) is the default operation mode of intel_pstate.

> In this mode the driver bypasses the scaling governors layer of CPUFreq and
> provides its own scaling algorithms for P-state selection.

> There are two P-state selection algorithms provided by intel_pstate in the
> active mode: powersave and performance.

> Which of the P-state selection algorithms is used by default depends on the
> CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE kernel configuration option. Namely,
> if that option is set, the performance algorithm will be used by default, and
> the other one will be used by default if it is not set.

This suggests that setting the default governor to *anything other than*
performance should reduce my CPU frequency when idle. I know that it is set to
performance because I did it on purpose, I think recommended by the wiki. But
who knows!

Making that kernel change, installing and rebooting...

Seems to have worked!

```
Every 1.0s: lscpu | grep 'MHz' | awk '{print }'                                                                                                                gentoo: Sat Sep 12 20:01:28 2020

CPU MHz:                         815.938
CPU max MHz:                     2700.0000
CPU min MHz:                     500.0000

$ sensors | grep temp1
temp1:        +48.0°C
temp1:        +41.0°C
temp1:        +46.0°C
temp1:        +46.0°C  (crit = +128.0°C)
```

[intel-p-state-active-mode]: https://www.kernel.org/doc/html/v4.12/admin-guide/pm/intel_pstate.html#active-mode
[cpu-frequency]: https://www.kernel.org/doc/html/v4.12/admin-guide/pm/cpufreq.html
[intel-p-state]: https://www.kernel.org/doc/html/v4.12/admin-guide/pm/intel_pstate.html
[arch-wiki-cpu-gov]: https://wiki.archlinux.org/index.php/CPU_frequency_scaling#CPU_frequency_driver
