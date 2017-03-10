












































































XSCTH_WS = "${TOPDIR}/../components/plnx_workspace"
sysconf = "${TOPDIR}/../project-spec/configs"
padding_size = "0x1000"
YAML_BSP_CONFIG[main_memory] = "set,ps7_ddr_0"
YAML_BSP_CONFIG[pcw_dts] = "set,pcw.dtsi"
do_compile[deptask] += "virtual/kernel:do_shared_workdir"
SRC_URI_append ="\
    file://config\
"
YAML_BSP_CONFIG[console_device] = "set,ps7_uart_1"
export PETALINUX
dtc_include = "${XSCTH_WS}/${XSCTH_PROJ}"
FILESEXTRAPATHS_append := ":${sysconf}"
inherit xsctyaml
YAML_FILE_PATH = "${WORKDIR}/devicetree.yaml"
XSCTH_MISC = "-yamlconf ${YAML_FILE_PATH}"
dts_dir = "${XSCTH_WS}/${XSCTH_PROJ}"
dtc_kernel_include = "${STAGING_KERNEL_DIR}/include"
YAML_BSP_CONFIG = "console_device main_memory pcw_dts"

do_configure_append () {
	script="${PETALINUX}/etc/hsm/scripts/petalinux_hsm_bridge.tcl"
	data=${PETALINUX}/etc/hsm/data/
	eval xsct ${script} -c ${WORKDIR}/config \
	-hdf ${dts_dir}/hardware_description.hdf -repo ${S}\
	-data ${data} -sw ${dts_dir} -o ${dts_dir} -a "soc_mapping"
}

do_compile () {
	install ${WORKDIR}/system-top.dts ${dts_dir}/system-top.dts
	dtc_args="-i "${dts_dir}" "
	cpp_args="-I "${dts_dir}" "
	if [ ! -z ${dtc_include} ];then
	dtc_args="${dtc_args} -i ${dtc_include}"
	cpp_args="${cpp_args} -I ${dtc_include}"
	fi
	if [ ! -z ${dtc_kernel_include} ];then
	dtc_args="${dtc_args} -i ${dtc_kernel_include}"
	cpp_args="${cpp_args} -I ${dtc_kernel_include}"
	fi
	${CPP} -E -nostdinc -Ulinux ${cpp_args} \
	-x assembler-with-cpp -o ${dts_dir}/${MACHINE}-system.dts \
	${dts_dir}/system-top.dts
	dtc -O dtb -o ${dts_dir}/${MACHINE}-system.dtb -b 0 -p ${padding_size} \
	-I dts ${dtc_args} ${dts_dir}/${MACHINE}-system.dts
	dtc -O dts -o ${dts_dir}/${MACHINE}-system.dts  \
	-I dtb  ${dts_dir}/${MACHINE}-system.dtb
}
