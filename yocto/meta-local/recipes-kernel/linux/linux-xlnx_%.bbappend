FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://0001-chunk-selection-algo-during-alloc.patch \
            file://0001-devicetree-for-zdma.patch \
            file://kernel.cfg \
            file://zdma-pl.dtsi;subdir=git/arch/${ARCH}/boot/dts \
            file://zdma-user.dtsi;subdir=git/arch/${ARCH}/boot/dts \
            "
PR = "r27"

PACKAGE_ARCH = "zedboard-zynq7"

