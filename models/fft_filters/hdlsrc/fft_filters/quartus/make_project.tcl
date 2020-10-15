
set project fft_filters
set revision fft_filters_audiomini
set target_system audiomini
load_package flow

if [project_exists $project] {
    project_open $project
    create_revision $revision
} else {
    project_new $project -revision ${revision} -overwrite
}

source ${target_system}_proj.tcl

#Add files here

set_global_assignment -name VHDL_FILE Audiomini.vhd
set_global_assignment -name QIP_FILE audiomini_system/synthesis/audiomini_system.qip

# Add post-compile hook
set_global_assignment -name POST_FLOW_SCRIPT_FILE quartus_sh:gen_rbf.tcl


project_close
