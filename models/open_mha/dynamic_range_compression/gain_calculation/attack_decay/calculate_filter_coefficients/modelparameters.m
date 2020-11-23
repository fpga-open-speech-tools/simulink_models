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

% Open MHA Parameters 
fs = 48e3;
coeff_size = 8;
num_bands  = 8;
num_coeff  = 2;

% Data Input Array
band_num_input = [1:1:num_bands num_bands:-1:1];
band_num_input = [band_num_input band_num_input band_num_input band_num_input band_num_input];

mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 15;
mp.nSamples = length(band_num_input);
mp.useAvalonInterface = false;

mp.W_bits = 24;
mp.F_bits = 23;

%% Attack and Decay DPRAM Parameters
% Base time constants
tau_a = 0.020; % seconds
tau_d = 0.100; % seconds

% Calculating vector easily via multiples of base constants
tau_as = tau_a.*[1:0.2:num_bands]';
tau_ds = tau_d.*[1:0.2:num_bands]';

% Initialization
ad_taus   = zeros(2^coeff_size,1);
ad_coeffs = zeros(2^coeff_size,1);

% Create the Coefficient Array
z = 1;
for i = 1:2:2*num_bands-1
    [ad_coeffs(i,1), ~]   = o1_lp_coeffs(tau_as(z), fs);
    [ad_coeffs(i+1,1), ~] = o1_lp_coeffs(tau_ds(z), fs);
    z = z+1;
end
time = (0:1:length(band_num_input)-1) *1/fs;
band_num_timeseries = timeseries(band_num_input,time);

