SRC_URI_append = " file://platform-top.h"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://user_2017-01-07-20-46-00.cfg;subdir=git \
            file://user_2017-01-21-17-07-00.cfg;subdir=git \
            file://user_2017-03-05-16-46-00.cfg;subdir=git \
            file://user_2017-03-05-16-52-00.cfg;subdir=git \
            "

