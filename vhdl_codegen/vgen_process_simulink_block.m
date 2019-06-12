avalon = vgen_get_simulink_block_interfaces();
% Note: The model simulation needs to be run first before this function
% is called since there are workspace variables that need to be set
% in the initiallization callback function

%% Get system clock frequency
% the init function has to be called for the Fs_system and Ts_system variables to show up
DataPlane_callback_init
avalon.clock = struct('frequency', Fs_system, 'period', Ts_system);

%% Save the avalon structure to a json file
writejson(avalon, [avalon.entity,'.json'])
