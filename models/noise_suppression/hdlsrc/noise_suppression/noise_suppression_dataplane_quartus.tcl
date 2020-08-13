load_package flow
set top_level noise_suppression_dataplane
set src_dir "[pwd]"
set prj_dir "q2dir"
file mkdir ../$prj_dir
cd ../$prj_dir
project_new $top_level -revision $top_level -overwrite
set_global_assignment -name FAMILY "Stratix IV"
set_global_assignment -name DEVICE EP4SGX230KF40C2
set_global_assignment -name TOP_LEVEL_ENTITY $top_level
set_global_assignment -name VHDL_FILE "$src_dir/noise_suppression_dataplane_pkg.vhd"
set_global_assignment -name VHDL_FILE "$src_dir/noise_suppression_SimpleDualPortRAM_generic.vhd"
set_global_assignment -name VHDL_FILE "$src_dir/noise_suppression_compute_statistics.vhd"
set_global_assignment -name VHDL_FILE "$src_dir/noise_suppression_streaming_partition_streamed.vhd"
set_global_assignment -name VHDL_FILE "$src_dir/noise_suppression_streaming_partition_streamed_block.vhd"
set_global_assignment -name VHDL_FILE "$src_dir/noise_suppression_Reciprocal2.vhd"
set_global_assignment -name VHDL_FILE "$src_dir/noise_suppression_Reciprocal_nw.vhd"
set_global_assignment -name VHDL_FILE "$src_dir/noise_suppression_Reciprocal1.vhd"
set_global_assignment -name VHDL_FILE "$src_dir/noise_suppression_Reciprocal_nw_block.vhd"
set_global_assignment -name VHDL_FILE "$src_dir/noise_suppression_Adaptive_Wiener_Filter_Sample_Based_Filtering.vhd"
set_global_assignment -name VHDL_FILE "$src_dir/noise_suppression_dataplane_tc.vhd"
set_global_assignment -name VHDL_FILE "$src_dir/noise_suppression_dataplane.vhd"
execute_flow -compile
project_close
