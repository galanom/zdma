SUMMARY = "Partial Bitstreams for ZDMA system"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_append = "${THISDIR}/files:"
SRC_URI = "file://*.xz"
FILES_${PN} += "${base_libdir}/firmware/zdma/*.xz"

S = "${WORKDIR}"
PR = "r5"

do_install() {
	     install -d ${D}/${base_libdir}/firmware/zdma
	     install -m 0755 ${S}/*.xz ${D}/${base_libdir}/firmware/zdma/
}

