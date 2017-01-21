

# returns all the elements from the src uri that are .cfg files
def find_cfgs(d):
    sources=src_patches(d, True)
    sources_list=[]
    for s in sources:
        if s.endswith('.cfg'):
            sources_list.append(s)

    return sources_list








SRC_URI_append ="\
    file://plnx_kernel.cfg\
"
KERNEL_IMAGETYPE_zynq ?= "zImage"
FILESEXTRAPATHS_append := ":${THISDIR}/configs"
RDEPENDS_kernel-base = ""

do_deploy_append () {
	install -m 0644 ${D}/boot/System.map-${KERNEL_VERSION} ${DEPLOY_DIR_IMAGE}/System.map.linux
	install -m 0644 ${D}/boot/vmlinux-${KERNEL_VERSION} ${DEPLOY_DIR_IMAGE}/vmlinux
}
