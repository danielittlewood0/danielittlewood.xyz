I was changing my kernel settings according to the "power management" section
of the gentoo wiki: https://wiki.gentoo.org/wiki/Power_management/Guide.

```
Power management and ACPI options --->
  -*- Device power management core functionality
  [*] ACPI (Advanced Configuration and Power Interface) Support --->
    <*> AC Adapter
    <*> Battery
    -*- Button
    -*- Video
    <*> Fan
    <*> Processor
    <*> Thermal Zone
 ``` 

 I had Video set to `-M-`. I know that this means it is a kernel module. Now I
 need to know how to change it.

 Modules are loaded by the user. I don't know when I load kernel modules, so
 it's probably best to fix that. 

 I am told that a dependency of Video was built as a module, so Video has too.
 What are its dependencies?

 Going to "Help":
 ```
   Depends on: ACPI [=y] && X86 [=y] && BACKLIGHT_CLASS_DEVICE [=m] && INPUT [=y]
 ```

 So the culprit is `BACKLIGHT_CLASS_DEVICE`.

 This turned out to be the flag for "Low-level backlight options" or something,
 so I built that in. Video is now built in.
