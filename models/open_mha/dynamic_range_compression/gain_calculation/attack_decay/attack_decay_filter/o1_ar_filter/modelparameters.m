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

%% Autogen parameters
mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\mef_result_subset.wav'];

mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 15;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;
mp.useAvalonInterface = false;

mp.W_bits = 24;
mp.F_bits = 23;

%% Simulation Type - Either 'double' or 'fxpt'
sim_type    = 'double';                  

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

%% O1 AR Filter Coefficients
fs          = 48e3;
tau_attack  = 0.005;
tau_release = 0.060;
[c1_a_in, c2_a_in] = o1_lp_coeffs(tau_attack, fs);
[c1_r_in, c2_r_in] = o1_lp_coeffs(tau_release, fs);

%% Calculate the Results
audio_input = AudioSource.fromFile(mp.testFile, mp.Fs, mp.nSamples);  % Read in the audio file
data_input  = audio_input.audio(:,1);
total_stim  = audio_input.nSamples;                                   % Determine the number of points in the audio signal
time        = (0:1:total_stim-1)/fs;                                  % Create the time vector for the simulation

% Initialize Result Arrays
buff_in             = zeros(total_stim,1);
o1_ar_filter_matlab = zeros(total_stim,1);

for i =1:1:total_stim
    if i == 1
        buff_in(i) = 65;
    else
        buff_in(i) = o1_ar_filter_matlab(i-1,1);
    end
    o1_ar_filter_matlab(i,1) = o1_ar_filter_source(data_input(i,1), c1_a_in, c2_a_in, c1_r_in, c2_r_in, buff_in(i));
end

buff_in_ts = timeseries(buff_in,time);