FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://0001-chunk-selection-algo-during-alloc.patch \
            file://0001-devicetree-for-zdma.patch \
	    file://0001-dma-reset-and-enable-intr-on-both-channels.patch \
	    file://0001-allow-fpga-programming-from-kernel-space.patch \
            file://kernel.cfg \
            file://zdma-pl.dtsi;subdir=git/arch/${ARCH}/boot/dts \
            file://zdma-user.dtsi;subdir=git/arch/${ARCH}/boot/dts \
            "
PR = "r31"

PACKAGE_ARCH = "zedboard-zynq7"

KERNEL_MODULE_AUTOLOAD = "xilinx_dma"
