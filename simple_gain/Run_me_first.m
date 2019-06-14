%--------------------------------------------------------------------------
% Description:  Matlab script to setup environment for Simulink VHDL code
%               generation
%--------------------------------------------------------------------------
% Author:       Ross K. Snider
% Company:      Flat Earth Inc
%               985 Technology Blvd
%               Bozeman, MT 59718
%               support@flatearthinc.com
% Create Date:  June 7, 2019
% Tool Version: MATLAB R2019a
% Revision:     1.0
% License:      MIT License (see license at end of code)
%--------------------------------------------------------------------------
%------------- BEGIN CODE --------------
clear all
close all
clc

%--------------------------------------------------------------------------
% Setup directory paths & tool settings
%--------------------------------------------------------------------------
model_name   = 'SG';                                % model name
model_path   = 'E:\NIH\Simulink\Simple_Gain';       % path to the model directory
codegen_path = 'E:\NIH\Simulink\vhdl_codegen';      % path to \vhdl_codegen folder
quartus_path = 'F:\intelFPGA_lite\18.0\quartus\bin64\quartus.exe';  % path to the Quartus executable

%--------------------------------------------------------------------------
% Set up the paths
% Note: addpath() only sets the path for the current Matlab session
%--------------------------------------------------------------------------
addpath(model_path)
addpath(codegen_path)
hdlsetuptoolpath('ToolName', 'Altera Quartus II', 'ToolPath', quartus_path);
eval(['cd ' model_path])  % change working directory to model directory

%--------------------------------------------------------------------------
% Open the model
%--------------------------------------------------------------------------
open_system(model_name)
% display popup message
helpdlg(sprintf(['NOTE: You will need to run the Simulation for model ' model_name ' to initialize variables in the Matlab workspace before converting to VHDL.']))

%------------- END OF CODE --------------
%--------------------------------------------------------------------------
% MIT License
% Copyright (c) 2019 Flat Earth Inc
%
%Permission is hereby granted, free of charge, to any person obtaining a copy
%of this software and associated documentation files (the "Software"), to deal
%in the Software without restriction, including without limitation the rights
%to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%copies of the Software, and to permit persons to whom the Software is
%furnished to do so, subject to the following conditions:
%
%The above copyright notice and this permission notice shall be included in all
%copies or substantial portions of the Software.
%
%THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%SOFTWARE.
%--------------------------------------------------------------------------
