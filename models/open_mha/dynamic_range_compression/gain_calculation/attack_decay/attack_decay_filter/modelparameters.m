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
Fs = 48e3;
num_bands = 1;
buf_a = 65 .* ones(num_bands,1); % Initial Condition of the Attack Filter Delay Block
buf_d = 65 .* ones(num_bands,1); % Initial Condition of the Delay Filter Delay Block

%% Attack Filter Parameters
% The Attack Filter is an "o1flt_lowpass_t" object - Line 105 of dc.hh
% Set the attack and release time constants equal for the attack filter
% Lines 448-452 of mha_filter.cpp
attack_attack_tau  = 0.005;             % Time Constant in seconds - from openMHA Dynamic Compression Plugin documentation
attack_release_tau = attack_attack_tau; % Time Constant in seconds
[attack_c1_a, attack_c2_a] = o1_lp_coeffs(attack_attack_tau,Fs);
[attack_c1_r, attack_c2_r] = o1_lp_coeffs(attack_release_tau,Fs);

%% Decay Filter Parameters
% The Decay Filter is an "o1flt_maxtrack_t" object - Line 106 of dc.hh
% Set the attack time constant = 0 - Line 507 of mha_filter.cpp
% Set the release time consant = milliseconds - Line 508 of mha_filter.cpp
decay_attack_tau  = 0;
decay_release_tau = 0.060; % Time Constant in seconds - from openMHA Dynamic Compression Plugin documentation:
[decay_c1_a, decay_c2_a] = o1_lp_coeffs(decay_attack_tau,Fs);
[decay_c1_r, decay_c2_r] = o1_lp_coeffs(decay_release_tau,Fs);
