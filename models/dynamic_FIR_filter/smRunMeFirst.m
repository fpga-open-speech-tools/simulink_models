% Run_me_first
%
% This scripts sets up the computer environment parameters
% (directories, paths, tools, etc) that the model needs.  It places these
% parameters in the data structure SG, which is the model name initials.
% This setup is needed for the Matlab HDL Coder to generate VHDL code.

% Copyright 2019 Flat Earth Inc
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Ross K. Snider
% Justin P. Williams
% Flat Earth Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com

%% Clear the workspace
clear all   % clear all workspace variables
close all   % close all open Matlab windows
clc         % clear command window
%% Add DSP blocks to the path
% addpath([pwd '/../../../simulink_library/']);
%add_library_to_path;
%% Fast simulation
% Fast simulation reduces the Fs_system clock rate to reduce the number of
% simulated clock cycles between each sample in the Avalon bus signals.
% It also reduces the number of stimulus samples.  This allow for faster
% development iterations when developing the simulink model.
mp.fastSimFlag        = 0;      % perform fast simulation  Note: fast simulation will be turned off when generating VHDL code since we need to run at the system clock rate.
mp.fastSimClockUprate = 8;      % (typical value 2 or 4) Simulate a much slower system clock than what is specified in sm_callback_init.m   - The reduce rate will be a multiple of the sample rate, i.e. mp.systemFs = mp.sampleFs*mp.fastSimClockUprate
mp.fastSimSamples     = 50;     % set to the string 'all' to use all the samples from the input signal specified in smInitTestSignals.m


%% Model parameters
% Model parameters are placed in a data structure called mp that can be passed to functions
mp.modelName = 'pFIRTesting';
mp.modelAbbreviation = 'pFIR_HPF';
mp.modelAbbreviation = 'pFIRTesting';

% Device driver version for the Linux device tree. Typically set as the Quartus version
mp.linuxDeviceName = mp.modelName;
mp.linuxDeviceVersion = '18.0';

%% Setup the directory paths & tool settings
% TODO: these paths should ideally be contained in a toolbox. the one exception is the model path, which is many cases is the pwd, though it doesn't have to be.
addpath('../../config');
if isunix  % setup for a Linux platform
    path_setup_linux;
elseif ispc % setup for a Windows platform
    path_setup_windows;  
end

% Note: addpath() only sets the paths for the current Matlab session
addpath(mp.modelPath)
addpath(mp.driverCodegenPath)
addpath(mp.vhdlCodegenPath)
addpath(mp.configPath)
hdlsetuptoolpath('ToolName', 'Altera Quartus II', 'ToolPath', mp.quartusPath);  % setup the HDL toochain path that needs to be set before calling HDL workflow process
cd(mp.modelPath);

%% python
[pythonVersion, pythonExe, pythonLoaded] = pyversion;
% if  pythonLoaded
%     disp(['Using Python version ' pythonVersion])
% else
%     pyversion(mp.python_path);    % Note: if the version changes from what is already loaded in Matlab, you will need to restart Matlab
%     [pythonVersion, pythonExe, pythonLoaded] = pyversion;
%     disp(['Setting Python to version ' pythonVersion])
% end
% add the codegen_path to python's search path
if count(py.sys.path,mp.vhdlCodegenPath) == 0
    insert(py.sys.path,int32(0),mp.vhdlCodegenPath);
end
if count(py.sys.path,mp.driverCodegenPath) == 0
    insert(py.sys.path,int32(0),mp.driverCodegenPath);
end


%% Open the model
disp(['Please wait while the Simulink Model: '  mp.modelName  ' is being opened.'])
disp(['Note: Before generating VHDL, you will need to run a model simulation.'])
open_system([mp.modelName])
% display popup reminder message
helpdlg(sprintf(['NOTE: You will need to first run the Simulation for model ' mp.modelName ' to initialize variables in the Matlab workspace before converting to VHDL.']),'Reminder Message')
mp.simPrompts = 1;  % turn on the simulation prompts/comments (these will be turned off when the HDL conversion process starts).
