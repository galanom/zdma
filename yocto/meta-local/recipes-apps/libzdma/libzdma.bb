SUMMARY = "Simple libzdma application"
##SECTION = "apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
FILESEXTRAPATHS_append = "${PROJ_DIR}/src: ${THISDIR}files:"

SRC_URI = "file://libzdma.c \
	   file://macro.h \
	   file://glue.h \
	   file://param.h \
	   file://Makefile \
		  "

S = "${WORKDIR}"

do_compile() {
	oe_runmake
}

do_install() {
	install -d ${D}${bindir}
	install -m 0755 libzdma ${D}${bindir}
}
