#!/bin/sh
x="\e[1;92m"
y="\e[39m"
DESIGN="base"

PROJ="/home/igalanommatis/work/zdma"

cd $PROJ

# Create vivado project backup for git
for f in hw/*/*.srcs/sources_1/bd/*/hw_handoff/*.tcl ; do
	cp $f hw/
	#sed -e "s/myproj/hardware/g; s/project_1/`echo $f | cut -f2 -d/`/g" $f > hw/`echo $f | cut -f2 -d/`/${f##*/}
done

case $1 in
"init")
	sudo /opt/Xilinx/Vivado/2017.3/bin/hw_server &
	;;
"clean")
	rm -f $PROJ/{vivado*,octave-workspace,hs*}
	;;
"git")
	./go clean
	git reset
	git add .
	git add -f yocto/build/conf
	git add -f yocto/meta-local
	git reset yocto/meta-local/recipes-bsp/zdma-firmware/files/*.xz
	git status
	;;
"conf")
	vim yocto/build/conf/local.conf
	;;
"reload")
	scripts/hwgen
	;;
"dt")
	vim yocto/meta-local/recipes-kernel/linux/files/zedboard-zynq7/zdma-pl.dtsi
	vim yocto/meta-local/recipes-kernel/linux/files/zedboard-zynq7/zdma-user.dtsi
	;;
"edt")
	dtc -I dtb -O dts image/uImage-zynq-zed.dtb -o image/uImage-zynq-zed.dts
	vim image/uImage-zynq-zed.dts
	dtc -I dts -O dtb image/uImage-zynq-zed.dts -o image/uImage-zynq-zed.dtb
	;;
"hw")
	scripts/dtsgen
	;;
"ez")
	vim src/zdma/zdma.c
	;;
"build")
	cd yocto
	source ./oe-init-build-env > /dev/null
	bitbake core-image-minimal || exit 1
	echo "Root image is $((`stat -Lc %s $PROJ/image/core-image-minimal-zedboard-zynq7.cpio` / 1048576)) MiB"
	;;
"boot")
	ls -l image/download.bit
	scripts/boot || exit 1
	picocom -b115200 /dev/ttyACM0
	;;
"bb")
	./go build && ./go boot
	;;
"gdb")
	arm-linux-gnueabihf-gdb build/libzdma -iex "target remote 192.168.2.2:1234"
	;;
"kgdb")
	arm-linux-gnueabihf-gdb /tmp/yocto/work/zedboard_zynq7-poky-linux-gnueabi/linux-xlnx/4.9-xilinx-v2017.1+gitAUTOINC*/linux-zedboard_zynq7-standard-build/vmlinux
	;;
"mgdb")
	arm-linux-gnueabihf-gdb /tmp/yocto/work/zedboard_zynq7-poky-linux-gnueabi/zdma/1.0-r0/zdma.ko
	;;
*)
	echo -e ""\
		"$x reload$y: refresh hardware project files (HDF and BIT)\n"	\
		"$x build$y:  build everything\n"				\
		"$x boot$y:   boot target at remote host\n"
	;;
esac

cd $PROJ

