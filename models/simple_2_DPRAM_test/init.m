%% E. Bailey Galacci
% Flat Earth Inc.
% 10/13/2019

% This script is to initialize the Simple_2_DPRAM_test simulink model

% Parameters of the model are:
%   W_Bits, F_Bits, Addr_Bits, Sel_Bits, 
%   RAM_X_SEL, LED_Bits
%   Ts_system, Ts
%
%
% Inputs of the model are:
%   Avalon Control Signals:
%       Avalon_Source_Valid
%       Avalon_Source_Data
%       Avalon_Source_Channel
%       Avalon_Source_Error
%
%   Register Control Signals:
%       Register_Data
%       Register_Addr
%   
%
% Outputs of the model are:
%   Avalon Sink Signals:
%       Avalon_Sink_Valid
%       Avalon_Sink_Data
%       Avalon_Sink_Channel
%       Avalon_Sink_Error
%

%% To do: set up these model things as an object mp (model parameters)
clear; clc;

MODEL_NOT_REAL = 1;

%% Setting up model parameters:
Fs = 48000; % Hz, this is the standard input rate of the audio codec
Ts = 1/Fs;

if (MODEL_NOT_REAL)
    Fs_system = Fs*5;   % this is here solely to use up less space
else
    Fs_system = 50000000; % 50 MHz, this is the clock rate we expect of the DE10
end
Ts_system = 1/Fs_system;
W_bits = 32; F_bits = 28;


% THINGS WE CAN MESS AROUND WITH
Addr_bits = 4;
Sel_Bits = 1; % 1, since there are two RAM blocks
RAM_0_SEL = 0; RAM_1_SEL = 1;
LED_Bits = 8; % there are 8 LEDs we can output to. Might as well use them all.

%% Setting up model inputs:
tt_system = (0:Ts_system:Ts_system*20)';    %%%% NOTE: set low because simplicity of model
tt_inputs = (0:Ts:Ts_system*20)';
% Avalon Control Signals:
Avalon_Source_Valid = [tt_system, ones(length(tt_system), 1)];
Avalon_Source_Data = [tt_system, ones(length(tt_system), 1)];
Avalon_Source_Channel = [tt_system, zeros(length(tt_system), 1)];
Avalon_Source_Error = [tt_system, zeros(length(tt_system), 1)];

% Register Control Signals:
Register_Data = [tt_system, ones(length(tt_system), 1)];
Register_Addr = [tt_system, ones(length(tt_system), 1)];