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
% Model variables will be placed in a data structure called model_params 
% (<model_abbreviation>_params)that can be passed to functions
model_params.model_name           = 'simple_gain';                                       % model name initials
model_params.model_abbreviation   = 'SG';                                                % model initials
model_params.linux_device_name    = model_params.model_name;                             % device driver name that Linux will see
model_params.linux_device_version = '18.0';                                              % string that describes device version (typically set as Quartus version)
model_params.model_path           = 'E:\git\nih_simulinklib\simple_gain';                % path to the model directory
model_params.test_signals_path    = 'E:\git\nih_simulinklib\test_signals';               % path to test signals folder
model_params.codegen_path         = 'E:\git\nih_simulinklib\vhdl_codegen';               % path to \vhdl_codegen folder
model_params.quartus_path         = 'F:\intelFPGA_lite\18.0\quartus\bin64\quartus.exe';  % path to the Quartus executable
model_params.python_path          = 'F:\Python\Python37\python.exe';                     % path to Python executable.

%% Set up the paths
% Note: addpath() only sets the paths for the current Matlab session
addpath(model_params.model_path)
addpath(model_params.codegen_path)
hdlsetuptoolpath('ToolName', 'Altera Quartus II', 'ToolPath', model_params.quartus_path);  % setup the HDL toochain path that needs to be set before calling HDL workflow process
eval(['cd ' model_params.model_path])  % change the working directory to the model directory
pyversion(model_params.python_path);    % Note: if the version changes from what is already loaded in Matlab, you will need to restart Matlab

%% Open the model
open_system(model_params.model_abbreviation)
% display popup reminder message 
helpdlg(sprintf(['NOTE: You will need to first run the Simulation for model ' model_params.model_name ' to initialize variables in the Matlab workspace before converting to VHDL.']),'Reminder Message')
model_params.sim_prompts = 1;  % turn on the simulation prompts/comments (these will be turned off when the HDL conversion process starts).

