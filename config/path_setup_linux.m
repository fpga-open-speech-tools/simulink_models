mp.model_path = pwd;
mp.test_signals_path = [pwd filesep '..' filesep '..' filesep 'test_signals'];
mp.config_path = [pwd filesep '..' filesep '..' filesep 'config'];
mp.vhdl_codegen_path = [pwd filesep '..' filesep '..' ...
    filesep '..' filesep 'simulink_codegen' filesep 'vhdl'];
mp.driver_codegen_path = [pwd filesep '..' filesep '..' ...
    filesep '..' filesep 'simulink_codegen' filesep 'device_drivers'];
mp.quartus_path = '/usr/local/intelFPGA/18.0/quartus/bin';
