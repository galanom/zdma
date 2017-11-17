FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://0001-chunk-selection-algo-during-alloc.patch \
            file://0001-devicetree-for-zdma.patch \
	    file://0001-xdevcfg-interface-from-kernel-space.patch \
	    file://0002-xdevcfg-interface-from-kernel-space.patch \
	    file://0003-xdevcfg-interface-from-kernel-space.patch \
	    file://0004-xdevcfg-interface-from-kernel-space.patch \
            file://kernel.cfg \
            file://zdma-pl.dtsi;subdir=git/arch/${ARCH}/boot/dts \
            file://zdma-user.dtsi;subdir=git/arch/${ARCH}/boot/dts \
            "
PR = "r28"

PACKAGE_ARCH = "zedboard-zynq7"

