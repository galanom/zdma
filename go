#!/bin/sh
x="\e[1;92m"
y="\e[39m"
RHOST=147.27.39.174
VERSION=2017.1
PETADIR="/home/igalanommatis/petalinux"
HW="zedboard"
#FW="--pmufw components/plnx_workspace/pmu-firmware/Release/pmu-firmware.elf"
DESIGN="quad_dma"

# Create vivado project backup for git
for f in boards/*board/hardware/*.srcs/sources_1/bd/*/hw_handoff/*.tcl ; do
	sed -e "s/myproj/hardware/g; s/project_1/`echo $f | cut -f2 -d/`/g" $f > boards/`echo $f | cut -f2 -d/`/${f##*/}
done

cd boards/$HW
case $1 in
"clean")
	rm -rf build components pre-built ../../*.{log,jou}
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
	$PETADIR/tools/hsm/bin/xsdb project-spec/arm_reset.tcl
	$PETADIR/tools/hsm/bin/xsdb project-spec/arm_reset.tcl
	$PETADIR/tools/hsm/bin/xsdb project-spec/arm_reset.tcl
	petalinux-boot --jtag --prebuilt 3 $FW --hw_server-url ${RHOST}:3121
	;;
"con"*)
	[ ! -e zynq ] && socat pty,link=zynq,b115200,raw,waitslave tcp:${RHOST}:2000&
	screen zynq 115200
	;;
"dt")
	vim project-spec/meta-user/recipes-dt/device-tree/files/system-top.dts
	;;
"dtpl")
	vim components/plnx_workspace/device-tree-generation/pl.dtsi
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
