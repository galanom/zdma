#!/bin/sh
x="\e[1;92m"
y="\e[39m"
DESIGN="quad_dma"

cd /home/igalanommatis/work/zdma

# Create vivado project backup for git
for f in hw/*/*.srcs/sources_1/bd/*/hw_handoff/*.tcl ; do
	echo $f
	cp $f hw/
	#sed -e "s/myproj/hardware/g; s/project_1/`echo $f | cut -f2 -d/`/g" $f > hw/`echo $f | cut -f2 -d/`/${f##*/}
done

case $1 in
"clean")
	;;
"reload")
	scripts/hwgen
	;;
"ez")
	vim src/zdma/zdma.c
	;;
"build")
	cd yocto/poky
	source oe*
	bitbake core-image-minimal
	;;
"boot")
	scripts/boot
	;;
"gdb")
	arm-linux-gnueabihf-gdb build/libzdma -iex "target remote 192.168.2.2:1234"
	;;
"kgdb")
	arm-linux-gnueabihf-gdb /tmp/petalinux/deploy/images/plnx_arm/vmlinux
	;;
"mgdb")
	cp ../../src/zdma.c /tmp/petalinux/work/plnx_arm-xilinx-linux-gnueabi/zdma/1.0-r0/zdma.c
	arm-linux-gnueabihf-gdb /tmp/petalinux/sysroots/plnx_arm/lib/modules/4.9.0-xilinx/extra/zdma.ko
	rm /tmp/petalinux/work/plnx_arm-xilinx-linux-gnueabi/zdma/1.0-r0/zdma.c
	;;
*)
	echo -e ""\
		"$x reload$y: refresh hardware project files (HDF and BIT)\n"	\
		"$x build$y:  build everything\n"				\
		"$x boot$y:   boot target at remote host\n"
	;;
esac
cd -

