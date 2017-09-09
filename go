#!/bin/sh
x="\e[1;92m"
y="\e[39m"
RHOST=127.0.0.1
VERSION=2017.2
PETADIR="/opt/Xilinx/PetaLinux/2017.2"
HW="zedboard"
#FW="--pmufw components/plnx_workspace/pmu-firmware/Release/pmu-firmware.elf"
DESIGN="quad_dma"
TMP=/tmp/petalinux
CC=$TMP/sysroots/x86_64-linux/usr/bin/arm-xilinx-linux-gnueabi/arm-xilinx-linux-gnueabi-gcc

# Create vivado project backup for git
for f in boards/*board/hardware/*.srcs/sources_1/bd/*/hw_handoff/*.tcl ; do
	sed -e "s/myproj/hardware/g; s/project_1/`echo $f | cut -f2 -d/`/g" $f > boards/`echo $f | cut -f2 -d/`/${f##*/}
done

cd boards/$HW
case $1 in
"clean")
	rm -rf build components pre-built ../../*.{log,jou}
	make clean -C=../../src M=`pwd`
	;;
"reload")
	mkdir -p build
	cp -f hardware/${HW}.sdk/${DESIGN}_wrapper.hdf build/system.hdf || exit 1
	unzip -p build/system.hdf > build/download.bit || exit 1
	;;
"reconf")
	petalinux-config --get-hw-description=build
	petalinux-config -c device-tree
#	sed '/misc_clk_0: misc_clk_0 {/a\\t\t\tcompatible = "fixed-clock";\n\t\t\t#clock-cells = <0>;\n\t\t\tclock-frequency = <100000000>;' \
#		-i components/plnx_workspace/device-tree-generation/pl.dtsi
	petalinux-config -c rootfs
	;;
"ez")
	vim src/zdma/zdma.c
	;;
"cbuild")
	petalinux-build -c zdma || exit
	petalinux-build -x package
	;;
"build")
	petalinux-build || exit
	;;
"boot")
	#[ ! -e zynq ] && socat pty,link=zynq,b115200,raw,waitslave tcp:147.27.39.174:2000&
	petalinux-package --prebuilt --clean --fpga build/download.bit
	$PETADIR/tools/hsm/bin/xsdb project-spec/arm_reset.tcl --hw-server-url ${RHOST}:3121
	$PETADIR/tools/hsm/bin/xsdb project-spec/arm_reset.tcl --hw-server-url ${RHOST}:3121
	$PETADIR/tools/hsm/bin/xsdb project-spec/arm_reset.tcl --hw-server-url ${RHOST}:3121
	petalinux-boot --jtag --prebuilt 3 $FW --hw_server-url ${RHOST}:3121
	;;
"bb")
	cd ../../
	./go cbuild && ./go boot
	cd -
	;;
"con"*)
	[ ! -e zynq ] && socat pty,link=zynq,b115200,raw,waitslave tcp:${RHOST}:2000&
	screen zynq 115200
	;;
"dt")
	vim project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi
	;;
"dtpl")
	vim components/plnx_workspace/device-tree-generation/pl.dtsi
	;;
"test")
	$CC  -march=armv7-a -marm -mfpu=neon  -mfloat-abi=hard -mcpu=cortex-a9 --sysroot=$TMP/sysroots/plnx_arm -std=gnu11 -ggdb -Wall -fdiagnostics-color=always -fmax-errors=4 -Werror -Wno-declaration-after-statement -Wno-misleading-indentation -Wno-unused-function -ftrack-macro-expansion=0   -c -o build/tst.o ../../src/libzdma.c
	$CC  -march=armv7-a -marm -mfpu=neon  -mfloat-abi=hard -mcpu=cortex-a9 --sysroot=$TMP/sysroots/plnx_arm -Wl,-O1 -Wl,--hash-style=gnu -Wl,--as-needed -o build/tst build/tst.o
	make ARCH=arm -C ../../src M=`pwd` O=/tmp/petalinux/work-shared/plnx_arm/kernel-build-artifacts
	;;
"gdb")
	arm-linux-gnueabihf-gdb build/tst -iex "target remote 192.168.2.2:1234"
	;;
"kgdb")
	#/tmp/petalinux/deploy/images/plnx_arm/vmlinux
	cp ../../src/zdma.c /tmp/petalinux/work/plnx_arm-xilinx-linux-gnueabi/zdma/1.0-r0/zdma.c
	arm-linux-gnueabihf-gdb /tmp/petalinux/sysroots/plnx_arm/lib/modules/4.9.0-xilinx/extra/zdma.ko
	rm /tmp/petalinux/work/plnx_arm-xilinx-linux-gnueabi/zdma/1.0-r0/zdma.c
	;;
*)
	echo -e ""\
		"$x reload$y: refresh hardware project files (HDF and BIT)\n"	\
		"$x reconf$y: reread HDF and run project configuration\n"	\
		"$x cbuild$y: build user components\n"				\
		"$x build$y:  build everything\n"				\
		"$x boot$y:   boot target at remote host\n"			\
		"$x con$y:    launch serial terminal to target board at remote host\n" \
	;;
esac
cd ../..

