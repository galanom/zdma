FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-chunk-selection-algo-during-alloc.patch"
SRC_URI += "file://kernel.cfg"
PR = "r18"

