#!/usr/bin/env sh

proj_dir="../base/"
proj_name="base"
top="zed_asym_cc_alt"

instance_name="zcore16"
solution="solution_16"

cores_dir="../cores"
INSTANCE_LIST=`printf "${instance_name}_%d " {0..15}`
CORE_LIST="loopback gauss sobel emboss outline sharpen negative contrast threshold"

rm -rf ./prj/* ./synth ./bit ./hd_visual ./impl ./dcp/*.dcp *.log \
	*.html *.xml vivado* fsm_encoding.os

design_dir="${proj_dir}/${proj_name}.srcs/sources_1/bd/${top}"
for instance in $INSTANCE_LIST
do
	module_name=`grep -E ${top}.*${instance}$ ${design_dir}/hdl/${top}.v | gawk '{print $1}'`
	module_file="${design_dir}/ip/${module_name}/synth/${module_name}.v"

	for core in $CORE_LIST
	do
		core_files="${cores_dir}/${core}/${solution}/impl/ip/hdl/verilog/*"
		for file in ${core_files} ${module_file}
		do
			[ ! -f ${file} ] && echo "File ${file} was not found, please fix the script!" && exit
			echo "verilog xil_defaultLib ${file}" >> ./prj/${instance}_${core}.prj
		done
	done
done

