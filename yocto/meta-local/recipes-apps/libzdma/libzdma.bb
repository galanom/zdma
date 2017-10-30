SUMMARY = "ZDMA System Library"
##SECTION = "apps"
LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-3.0;md5=c79ff39f19dfec6d293b95dea7b07891"

FILESEXTRAPATHS_append = "${PROJ_DIR}/src: ${THISDIR}files:"

SRC_URI = "file://libzdma.c \
	   file://libzdma.h \
	   file://macro.h \
	   file://glue.h \
	   file://param.h \
	   file://Makefile \
	  "

S = "${WORKDIR}"

PACKAGES = "${PN} ${PN}-dev ${PN}-dbg ${PN}-staticdev"
FILES_${PN} = "${libdir}/libzdma.so.1"
FILES_${PN}-dev = "${libdir}/libzdma.so ${includedir}/*.h"
#RPROVIDES_${PN} = "libzdma"

do_compile() {
	oe_runmake
}

do_install() {
	install -d ${D}/${libdir}
	install -m 0755 libzdma.so.1 ${D}/${libdir}
	install -d ${D}/${includedir}
	install -m 0644 libzdma.h ${D}/${includedir}
	# this is a mistake
	install -m 0644 glue.h ${D}/${includedir}
	install -m 0644 param.h ${D}/${includedir}
	ln -rsf ${D}/${libdir}/libzdma.so.1 ${D}/${libdir}/libzdma.so
}
