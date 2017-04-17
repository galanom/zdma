#!/bin/sh
x="\e[1;92m"
y="\e[39m"
RHOST=147.27.39.174

case $1 in
"prep")
	PL=/opt/Xilinx/PetaLinux/2016.4/tools
	[ -e $PL ] || PL=/home/igalanommatis/opt/petalinux/tools
	[ -e $PL ] || { echo "Cannot find PetaLinux!"; exit -1; }
	export PATH="$PATH:$PL/linux-i386/petalinux/bin:$PL/common/petalinux/bin:$PL/linux-i386/microblaze-xilinx-elf/bin:$PL/linux-i386/microblazeel-xilinx-linux-gnu/bin:$PL/linux-i386/gcc-arm-none-eabi/bin:$PL/linux-i386/gcc-arm-linux-gnueabi/bin:$PL/linux-i386/aarch64-none-elf/bin:$PL/linux-i386/aarch64-linux-gnu/bin"
	export PETALINUX=/home/igalanommatis/opt/petalinux PETALINUX_VER=2016.4 SETTINGS_FILE=settings.sh XIL_SCRIPT_LOC=/home/igalanommatis/opt/petalinux
	#alias cdk="cd /var/tmp/yocto/work-shared/plnx_arm/kernel-source"
	alias go="./go"
	echo $PATH
	;;
"reload")
	cp ../dma/dma.sdk/axidma_wrapper.hdf build/system.hdf
	cp ../dma/dma.runs/impl_1/axidma_wrapper.bit build/download.bit
	;;
"reconf")
	petalinux-config --get-hw-description build/
	[ `grep EXTRA_IMAGE_FEATURES ./build/conf/local.conf` ] || echo 'EXTRA_IMAGE_FEATURES="debug-tweaks"' >> ./build/conf/local.conf
	sed '/inherit extrausers/d;/EXTRA_USERS_PARAMS/d' -i ./project-spec/meta-plnx-generated/recipes-core/images/petalinux-user-image.bb
	;;
"cbuild")
	petalinux-build -c zdma || exit
	petalinux-build -c libzdma
	petalinux-build -c bench
	petalinux-build -x package
	petalinux-package --prebuilt --clean --fpga ./build/download.bit
	;;
"build")
	petalinux-build
	petalinux-package --prebuilt --clean --fpga ./build/download.bit
	;;
"remote")
	ssh -t $RHOST "cd work/zeus; source /opt/Xilinx/Vivado/2016.4/settings64.sh; source /opt/Xilinx/PetaLinux/2016.4/settings.sh ; ./go run && ./go con"
	;;
"run")
	xsdb project-spec/arm_reset.tcl
	petalinux-boot --jtag --prebuilt 3
	;;
"rcon")
	ssh -t $RHOST "picocom -b115200 /dev/ttyACM0"
	;;
"con"*)
	picocom -b115200 /dev/ttyACM0
	;;
"clean")
	rm *.log *.jou
	;;
"dt")
	vim project-spec/meta-user/recipes-dt/device-tree/files/system-top.dts
	;;
"dtpl")
	vim components/plnx_workspace/device-tree-generation/pl.dtsi
	;;
*)
	echo -e ""\
		"$x prep$y:   prepare shell environment\n"			\
		"$x reload$y: refresh hardware project files (HDF and BIT)\n"	\
		"$x reconf$y: reread HDF and run project configuration\n"	\
		"$x cbuild$y: build user components\n"				\
		"$x build$y:  build everything\n"				\
		"$x remote$y: boot and connect to target at remote host\n"	\
		"$x run$y:    boot the project to the connected board\n"	\
		"$x rcon$y:   launch serial terminal to target board at remote host\n" \
		"$x con$y:    launch serial terminal to target board.\n"	\
		"$x dt*$y:    edit device-tree nodes\n"
	;;
esac

