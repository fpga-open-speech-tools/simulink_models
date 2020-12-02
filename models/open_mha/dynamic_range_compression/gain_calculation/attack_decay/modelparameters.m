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
addpath(genpath('attack_decay_filter'));           % Attack and Decay Filter
addpath(genpath('calculate_filter_coefficients')); % Attack and Decay Filter Coefficients
addpath(genpath('..\..\referenced_functions'));    % Dual Port RAM - Frost Library

%% Autogen parameters
mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\mef_result_subset.wav'];

mp.sim_prompts = 1;
mp.sim_verify  = 1;
mp.simDuration = 15;
mp.nSamples    = config.system.sampleClockFrequency * mp.simDuration;
mp.useAvalonInterface = false;

%% Open MHA Parameters 
fs          = 48e3;          % Samplig Frequency
coeff_size  = 8;             % Coefficient Address Size
num_bands   = 8;             % Number of Frequency Bands
band_number = 1:1:num_bands; % Create an array of band numbers
num_coeff   = 2;             % Number of C1 Coefficients required by the Attack and Decay Filter

%% Simulation Type - Either 'double' or 'fxpt'
%--Only Fixed Point works with the Current Dual Port RAM Block--
sim_type = 'fxpt';                  

% Attack and Decay Coefficient Fixed Point Paramters
ad_coeff_fp_size = 16; % Word Size
ad_coeff_fp_dec  = 16; % Fractional Bits
ad_coeff_fp_sign = 0;  % Unsigned = 0, Signed = 1

% Data Input/Feedback Fixed Point Paramters
in_fp_size = 40; % Word Size
in_fp_dec  = 32; % Fractional Bits
in_fp_sign = 1;  % Unsigned = 0, Signed = 1

% Define the Input Data Types
if(strcmp(sim_type,'double'))
    input_type    = 'double';
    ad_coeff_type = 'double';
elseif(strcmp(sim_type,'fxpt'))
    input_type    = fixdt(in_fp_sign,in_fp_size,in_fp_dec);
    ad_coeff_type = fixdt(ad_coeff_fp_sign,ad_coeff_fp_size,ad_coeff_fp_dec);
end

%% Initialization 
audio_input       = AudioSource.fromFile(mp.testFile, mp.Fs, mp.nSamples);  % Read in the audio file
audio_length      = audio_input.nSamples;                                   % Determine the number of points in the audio signal
data_input_matrix = zeros(audio_length, num_bands);                         % Define the input matrix as the audio signal length X the number of bands
data_input_array  = zeros(audio_length * num_bands,1);                      % Define the simulation input array 
stim_length       = length(data_input_array);                               % Deteremine the simulation length
time              = (0:1:stim_length-1)/fs;                                 % Create the time vector for the simulation
simulation_time   = (stim_length-1)/fs;                                     % Compute the simulation end point

% Create the input signal
% Copy the audio input wave into each column of the data input matrix
for j = 1:num_bands
    data_input_matrix(:,j) = audio_input.audio(:,1);                        
end

% Create a single data input array by interleafing the columns
for i = 1:audio_length
    for j = 1:num_bands
        data_input_array(((i-1)*num_bands) + j,1) = data_input_matrix(i,j); 
    end
end
data_input_ts = timeseries(data_input_array, time); % Convert the data array to a time series

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
%-Initialization
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

