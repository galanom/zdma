#!/bin/sh
petalinux-package --prebuilt --force --fpga ./download.bit
petalinux-boot --jtag --prebuilt 3
clear
picocom -b115200 /dev/ttyACM0
