
































UBOOT_MAKE_TARGET_append = " EXT_DTB=${DEPLOY_DIR_IMAGE}/${MACHINE}-system.dtb"
SRC_URI_append ="\
    file://config.cfg\
    file://platform-auto.h\
"
DEPENDS_append = " kern-tools-native device-tree-generation"
FILESEXTRAPATHS_append := ":${THISDIR}/configs:"

do_configure_append () {
	install ${WORKDIR}/platform-auto.h ${S}/include/configs/
	install ${WORKDIR}/platform-top.h ${S}/include/configs/
}
