#!/bin/sh
petalinux-build -c malaperda
petalinux-build -x package
petalinux-package --prebuilt --fpga ./download.bit --clean
petalinux-boot --jtag --prebuilt 3
