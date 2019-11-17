% Run_me_first
%
% This scripts sets up the computer environment parameters
% (directories, paths, tools, etc) that the model needs.  It places these
% parameters in the data structure SG, which is the model name initials.
% This setup is needed for the Matlab HDL Coder to generate VHDL code.
%
% Copyright 2019 Flat Earth Inc
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Ross K. Snider
% Flat Earth Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com

%% Clear the workspace
clear all   % clear all workspace variables
close all   % close all open Matlab windows
clc         % clear command window

%% Fast simulation
% Fast simulation reduces the Fs_system clock rate to reduce the number of
% simulated clock cycles between each sample in the Avalon bus signals.
% It also reduces the number of stimulus samples.  This allow for faster
% development iterations when developing the simulink model.
mp.fastsim_flag        = 0;     % perform fast simulation  Note: fast simulation will be turned off when generating VHDL code since we need to run at the system clock rate.
mp.fastsim_Fs_system_N = 4;     % (typical value 2 or 4) Simulate a much slower system clock than what is specified in sm_callback_init.m   - The reduce rate will be a multiple of the sample rate, i.e. mp.Fs_system = mp.Fs*mp.fastsim_Fs_system_N
mp.fastsim_Nsamples    = 12000; % set to the string 'all' to use all the samples from the input signal specified in sm_init_test_signals.m


%% Setup the directory paths & tool settings
% Model variables will be placed in a data structure called mp 
% (<model_abbreviation>_params)that can be passed to functions
mp.model_name           = 'DynamicCompressionWithRx';                                       % model name initials
mp.model_abbreviation   = 'sm_DynamicCompression';                             % model initials
mp.linux_device_version = '18.0';                                              % string that describes device version (typically set as Quartus version)

localSanityLocCheck = pwd;
% if ( ~strcmp(localSanityLocCheck, 'C:\Users\Balad\Documents\FlatEarth\simulink_models\models\Dynamic_Compression_Model') )
%     disp('Run from the DCM folder. Moving there for you.');
%     cd 'C:\Users\Balad\Documents\FlatEarth\simulink_models\models\Dynamic_Compression_Model';
% end
cd ..;  % temporarily move up a folder
mp.model_path           =  [pwd, '\Dynamic_Compression_Model'];                 % path to the model directory

cd ..;  % move out of the models folder
mp.test_signals_path    =  [pwd, '\test_signals'];                              % path to test signals folder
%mp.utility_path         =  ; %'E:\git\nih_simulinklib\matlab';                  % path to test signals folder
mp.config_path          =  [pwd, '\config'];                                    % path to configuration folder (widget and register field definitions)
mp.codegen_path         =  [pwd, '\utilities\vhdl_codegen'];                              % path to \vhdl_codegen folder
mp.quartus_path         =  'C:\intelFPGA_lite\18.1\quartus\bin64\quartus.exe';  % path to the Quartus executable
mp.python_path          =  'C:\Python\python.exe';                              % path to Python executable.
mp.linux_device_name    = mp.model_name;                                        % device driver name that Linux will see

cd models/Dynamic_Compression_Model;   % return to where this was run
%% Set up the paths
% Note: addpath() only sets the paths for the current Matlab session
addpath(mp.model_path)
%addpath(mp.utility_path)
addpath(mp.codegen_path)
addpath(mp.config_path)
hdlsetuptoolpath('ToolName', 'Altera Quartus II', 'ToolPath', mp.quartus_path);  % setup the HDL toochain path that needs to be set before calling HDL workflow process
eval(['cd ' mp.model_path])  % change the working directory to the model directory

%% python
[python_version, python_exe, python_loaded] = pyversion;
if  python_loaded
    disp(['Using Python version ' python_version])
else
    pyversion(mp.python_path);    % Note: if the version changes from what is already loaded in Matlab, you will need to restart Matlab
end
% add the codegen_path to python's search path
if count(py.sys.path,mp.codegen_path) == 0
    insert(py.sys.path,int32(0),mp.codegen_path);    
end

%% Open the model
open_system([mp.model_abbreviation])
% display popup reminder message 
helpdlg(sprintf(['NOTE: You will need to first run the Simulation for model ' mp.model_name ' to initialize variables in the Matlab workspace before converting to VHDL.']),'Reminder Message')
mp.sim_prompts = 1;  % turn on the simulation prompts/comments (these will be turned off when the HDL conversion process starts).

