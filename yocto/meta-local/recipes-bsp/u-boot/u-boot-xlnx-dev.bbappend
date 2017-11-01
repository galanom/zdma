FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://0001-environment-workaround.patch"

#FILESEXTRAPATHS_prepend := "${THISDIR}/configs:"
#SRC_URI += "file://config.cfg file://platform-auto.h"

#do_configure_append () {
#	install ${WORKDIR}/platform-auto.h ${S}/include/configs/
#	install ${WORKDIR}/platform-top.h ${S}/include/configs/
#}

do_deploy_append() {
	install -Dm 0644 ${WORKDIR}/build/spl/u-boot-spl.bin ${DEPLOYDIR}/u-boot-spl.bin
}
