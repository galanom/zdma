#!/bin/sh
x="\e[1;92m"
y="\e[39m"
DESIGN="quad_dma"

PROJ="/home/igalanommatis/work/zdma"

cd $PROJ

# Create vivado project backup for git
for f in hw/*/*.srcs/sources_1/bd/*/hw_handoff/*.tcl ; do
	cp $f hw/
	#sed -e "s/myproj/hardware/g; s/project_1/`echo $f | cut -f2 -d/`/g" $f > hw/`echo $f | cut -f2 -d/`/${f##*/}
done

case $1 in
"clean")
	;;
"git")
	./go clean
	git add -f yocto/build/conf
	git add -f yocto/meta-local
	git status
	;;
"conf")
	vim yocto/build/conf/local.conf
	;;
"reload")
	scripts/hwgen
	;;
"dt")
	vim yocto/meta-local/recipes-kernel/linux/files/zedboard-zynq7/zdma-user.dtsi
	;;
"edt")
	dtc -I dtb -O dts image/uImage-zynq-zed.dtb -o image/uImage-zynq-zed.dts
	vim image/uImage-zynq-zed.dts
	dtc -I dts -O dtb image/uImage-zynq-zed.dts -o image/uImage-zynq-zed.dtb
	;;
"ez")
	vim src/zdma/zdma.c
	;;
"build")
	cd yocto
	source ./oe-init-build-env > /dev/null
	bitbake core-image-minimal
	;;
"boot")
	cmp -bs hw/quad_dma/quad_dma.runs/impl_1/quad_dma_wrapper.bit image/download.bit || \
		echo "WARNING! Bitstream in image directory and vivado implementation differ!"
	scripts/boot
	;;
"bb")
	./go build && ./go boot
	;;
"gdb")
	arm-linux-gnueabihf-gdb build/libzdma -iex "target remote 192.168.2.2:1234"
	;;
"kgdb")
	arm-linux-gnueabihf-gdb /tmp/yocto/work/zedboard_zynq7-poky-linux-gnueabi/linux-xlnx/4.9-xilinx-v2017.1+gitAUTOINC+68e6869cfb-r26/linux-zedboard_zynq7-standard-build
	;;
"mgdb")
	# needs fixing
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

cd $PROJ

