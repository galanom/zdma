#!/bin/sh
petalinux-package --prebuilt --force --fpga ./download.bit
petalinux-boot --jtag --prebuilt 3
