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

%% Initialziation
addpath(genpath('o1_ar_filter_optimization'));

%% Autogen parameters
mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\mef_result_subset.wav'];

mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 15;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;
mp.useAvalonInterface = false;

mp.W_bits = 24;
mp.F_bits = 23;

%% Open MHA Parameters
fs          = 48e3;                    % Sampling Frequency
num_bands   = 2;                       % Number of Frequency Bands to Simulate
buf_a       = 65 .* ones(num_bands,1); % Initial Condition of the Attack Filter Delay Block
buf_d       = 65 .* ones(num_bands,1); % Initial Condition of the Delay Filter Delay Block

% Simulation Type - Either 'double' or 'fxpt'
sim_type    = 'double';                  

%% Fixed Point Sizes
% Coefficient Paramters
coeff_fp_size = 16; % Word Size
coeff_fp_dec  = 16; % Fractional Bits
coeff_fp_sign = 0;  % Unsigned = 0, Signed = 1

% Data Input/Feedback Paramters
in_fp_size = 40; % Word Size
in_fp_dec  = 32; % Fractional Bits
in_fp_sign = 1;  % Unsigned = 0, Signed = 1

%% Simulation Input for N Bands
% Define the Input Data Types
if(strcmp(sim_type,'double'))
    input_type = 'double';
    coeff_type = 'double';
elseif(strcmp(sim_type,'fxpt'))
    input_type = fixdt(in_fp_sign,in_fp_size,in_fp_dec);
    coeff_type = fixdt(coeff_fp_sign,coeff_fp_size,coeff_fp_dec);
end

% Initialization 
audio_input       = AudioSource.fromFile(mp.testFile, mp.Fs, mp.nSamples);  % Read in the audio file
audio_length      = audio_input.nSamples;                                   % Determine the number of points in the audio signal
data_input_matrix = zeros(audio_length, num_bands);                         % Define the input matrix as the audio signal length X the number of bands
data_input        = zeros(audio_input.nSamples * num_bands,1);              % Define the simulation input array 
stim_length       = length(data_input);                                     % Deteremine the simulation length
time              = (0:1:stim_length-1)/fs;                                 % Create the time vector for the simulation
simulation_time   = (stim_length-1)/fs;                                     % Compute the simulation end point

% Create the input signal
% Copy the audio input wave into each column of the data input matrix
for i = 1:num_bands
    data_input_matrix(:,i) = audio_input.audio(:,1);                        
end

% Create a single data input array by interleafing the columns
for i = 1:audio_length
    for j = 1:num_bands
        data_input(((i-1)*num_bands) + j,1) = data_input_matrix(i,j); 
    end
end
data_input_ts = timeseries(data_input, time); % Convert the data array to a time series

%% Attack Filter Parameters
% The Attack Filter is an "o1flt_lowpass_t" object - Line 105 of dc.hh
% Set the attack and release time constants equal for the attack filter
% Lines 448-452 of mha_filter.cpp

% Initialize the attack coefficient arrays: 1 coefficient per band
attack_c1_a_array = zeros(num_bands,1);
attack_c2_a_array = zeros(num_bands,1);
attack_c1_r_array = zeros(num_bands,1);
attack_c2_r_array = zeros(num_bands,1);


% Initialize the attack coefficient input arrays
attack_c1_a_in = zeros(stim_length,1);
attack_c2_a_in = zeros(stim_length,1);
attack_c1_r_in = zeros(stim_length,1);
attack_c2_r_in = zeros(stim_length,1);

