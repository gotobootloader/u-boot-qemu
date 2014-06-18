The Gotobootloader Open Source Project
================================================================================

Download U-Boot
--------------------------------------------------------------------------------

released version:

```
   $ git clone git://git.denx.de/u-boot.git
```

Cross compile U-Boot
--------------------------------------------------------------------------------

Go into the U-Boot root directory, then do:
```
   $ make ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- versatilepb_config
   $ make ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- -s
```

It will generate 'u-boot' and 'u-boot.bin' in the directory.
And we will get the tool "mkimage" under the directory "tools", we will use it to make Linux Kernel uImage, so
```
   $ sudo ln -sf $PWD/tools/mkimage /usr/local/bin/mkimage
```

You can start the u-boot in qemu now:
```
   $ qemu-system-arm -M versatilepb -nographic -kernel u-boot
```

It will start u-boot in your console, now you can type u-boot command, like "printenv", after the "VersatilePB # " prompt. type "CTRL-a x" to quit.

Debug U-Boot
--------------------------------------------------------------------------------

Add -s and -S options while involking QEMU
    -s shorthand for -gdb tcp::1234
    -S freeze CPU at startup (use 'c' to start execution)

```
   $ qemu-system-arm -M versatilepb -nographic -kernel u-boot -s -S
```

To debug u-boot, load the file "u-boot" into gdb (not "u-boot.bin") that is produced by "make" when building u-boot, This file is in ELF format and contain all the symbol information and are not stripped of debugging data until you run "strip" on them, unlike "u-boot.bin". Start ARM gdb in another console window and load "u-boot":

```
   $ arm-none-linux-gnueabi-gdb u-boot
   (gdb) target remote :1234
   (gdb) b do_printenv
   Breakpoint 1 at 0x10080f4: file cmd_nvedit.c, line 147.
   (gdb) c
   Continuing.
```

in the QEMU console window, it will show something like this:

```
   U-Boot 2010.06 (Aug 31 2010 - 16:23:16)
   DRAM:  0 Bytes
   Flash: 64 MiB
   *** Warning - bad CRC, using default environment
   In:    serial
   Out:   serial
   Err:   serial
   Net:   SMC91111-0
   VersatilePB #
```

type u-boot command "printenv" in the QEMU console window, it will be broken by the ARM gdb:

```
   VersatilePB # printenv
```

in the ARM gdb console window, it will show:

```
   Breakpoint 1, do_printenv (cmdtp=0x1015520, flag=0, argc=1, argv=0xfddee4)
       at cmd_nvedit.c:147
   147             if (argc == 1) {
   (gdb)
```

from here we should be able to use all the usual GDB commands, that's good!