avalon = vgen_get_simulink_block_interfaces();
% Note: The model simulation needs to be run first before this function
% is called since there are workspace variables that need to be set
% in the initiallization callback function
DataPlane_callback_init
vhdl = vgen_generate_VHDL_component(avalon);
avalon.vhdl = vhdl;
disp(avalon.vhdl.component_declaration)
disp(avalon.vhdl.component_instantiation)
disp(avalon.vhdl.register_defaults)

vhdl



