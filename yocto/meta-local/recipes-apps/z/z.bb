SUMMARY = "Client application to ZDMA system shared library"
##SECTION = "apps"
LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0;md5=c79ff39f19dfec6d293b95dea7b07891"

FILESEXTRAPATHS_append = "${PROJ_DIR}/src: ${THISDIR}/files:"
FILESEXTRAPATHS_append = "${PROJ_DIR}/hw/cores:"


SRC_URI = "file://z.cpp \
	   file://macro.h \
	   file://sample.jpg \
	   file://Makefile"
	   
FILES_${PN} += "/home/root/sample.jpg"

DEPENDS = "opencv libzdma"
RDEPENDS_${PN} = "libzdma"

S = "${WORKDIR}"

do_compile() {
	oe_runmake
}

do_install() {
	install -d ${D}/${bindir}
	install -m 0755 z ${D}/${bindir}
	install -d ${D}/home/root
	install -m 0755 sample.jpg ${D}/home/root
}

