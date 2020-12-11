% modelparameters.m  
%
% Copyright 2020 AudioLogic, Inc
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Connor Dack
% AudioLogic, Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

%% Initialize
addpath(genpath('attack_decay'));            % Attack and Decay Block
addpath(genpath('gaintable'));               % Gain Table
addpath(genpath('..\referenced_functions')); % Frost Library

load signal_conversion_sim.mat % Simulation Results from the Signal Conversion Block
stop_time = level_dB_sim.Time(end);% Compute the simulation end point

%% Debug Flag
debug = false;

%% Autogen parameters
mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\mef_result_subset.wav'];

mp.sim_prompts = 1;
mp.sim_verify  = 1;
mp.simDuration = 15;
mp.nSamples    = config.system.sampleClockFrequency * mp.simDuration;
mp.useAvalonInterface = false;

%% Open MHA Parameters 
audio_fs           = 48e3;                          % Audio Sampling Rate from the AD1939
fft_up_sample_rate = 128;                           % FFT Up Sample Rate
fs                 = audio_fs * fft_up_sample_rate; % Samplig Frequency

coeff_size  = 8;             % Coefficient Address Size
num_bands   = 8;             % Number of Frequency Bands
band_number = 1:1:num_bands; % Create an array of band numbers
num_coeff   = 2;             % Number of C1 Coefficients required by the Attack and Decay Filter

%% Simulation Type - Either 'double' or 'fxpt'
sim_type = 'fxpt';                  

% Data Input/Feedback Fixed Point Paramters
in_fp_size = 40; % Word Size
in_fp_dec  = 32; % Fractional Bits
in_fp_sign = 1;  % Unsigned = 0, Signed = 1

% Attack and Decay Coefficient Fixed Point Paramters
ad_coeff_fp_size = 16; % Word Size
ad_coeff_fp_dec  = 16; % Fractional Bits
ad_coeff_fp_sign = 0;  % Unsigned = 0, Signed = 1

% Gain - Fixed Point Paramters
gain_coeff_fp_size = 16; % Word Size
gain_coeff_fp_dec  = 8;  % Fractional Bits
gain_coeff_fp_sign = 1;  % Unsigned = 0, Signed = 1

% Prelook Up Table: Fractional - Fixed Point Paramters
frac_coeff_fp_size = 32; % Word Size
frac_coeff_fp_dec  = 32; % Fractional Bits
frac_coeff_fp_sign = 0;  % Unsigned = 0, Signed = 1

% Define the Input Data Types
if(strcmp(sim_type,'double'))
    input_type      = 'double';
    ad_coeff_type   = 'double';
    gain_coeff_type = 'double';
    frac_coeff_type = 'double';
elseif(strcmp(sim_type,'fxpt'))
    input_type      = fixdt(in_fp_sign,in_fp_size,in_fp_dec);
    ad_coeff_type   = fixdt(ad_coeff_fp_sign,ad_coeff_fp_size,ad_coeff_fp_dec);
    gain_coeff_type = fixdt(gain_coeff_fp_sign,gain_coeff_fp_size,gain_coeff_fp_dec);
    frac_coeff_type = fixdt(frac_coeff_fp_sign,frac_coeff_fp_size,frac_coeff_fp_dec);
end

%% Attack and Decay DP-RAM Parameters
%--Attack Coefficients
%-Initialize the attack coefficient arrays: 1 coefficient per band
if(strcmp(sim_type,'double'))
    attack_c1_a_array = zeros(num_bands,1);
    attack_c2_a_array = zeros(num_bands,1);
    attack_c1_r_array = zeros(num_bands,1);
    attack_c2_r_array = zeros(num_bands,1);
elseif(strcmp(sim_type,'fxpt'))
    attack_c1_a_array = fi(zeros(num_bands,1), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);
    attack_c2_a_array = fi(zeros(num_bands,1), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);
    attack_c1_r_array = fi(zeros(num_bands,1), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);
    attack_c2_r_array = fi(zeros(num_bands,1), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);
end

