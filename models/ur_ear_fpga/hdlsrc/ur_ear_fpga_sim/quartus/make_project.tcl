
set project ur_ear_fpga_sim
set revision ur_ear_fpga_sim_audioblade
set target_system audioblade
load_package flow

if [project_exists $project] {
    project_open $project
    create_revision $revision
} else {
    project_new $project -revision ${revision} -overwrite
}

source ${target_system}_proj.tcl

#Add files here

set_global_assignment -name VHDL_FILE audioblade.vhd
set_global_assignment -name SDC_FILE audioblade.sdc
set_global_assignment -name QIP_FILE audioblade_system/audioblade_system.qip
set_global_assignment -name QSYS_FILE pll.qsys

# Add post-compile hook
set_global_assignment -name POST_FLOW_SCRIPT_FILE quartus_sh:gen_rbf.tcl


project_close
