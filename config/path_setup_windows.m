local_git_path         = 'E:\GitHub';
mp.model_path          = [local_git_path '\simulink_models\models\' mp.model_name];
mp.test_signals_path   = [local_git_path '\simulink_models\test_signals'];
mp.config_path         = [local_git_path '\simulink_models\config'];
mp.vhdl_codegen_path   = [local_git_path '\simulink_codegen\vhdl'];
mp.driver_codegen_path = [local_git_path '\simulink_codegen\device_drivers'];
mp.quartus_path        = 'F:\intelFPGA_lite\18.0\quartus\bin64';

disp(['------------------------------------------------'])
disp(['Setting up the the following path parameters'])
disp(['Local GitHub repository path = ' local_git_path])
disp(['Simulink model path          = ' mp.model_path])
disp(['Test signals path            = ' mp.test_signals_path])
disp(['Config path                  = ' mp.config_path])
disp(['VHDL Codegen path            = ' mp.vhdl_codegen_path])
disp(['Driver Codegen path          = ' mp.driver_codegen_path])
disp(['Quartus path                 = ' mp.quartus_path])
disp(['------------------------------------------------'])
