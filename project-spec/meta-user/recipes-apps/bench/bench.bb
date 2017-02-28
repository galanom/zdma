#
# This file is the bench recipe.
#

SUMMARY = "Simple bench application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://bench.c \
	   file://Makefile \
	   file://bench.sh \
		  "

INITSCRIPT_NAME="bench"
INITSCRIPT_PARAMS="defaults"

S = "${WORKDIR}"

inherit update-rc.d

do_compile() {
	     oe_runmake
}

do_install() {
	     install -d ${D}${bindir}
	     install -m 0755 bench ${D}${bindir}
	     install -d ${D}${sysconfdir}/init.d/
	     install -m 0755 bench.sh ${D}${sysconfdir}/init.d/bench
}
