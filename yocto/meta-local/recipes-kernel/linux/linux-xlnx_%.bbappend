FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://0001-chunk-selection-algo-during-alloc.patch \
            file://0001-devicetree-for-zdma.patch \
	    file://0001-DMA-channel-safe-reset.patch \
	    file://0002-DMA-channel-safe-reset.patch \
	    file://0003-DMA-channel-safe-reset.patch \
	    file://0004-DMA-channel-safe-reset.patch \
	    file://0005-DMA-channel-safe-reset.patch \
	    file://0006-DMA-channel-safe-reset.patch \
	    file://0007-DMA-channel-safe-reset.patch \
	    file://0008-DMA-channel-safe-reset.patch \
            file://kernel.cfg \
            file://zdma-pl.dtsi;subdir=git/arch/${ARCH}/boot/dts \
            file://zdma-user.dtsi;subdir=git/arch/${ARCH}/boot/dts \
            "
PR = "r30"

PACKAGE_ARCH = "zedboard-zynq7"

#	    file://0001-xdevcfg-interface-from-kernel-space.patch 
#	    file://0002-xdevcfg-interface-from-kernel-space.patch 
#	    file://0003-xdevcfg-interface-from-kernel-space.patch 
#	    file://0004-xdevcfg-interface-from-kernel-space.patch 

KERNEL_MODULE_AUTOLOAD = "xilinx_dma"