for j = 1:num_bands
    if j == 1
        attack_attack_tau  = 0.005; % Defined in the Open MHA Plug in documnetation
    else
        attack_attack_tau  = attack_attack_tau /2; % Reduce the time constant by half for each consecutive band 
    end
    attack_release_tau = attack_attack_tau; % Set the release time constant equal to the attack time constant - Lines 450-451 of mha_filter.cpp
    
    [attack_c1_a_array(j,1), attack_c2_a_array(j,1)] = o1_lp_coeffs(attack_attack_tau, fs, sim_type, ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);  % Compute the attack coefficients - Lines 589-599 of mha_filter.cpp
    [attack_c1_r_array(j,1), attack_c2_r_array(j,1)] = o1_lp_coeffs(attack_release_tau, fs, sim_type, ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec); % Compute the release coefficients - Lines 589-599 of mha_filter.cpp
end
%--Decay Coefficients
%-Initialize the decay coefficient arrays: 1 coefficient per band
if(strcmp(sim_type,'double'))
    decay_c1_a_array = zeros(num_bands,1);
    decay_c2_a_array = zeros(num_bands,1);
    decay_c1_r_array = zeros(num_bands,1);
    decay_c2_r_array = zeros(num_bands,1);
elseif(strcmp(sim_type,'fxpt'))
    decay_c1_a_array = fi(zeros(num_bands,1), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);
    decay_c2_a_array = fi(zeros(num_bands,1), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);
    decay_c1_r_array = fi(zeros(num_bands,1), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);
    decay_c2_r_array = fi(zeros(num_bands,1), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);
end

decay_attack_tau  = 0; % Line 507 of mha_filter.cpp
for j = 1:num_bands        
    if j == 1
        decay_release_tau = 0.060; % Defined in the Open MHA Plug in documnetation
    else
        decay_release_tau = decay_release_tau / 2; % Reduce the time constant by half for each consecutive band 
    end

    [decay_c1_a_array(j,1), decay_c2_a_array(j,1)] = o1_lp_coeffs(decay_attack_tau, fs, sim_type, ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);  % Compute the attack coefficients - Lines 589-599 of mha_filter.cpp
    [decay_c1_r_array(j,1), decay_c2_r_array(j,1)] = o1_lp_coeffs(decay_release_tau, fs, sim_type, ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec); % Compute the release coefficients - Lines 589-599 of mha_filter.cpp
end

%--Dual Port RAM Coefficient Array
ad_coeffs = zeros(2^coeff_size,1);
z = 1;
for i = 1:2:2*num_bands-1
    ad_coeffs(i,1)   = attack_c1_a_array(z);
    ad_coeffs(i+1,1) = decay_c1_r_array(z);
    z = z+1;
end

%% Attack and Decay Delay Block Paramters
buf_a = ones(num_bands,1) .* 65; % Initial Condition of the Attack Filter Delay Block
buf_d = ones(num_bands,1) .* 65; % Initial Condition of the Delay Filter Delay Block

%% Gain Table Parameters
% Pre Lookup Parameters
dB_min  = 0;
dB_step = 4;
prelookup_table_size = 24;

% Gain Parameters
dB_gain_low  = 20;
dB_gain_high = 50;

% Pre-lookup table values
input_levels_db = zeros(prelookup_table_size,1);
for i = 1:prelookup_table_size
    input_levels_db(i) = dB_min + (i-1)*dB_step;
end
dB_max = input_levels_db(end);
X_high = dB_max-dB_step;            % Declare maximum dB output suitable for Gain Table 
% Gain Tables
mins  = dB_gain_low*ones(1,num_bands);  % Maximum audio input level .......................................... dB
maxes = dB_gain_high*ones(1,num_bands); % Minimum audio input level .......................................... dB

vy = calculateGainArray(mins, maxes, input_levels_db);
vy = [vy zeros(1,256-length(vy))];
numgainentries = length(vy);
RAM_size = ceil(log2(numgainentries));

RAM_addresses = 2^RAM_size;

% Gain Value to prevent Dual Port Ram Write
gain_table_default_data = 16711680;




























