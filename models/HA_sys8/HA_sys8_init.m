clear all
close all
clc

%----------------------------------------------------------------------
% Create input test signal
%----------------------------------------------------------------------
Fs = 48000;                % sample rate
Ts = 1/Fs;                 % sample time
Ns = 200000;               % number of input samples
stopTime = (Ns-1) * Ts;
signal_in = HA_sys8_test_signal(Fs, Ns);
%----------------------------------------------------------------------
% Subsystem Setup
%----------------------------------------------------------------------
HA_sys8_left_init
HA_sys8_right_init

%----------------------------------------------------------------------
% Top Level Gain paramenters
%----------------------------------------------------------------------
% left
Gain_B1_left   = 1;
Gain_B2_left   = 1;
Gain_B3_left   = 1;
Gain_B4_left   = 1;
Gain_left_all  = 1;
% right
Gain_B1_right  = 1;
Gain_B2_right  = 1;
Gain_B3_right  = 1;
Gain_B4_right  = 1;
Gain_right_all = 1;

%----------------------------------------------------------------------
% VHDL generation control parameters
%----------------------------------------------------------------------
hdlset_param('HA_sys8', 'BalanceDelays', 'on');  % when 'on' this inserts delays to make all paths arrive at the output at the same time, this adds latency which we don't want

