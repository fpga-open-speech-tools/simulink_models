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
mp.fastsim_Fs_system_N = 8;     % (typical value 2 or 4) Simulate a much slower system clock than what is specified in sm_callback_init.m   - The reduce rate will be a multiple of the sample rate, i.e. mp.Fs_system = mp.Fs*mp.fastsim_Fs_system_N
mp.fastsim_Nsamples = 48000; % set to the string 'all' to use all the samples from the input signal specified in sm_init_test_signals.m


%% Model parameters
% Model parameters are placed in a data structure called mp that can be passed to functions
mp.model_name = 'echo';    % directory name of model
mp.model_abbreviation = 'SE';

% Device driver version for the Linux device tree. Typically set as the Quartus version
mp.linux_device_name = mp.model_name;
mp.linux_device_version = '18.0';

%% Setup the directory paths & tool settings
addpath('../../config');
if isunix  % setup for a Linux platform
    pathSetupLinux;
elseif ispc % setup for a Windows platform
    pathSetupWindows;  
end

% Change the working directory to the model directory (this might already be the case)
cd(mp.model_path)


%% Open the model
disp(['Please wait while the Simulink Model: '  mp.model_name  ' is being opened.'])
disp(['Note: Before generating VHDL, you will need to run a model simulation.'])
open_system([mp.model_abbreviation])
% display popup reminder message
helpdlg(sprintf(['NOTE: You will need to first run the Simulation for model ' mp.model_name ' to initialize variables in the Matlab workspace before converting to VHDL.']),'Reminder Message')
mp.sim_prompts = 1;  % turn on the simulation prompts/comments (these will be turned off when the HDL conversion process starts).
