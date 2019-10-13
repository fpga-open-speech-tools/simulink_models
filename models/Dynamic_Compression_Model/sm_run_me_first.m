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

%% Setup the directory paths & tool settings
% Model variables will be placed in a data structure called mp 
% (<model_abbreviation>_params)that can be passed to functions
mp.model_name           = 'simple_gain';                                       % model name initials
mp.model_abbreviation   = 'SG';                                                % model initials
mp.linux_device_version = '18.0';                                              % string that describes device version (typically set as Quartus version)
mp.model_path           = 'E:\git\nih_simulinklib\simple_gain';                % path to the model directory
mp.test_signals_path    = 'E:\git\nih_simulinklib\test_signals';               % path to test signals folder
mp.utility_path         = 'E:\git\nih_simulinklib\matlab';                     % path to test signals folder
mp.codegen_path         = 'E:\git\nih_simulinklib\vhdl_codegen';               % path to \vhdl_codegen folder
mp.quartus_path         = 'F:\intelFPGA_lite\18.0\quartus\bin64\quartus.exe';  % path to the Quartus executable
mp.python_path          = 'F:\Python\Python37\python.exe';                     % path to Python executable.
mp.linux_device_name    = mp.model_name;                                       % device driver name that Linux will see

%% Set up the paths
% Note: addpath() only sets the paths for the current Matlab session
addpath(mp.model_path)
addpath(mp.utility_path)
addpath(mp.codegen_path)
hdlsetuptoolpath('ToolName', 'Altera Quartus II', 'ToolPath', mp.quartus_path);  % setup the HDL toochain path that needs to be set before calling HDL workflow process
eval(['cd ' mp.model_path])  % change the working directory to the model directory

%% python
[python_version, python_exe, python_loaded] = pyversion;
if  python_loaded
    disp(['Using Python version ' python_version])
else
    pyversion(mp.python_path);    % Note: if the version changes from what is already loaded in Matlab, you will need to restart Matlab
end

%% Open the model
open_system(['sm_' mp.model_abbreviation])
% display popup reminder message 
helpdlg(sprintf(['NOTE: You will need to first run the Simulation for model ' mp.model_name ' to initialize variables in the Matlab workspace before converting to VHDL.']),'Reminder Message')
mp.sim_prompts = 1;  % turn on the simulation prompts/comments (these will be turned off when the HDL conversion process starts).

