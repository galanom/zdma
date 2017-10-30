SUMMARY = "Client application to ZDMA system shared library"
##SECTION = "apps"
LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0;md5=c79ff39f19dfec6d293b95dea7b07891"

FILESEXTRAPATHS_append = "${PROJ_DIR}/src: ${THISDIR}files:"

SRC_URI = "file://zapp.cpp \
	   file://macro.h \
	   file://Makefile \
		  "

DEPENDS = "opencv libzdma"
RDEPENDS_${PN} = "libzdma"

S = "${WORKDIR}"

do_compile() {
	oe_runmake
}

do_install() {
	install -d ${D}/${bindir}
	install -m 0755 zapp ${D}/${bindir}
}

