#!/bin/sh
x="\e[1;92m"
y="\e[39m"
RHOST=147.27.39.174
VERSION=2017.1
HW="zedboard"
DESIGN="quad_dma"
cd $HW
case $1 in
"clean")
	rm -rf build components pre-built
	;;
"reload")
	[ -e hardware/${DESIGN}_wrapper.hdf ] && mv -f hardware/${DESIGN}_wrapper.hdf hardware/system.hdf
	[ -e hardware/system.hdf ] && unzip -p hardware/system.hdf > hardware/download.bit || exit 1
	;;
"reconf")
	petalinux-config --get-hw-description hardware
	;;
"ez")
	vim ../src/zdma/zdma.c
	;;
"cbuild")
	petalinux-build -c zdma || exit
	petalinux-build -c libzdma || exit
	petalinux-build -x package
	petalinux-package --prebuilt --clean --fpga ./hardware/download.bit
	;;
"build")
	petalinux-build || exit
	petalinux-package --prebuilt --clean --fpga ./hardware/download.bit
	;;
"boot"|"program")
	#[ ! -e zynq ] && socat pty,link=zynq,b115200,raw,waitslave tcp:147.27.39.174:2000&
	/opt/Xilinx/PetaLinux/$VERSION/tools/hsm/bin/xsdb project-spec/arm_reset.tcl
	petalinux-boot --jtag --prebuilt 3 --hw_server-url 147.27.39.174:3121
	;;
"con"*)
	[ ! -e zynq ] && socat pty,link=zynq,b115200,raw,waitslave tcp:147.27.39.174:2000&
	screen zynq 115200
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
cd ..
