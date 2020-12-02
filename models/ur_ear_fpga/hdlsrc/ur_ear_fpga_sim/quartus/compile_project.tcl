
load_package flow

project_open -force -revision ur_ear_fpga_sim_audioblade ur_ear_fpga_sim

# compile the project
execute_flow -compile

project_close
