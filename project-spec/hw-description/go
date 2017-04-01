#!/bin/sh
xsdb ./arm_reset.tcl
petalinux-package --prebuilt --force --fpga ./download.bit
petalinux-boot --jtag --prebuilt 3
#picocom -b115200 /dev/ttyACM0
