#!/bin/sh
x="\e[1;92m"
y="\e[39m"

case $1 in
"prep")
	source "/opt/Xilinx/Vivado/2016.4/settings64.sh"
	source "/opt/Xilinx/PetaLinux/2016.4/settings64.sh"
	export PATH=$PATH:/home/galanom/work/zdma
	alias cdk="cd /var/tmp/yocto/work-shared/plnx_arm/kernel-source"
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
	petalinux-build -c bench
	petalinux-build -x package
	;;
"build")
	petalinux-build
	;;
"run")
	xsdb ./arm_reset.tcl
	petalinux-package --prebuilt --clean --fpga ./build/download.bit
	petalinux-boot --jtag --prebuilt 3
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
		"$x cbuikd$y: build user components\n"				\
		"$x build$y:  build everything\n"				\
		"$x run$y:    boot the project to the connected board\n"	\
		"$x con$y:    launch serial terminal to target board.\n"	\
		"$x dt*$y:    edit device-tree nodes\n"
	;;
esac

