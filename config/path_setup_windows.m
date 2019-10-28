%--------------------------------------------------------------------------
% Git Repository Setup
% Add your git path to the cell array selection below so it will be found
% the next time you run Simulink.
% The first directory that Matlab finds that exists will be used.
%--------------------------------------------------------------------------
local_git_path{1}         = 'C:\Users\bugsbunny\NIH';
local_git_path{2}         = 'V:\MSU\GitHub\';
valid_index = 0;
for index=1:length(local_git_path)
    if exist(local_git_path{index},'dir') 
        valid_index = index;
    end
end
if valid_index > 0
    git_path = local_git_path{valid_index};
else
    disp('Local Git Repository not found.  Please add your Git path to path_setup_windows.m');
end
%git_path

mp.model_path          = [git_path '\simulink_models\models\' mp.model_name];
mp.test_signals_path   = [git_path '\simulink_models\test_signals'];
mp.config_path         = [git_path '\simulink_models\config'];
mp.vhdl_codegen_path   = [git_path '\simulink_codegen\vhdl'];
mp.driver_codegen_path = [git_path '\simulink_codegen\device_drivers'];

%--------------------------------------------------------------------------
% Quartus Setup
% Add your Quartus path to the cell array selection below so it will be found
% the next time you run Simulink.
% The first directory that Matlab finds that exists will be used.
%--------------------------------------------------------------------------
local_quartus_path{1}         = 'C:\intelFPGA_lite\18.0\quartus\bin64';
local_quartus_path{2}         = 'D:\intelFPGA_lite\18.1\quartus\bin64';
valid_index = 0;
for index=1:length(local_quartus_path)
    if exist(local_quartus_path{index},'dir') 
        valid_index = index;
    end
end
if valid_index > 0
    quartus_path = local_quartus_path{valid_index};
else
    disp('Local Quartus Install not found.  Please add your Quartus path to path_setup_windows.m');
end
%quartus_path

mp.quartus_path        = quartus_path;

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