for j = 1:num_bands
    if j == 1
        attack_attack_tau  = 0.005; % Defined in the Open MHA Plug in documnetation
    else
        attack_attack_tau  = attack_attack_tau /2; % Reduce the time constant by half for each consecutive band 
    end
    attack_release_tau = attack_attack_tau; % Set the release time constant equal to the attack time constant - Lines 450-451 of mha_filter.cpp
    [attack_c1_a_array(j,1), attack_c2_a_array(j,1)] = o1_lp_coeffs(attack_attack_tau,fs);  % Compute the attack coefficients - Lines 589-599 of mha_filter.cpp
    [attack_c1_r_array(j,1), attack_c2_r_array(j,1)] = o1_lp_coeffs(attack_release_tau,fs); % Compute the release coefficients - Lines 589-599 of mha_filter.cpp
end

% Create the coefficient input array 
% The coefficients are repeated [1:num_bands 1:num_bands]
for i = 1:audio_length
    for j = 1:num_bands
        attack_c1_a_in(((i-1)*num_bands) + j,1) = attack_c1_a_array(j,1);
        attack_c2_a_in(((i-1)*num_bands) + j,1) = attack_c2_a_array(j,1);
        attack_c1_r_in(((i-1)*num_bands) + j,1) = attack_c1_r_array(j,1);
        attack_c2_r_in(((i-1)*num_bands) + j,1) = attack_c2_r_array(j,1);
    end
end
% Convert the Attack Coefficient Array to a Timeseries
attack_c1_a_ts = timeseries(attack_c1_a_in,time);
attack_c2_a_ts = timeseries(attack_c2_a_in,time);
attack_c1_r_ts = timeseries(attack_c1_r_in,time);
attack_c2_r_ts = timeseries(attack_c2_r_in,time);

%% Decay Filter Parameters
% The Decay Filter is an "o1flt_maxtrack_t" object - Line 106 of dc.hh
% Set the attack time constant = 0 - Line 507 of mha_filter.cpp
% Set the release time consant = milliseconds - Line 508 of mha_filter.cpp
decay_c1_a_array = zeros(num_bands,1);
decay_c2_a_array = zeros(num_bands,1);
decay_c1_r_array = zeros(num_bands,1);
decay_c2_r_array = zeros(num_bands,1);

decay_c1_a_fp = zeros(stim_length,1);
decay_c2_a_fp = zeros(stim_length,1);
decay_c1_r_fp = zeros(stim_length,1);
decay_c2_r_fp = zeros(stim_length,1);

decay_attack_tau  = 0; % Line 507 of mha_filter.cpp
for j = 1:num_bands        
    if j == 1
        decay_release_tau = 0.060; % Defined in the Open MHA Plug in documnetation
    else
        decay_release_tau = decay_release_tau / 2; % Reduce the time constant by half for each consecutive band 
    end

    [decay_c1_a_array(j,1), decay_c2_a_array(j,1)] = o1_lp_coeffs(decay_attack_tau,fs);  % Compute the attack coefficients - Lines 589-599 of mha_filter.cpp
    [decay_c1_r_array(j,1), decay_c2_r_array(j,1)] = o1_lp_coeffs(decay_release_tau,fs); % Compute the release coefficients - Lines 589-599 of mha_filter.cpp
end

% Create the coefficient input array 
% The coefficients are repeated [1:num_bands 1:num_bands]
for i = 1:audio_length
    for j = 1:num_bands
        decay_c1_a_fp(((i-1)*num_bands) + j,1) = decay_c1_a_array(j,1);
        decay_c2_a_fp(((i-1)*num_bands) + j,1) = decay_c2_a_array(j,1);
        decay_c1_r_fp(((i-1)*num_bands) + j,1) = decay_c1_r_array(j,1);
        decay_c2_r_fp(((i-1)*num_bands) + j,1) = decay_c2_r_array(j,1);
    end
end
% Convert the Attack Coefficient Array to a Timeseries
decay_c1_a_ts = timeseries(decay_c1_a_fp,time);
decay_c2_a_ts = timeseries(decay_c2_a_fp,time);
decay_c1_r_ts = timeseries(decay_c1_r_fp,time);
decay_c2_r_ts = timeseries(decay_c2_r_fp,time);

