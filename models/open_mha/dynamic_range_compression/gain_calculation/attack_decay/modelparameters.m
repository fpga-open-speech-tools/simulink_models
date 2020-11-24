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
addpath(genpath('..\attack_decay_filter'));           % Attack and Decay Filter
addpath(genpath('..\calculate_filter_coefficients')); % Attack and Decay Filter Coefficients
addpath(genpath('..\..\..\referenced_functions'));    % Dual Port RAM - Frost Library

%% Autogen parameters
mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\mef_result_subset.wav'];

mp.sim_prompts = 1;
mp.sim_verify  = 1;
mp.simDuration = 15;
mp.nSamples    = config.system.sampleClockFrequency * mp.simDuration;
mp.useAvalonInterface = false;

%% Open MHA Parameters 
fs         = 48e3; % Samplig Frequency
coeff_size = 8;    % Coefficient Address Size
num_bands  = 8;    % Number of Frequency Bands
num_coeff  = 2;    % Number of C1 Coefficients required by the Attack and Decay Filter

%% Band Number Array
stim_length    = AudioSource.fromFile(mp.testFile, mp.Fs, mp.nSamples).nSamples;
band_num_input = zeros(stim_length,1);
for i = 1:stim_length
    band_num_input(i,1) = mod(i-1,num_bands) + 1;
end

time = (0:1:length(band_num_input)-1) * 1/fs;
band_num_timeseries = timeseries(band_num_input,time);

%% Attack and Decay DP-RAM Parameters
% Create tau values to generate C1 Coefficients between 0 and 1
tau_as = -1 ./ (log([0:1:num_bands-1] ./ num_bands) * fs);
tau_ds = -1 ./ (log([num_bands-1:-1:0] ./ num_bands) * fs);
% Initialization
ad_coeffs = fi(zeros(2^coeff_size,1),0,16,16);

% Create the Coefficient Array
z = 1;
for i = 1:2:2*num_bands-1
    [attack_c1, ~]   = o1_lp_coeffs(tau_as(z), fs);
    ad_coeffs(i,1)   = fi(attack_c1,0,16,16);
    [decay_c1, ~]    = o1_lp_coeffs(tau_ds(z), fs);
    ad_coeffs(i+1,1) = fi(decay_c1,0,16,16);
    z = z+1;
end

%% Attack and Decay Delay Block Paramters
buf_a = ones(num_bands,1) .* 65; % Initial Condition of the Attack Filter Delay Block
buf_d = ones(num_bands,1) .* 65; % Initial Condition of the Delay Filter Delay Block

