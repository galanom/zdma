SUMMARY = "Recipe for  build an external zdma Linux kernel module"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=12f884d2ae1ff87c09e5b7ccc2c4ca7e"

inherit module

SRC_URI = "file://Makefile \
           file://zdma.c \
           file://zoled.h \
           file://param.h \
           file://macro.h \
           file://glue.h \
	   file://COPYING \
          "

S = "${WORKDIR}"

