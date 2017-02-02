#!/bin/sh
petalinux-build -c malaperda || exit
petalinux-build -x package
petalinux-package --prebuilt --fpga ./download.bit --clean
petalinux-boot --jtag --prebuilt 3

