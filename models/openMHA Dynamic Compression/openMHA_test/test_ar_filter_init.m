% Matthew Blunt
% openMHA Test Attack-Release Filter Init Script
% 09/23/2020

% Created to test attack-release filter functionality during 
% openMHA implementation in order to ensure proper architecture design in
% Simulink according to attack and release time standards

clear all;

%% Declare Sampling Rate

fs = 48000;


%% Declare Attack and Release Time Constants

% Note that example attack and release time constants found in the openMHA 
% Dynamic Compression Plugin documentation are used for testing

tau_a = 0.010; % seconds
tau_r = 0.015; % seconds


%% Calculate Attack-Release Filter Coefficients

% Calculating filter coefficients as done in the source code C++ file
% mha_filter.cpp

% Attack Filter Coefficients
c1_a = exp( -1.0/(tau_a * fs) );
c2_a = 1.0 - c1_a;

% Release Filter Coefficients
c1_r = exp( -1.0/(tau_r * fs) );
c2_r = 1.0 - c1_r;


%% Declare Input Signal

% Data Input Signal (Input Level Lst)
Lst = [ 55.*ones(20000,1); 90.*ones(20000,1); 55.*ones(20000,1) ];

% Plotting Input Signal
% figure()
% plot(Lst);
% title('Input Level Test Signal');
% xlabel('Sample Number');
% ylabel('Input Level [dB SPL]');
% ylim([50,95]);


%% Declare Stop Time

stop_time = length(Lst) - 1;
