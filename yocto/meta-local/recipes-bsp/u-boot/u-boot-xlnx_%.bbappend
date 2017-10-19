FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-environment-workaround.patch"

#UBOOT_MAKE_TARGET_append = " EXT_DTB=${DEPLOY_DIR_IMAGE}/${MACHINE}-system.dtb"

do_deploy_append() {
	install -Dm 0644 ${WORKDIR}/build/spl/u-boot-spl.bin ${DEPLOYDIR}/u-boot-spl.bin
}
