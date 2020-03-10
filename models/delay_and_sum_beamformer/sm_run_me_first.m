% Run_me_first
%
% This scripts sets up the computer environment parameters
% (directories, paths, tools, etc) that the model needs.  It places these
% parameters in the data structure SG, which is the model name initials.
% This setup is needed for the Matlab HDL Coder to generate VHDL code.

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
mp.fastsim_flag = 1;     % perform fast simulation  Note: fast simulation will be turned off when generating VHDL code since we need to run at the system clock rate.
mp.fastsim_Fs_system_N = 64;     % (typical value 2 or 4) Simulate a much slower system clock than what is specified in sm_callback_init.m   - The reduce rate will be a multiple of the sample rate, i.e. mp.Fs_system = mp.Fs*mp.fastsim_Fs_system_N
mp.fastsim_Nsamples = 12000; % set to the string 'all' to use all the samples from the input signal specified in sm_init_test_signals.m


%% Model parameters
% Model parameters are placed in a data structure called mp that can be passed to functions
mp.model_name = 'delay_and_sum_beamformer';
mp.model_abbreviation = 'DSBF';

% Device driver version for the Linux device tree. Typically set as the Quartus version
mp.linux_device_name = mp.model_name;
mp.linux_device_version = '18.0';

mp.speedOfSound = 343;

% TODO: it'd sure be nice to have access to mp.Fs right here, but we don't....
mp.samplingRate = 48e3;
mp.arraySpacing = 25e-3;
mp.arraySize = [1,4];
arraySize = mp.arraySize;
arraySpacing = mp.arraySpacing;
samplingRate = mp.samplingRate;
speedOfSound = mp.speedOfSound;

% TODO: document this equation... this is across the entire array, 
% but delays are relative to the array center, so delays are +/- maxDelay/2
mp.maxDelay = sqrt(((mp.arraySize(1) - 1)*mp.arraySpacing).^2 + ((mp.arraySize(2) - 1)*mp.arraySpacing).^2)*mp.samplingRate/mp.speedOfSound;
% buffer size to accomodate max delay; buffer size is a power of 2

mp.integerDelayAddrSize = ceil(log2(floor(mp.maxDelay)));
mp.integerDelayBufferSize = 2^mp.integerDelayAddrSize;
mp.upsampleFactor = 32;
upsampleFactor = mp.upsampleFactor;
% number of required bits is one more than that required to represent upsampleFactor
% because we need to be able to represent +/- upsample factor
mp.fractionalDelayAddrSize = ceil(log2(floor(mp.upsampleFactor))) + 1;
mp.fractionalDelayBufferSize = 2^mp.fractionalDelayAddrSize;

% NOTE: these variables can't be in a matlab structure because the Matlab Coder
% doesn't support that...
delayDataTypeSign = 1;
delayDataTypeWordLength = mp.integerDelayAddrSize + mp.fractionalDelayAddrSize;
delayDataTypeFractionLength = mp.fractionalDelayAddrSize;
mp.delayDataTypeSign = 1;
mp.delayDataTypeWordLength = mp.integerDelayAddrSize + mp.fractionalDelayAddrSize;
mp.delayDataTypeFractionLength = mp.fractionalDelayAddrSize;




%% Setup the directory paths & tool settings
% TODO: these paths should ideally be contained in a toolbox. the one exception is the model path, which is many cases is the pwd, though it doesn't have to be.
addpath('../../config');
if isunix  % setup for a Linux platform
    path_setup_linux;
elseif ispc % setup for a Windows platform
    path_setup_windows;  
end

% TODO: remove python path and version information. All of the code should be python3 and python2 compatible. If not, we should make it python2/3 compatible if possible.
% mp.python_path = 'F:\Python\Python37\python.exe';

% Note: addpath() only sets the paths for the current Matlab session
addpath(mp.model_path)
addpath(mp.driver_codegen_path)
addpath(mp.vhdl_codegen_path)
addpath(mp.config_path)
hdlsetuptoolpath('ToolName', 'Altera Quartus II', 'ToolPath', mp.quartus_path);  % setup the HDL toochain path that needs to be set before calling HDL workflow process
eval(['cd ' mp.model_path])  % change the working directory to the model directory

%% python
% [python_version, python_exe, python_loaded] = pyversion;
% if  python_loaded
%     disp(['Using Python version ' python_version])
% else
%     pyversion(mp.python_path);    % Note: if the version changes from what is already loaded in Matlab, you will need to restart Matlab
%     [python_version, python_exe, python_loaded] = pyversion;
%     disp(['Setting Python to version ' python_version])
% end
% add the codegen_path to python's search path
if count(py.sys.path,mp.vhdl_codegen_path) == 0
    insert(py.sys.path,int32(0),mp.vhdl_codegen_path);
end
if count(py.sys.path,mp.driver_codegen_path) == 0
    insert(py.sys.path,int32(0),mp.driver_codegen_path);
end


%% Open the model
disp(['Please wait while the Simulink Model: '  mp.model_name  ' is being opened.'])
disp(['Note: Before generating VHDL, you will need to run a model simulation.'])
open_system([mp.model_abbreviation])
% display popup reminder message
helpdlg(sprintf(['NOTE: You will need to first run the Simulation for model ' mp.model_name ' to initialize variables in the Matlab workspace before converting to VHDL.']),'Reminder Message')
mp.sim_prompts = 1;  % turn on the simulation prompts/comments (these will be turned off when the HDL conversion process starts).
