# !!! FOR QUICK DEBUGGING ONLY !!!

obj-m := zdma.o
ccflags-y := -mno-thumb-interwork -marm -march=armv7-a -fuse-ld=bfd -std=gnu99 -Wall -fdiagnostics-color=always -fmax-errors=4 -Werror -Wno-declaration-after-statement -Wno-misleading-indentation -Wno-unused-function -Wno-pointer-sign -ftrack-macro-expansion=0
KERNEL_SRC="/tmp/petalinux/work-shared/plnx_arm/kernel-source"
TOOLCHAIN="/opt/Xilinx/PetaLinux/2017.2/tools/linux-i386/gcc-arm-linux-gnueabi/bin/arm-linux-gnueabihf"
CC="${TOOLCHAIN}-gcc"
LD="${TOOLCHAIN}-ld.bfd"
AR="${TOOLCHAIN}-ar"

SRC := $(shell pwd)

all:
	$(MAKE) -C $(KERNEL_SRC) M=$(SRC)

clean:
	rm -f *.o *~ core .depend .*.cmd *.ko *.mod.c
	rm -f Module.markers Module.symvers modules.order
	rm -rf .tmp_versions Modules.symvers
