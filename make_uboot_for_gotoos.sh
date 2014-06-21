#!/bin/bash

make ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- versatilepb_config
make ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi-

sudo ln -sf $PWD/tools/mkimage /usr/local/bin/mkimage
