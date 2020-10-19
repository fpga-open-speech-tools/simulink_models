% Matthew Blunt
% openMHA Test Attack-Release Filter w/ DP Memory Init Script
% 10/01/2020

% Created to test attack-release filter functionality with dual-port memory
% during openMHA implementation in order to ensure proper architecture 
% design in Simulink according to attack and release time standards

clear all;

%% Declare Sampling Rate

fs = 48000;

%% Declare Freq Band Information

% *** 3 Band Test Info *** %
num_bands = 2;

% *** 9 Band Test Info *** %
% num_bands = 9;

%% Declare Attack and Release Time Constants for Each Frequency Band

% Different time constants are chosen for easy difference in testing

% Base time constants
tau_a = 0.005; % seconds
tau_r = 0.020; % seconds

% Calculating vector easily via multiples of base constants
tau_as = tau_a.*[1:5:5*num_bands]';
tau_rs = tau_r.*[1:5:5*num_bands]';

z = 1;
for i = 1:2:2*num_bands-1
    ar_taus(i) = tau_as(z);
    ar_taus(i+1) = tau_rs(z);
    z = z+1;
end

% Added
ar_taus(1) = 0.005;
ar_taus(2) = 0.050;
ar_taus(3) = 0.020;
ar_taus(4) = 0.150;
%% Initialize Attack-Release Filter Coefficient Dual-Port Memory

% Declaring RAM port width
coeff_size = 8;

%% Calculate Attack-Release Filter Coefficients

% Calculating filter coefficients as done in the source code C++ file
% mha_filter.cpp

ar_coeffs = zeros(2^coeff_size,1);

ar_coeffs(1:2*num_bands) = exp( -1.0./(ar_taus(1:2*num_bands).*fs) );


%% Initialize Filter Buffer Values

buf_a = 65.*ones(num_bands,1);
buf_r = 65.*ones(num_bands,1);

% %% Initialize Filter Buffer Values
% 
% buf_a = 65.*ones(2^buf_size,1);
% buf_r = 65.*ones(2^buf_size,1);

%% Calculate New Attack-Release Filter Coefficients

ar_coeffs_new = [0.020 0.040 0.040 0.080 0.060 0.160]';

%% Declare Input Signal

% Data Input Signal (Input Level Lst)
Lst = [ 55.*ones(40000,1); 90.*ones(40000,1); 55.*ones(40000,1) ];

% % Data Input Signal (Input Level Lst)
% Lst = zeros(60,1);
% Lst(1:15) = 65;
% Lst(16:30) = 90;
% Lst(31:33) = 0;
% Lst(34:48) = 65;
% Lst(49:60) = 90;

%% Declare Control Signals

% Band Number State Controller Signal

% band_num = zeros(60,1);
for i = 1:2:60000*num_bands % norm 20
    band_num(i) = 1;
    band_num(i+1) = 2;
%     band_num(i+2) = 3;
end

% Coefficient Write Enable Control Signal
write_en = zeros(120000,1); % norm 60
% write_en(31:33) = 1;

% Attack Coefficient Write Address Control Signal
write_addrA = zeros(120000,1); % norm 60
% write_addrA(31) = 0;
% write_addrA(32) = 2;
% write_addrA(33) = 4;

% Release Coefficient Write Address Control Signal
write_addrB = zeros(120000,1); % norm 60
% write_addrB(31) = 1;
% write_addrB(32) = 3;
% write_addrB(33) = 5;

% Attack Coefficient Write Data Control Signal
write_dataA = zeros(120000,1); % norm 60
% write_dataA(31) = ar_coeffs_new(1);
% write_dataA(32) = ar_coeffs_new(3);
% write_dataA(33) = ar_coeffs_new(5);

% Release Coefficient Write Data Control Signal
write_dataB = zeros(120000,1); % norm 60
% write_dataB(31) = ar_coeffs_new(2);
% write_dataB(32) = ar_coeffs_new(4);
% write_dataB(33) = ar_coeffs_new(6);


%% Declare Stop Time

stop_time = length(Lst) - 1;