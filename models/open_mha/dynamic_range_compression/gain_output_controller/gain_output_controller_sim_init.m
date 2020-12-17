% Copyright 2020 Audio Logic
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

%% Initialization
% load gain_calculation_simulation.mat         % Results from the Gain Calcualtion Block
addpath(genpath('..\referenced_functions')); % Frost Library

%% Debug Mode
debug = false;

%% Open MHA Parameters 
audio_fs           = 48e3;                          % Audio Sampling Rate from the AD1939
fft_up_sample_rate = 128;                           % FFT Up Sample Rate
fs                 = audio_fs * fft_up_sample_rate; % Samplig Frequency

%% Simulation Type - Either 'double' or 'fxpt'
sim_type = 'fxpt';                  

% Gain - Fixed Point Paramters
gain_coeff_fp_size = 16; % Word Size
gain_coeff_fp_dec  = 8;  % Fractional Bits
gain_coeff_fp_sign = 1;  % Unsigned = 0, Signed = 1

% Define the Input Data Types
if(strcmp(sim_type,'double'))
    gain_coeff_type = 'double';
elseif(strcmp(sim_type,'fxpt'))
    gain_coeff_type = fixdt(gain_coeff_fp_sign,gain_coeff_fp_size,gain_coeff_fp_dec);
end

%% Gain Output Controller Parameters
% FFT Parameters
FFTsize = 256;
num_bins = FFTsize/2 + 1;
freq = linspace(0,24000,129);
binwidth = (audio_fs/2)/(FFTsize/2);

num_bands = 8;
ef = [0 250 500 750 1000 2000 4000 12000 24000];
band_sizes = calculate_band_sizes(ef, num_bins, binwidth, num_bands);

% Delay Parameters
system_delay = max(band_sizes) + 6;
accumulator_delay = max(band_sizes);

% Gain Output Dual Port Memory Parameters
gainapp_dp_memory = log2(num_bands) + 1;
gain_delay = 6;
accum_delay = max(band_sizes);
system_delay = gain_delay + accum_delay;
accum_delay_memory = ceil(log2(accum_delay));
system_delay_memory = ceil(log2(system_delay));
delay_memory_size =2^system_delay_memory;
accum_delay_memory_size = 2^accum_delay_memory;

%% Generate Test Signals for Validation

% Load Original Signals from Gaintable Output
load('gainapp_original_signals.mat');

% Now creating new signals w/ appropriate delay adjustments
gain_signal = [zeros(1,system_delay - accumulator_delay)];
grab_accumulator_signal = [zeros(1,system_delay - accumulator_delay)];
FFT_data_signal = [zeros(1,system_delay + 1)];
adjusted_gain_signal = [zeros(1,system_delay + 1)];

% Adjusting new signals to mirror associated band_number
for i = 1:4
    FFT_data_signal = [FFT_data_signal complex(1,1).*ones(1,band_sizes(1)) complex(2,2).*ones(1,band_sizes(2)) complex(3,3).*ones(1,band_sizes(3)) complex(4,4).*ones(1,band_sizes(4)) complex(5,5).*ones(1,band_sizes(5)) complex(6,6).*ones(1,band_sizes(6)) complex(7,7).*ones(1,band_sizes(7)) complex(8,8).*ones(1,band_sizes(8)) complex(8,8).*ones(1,band_sizes(8)-1) complex(7,7).*ones(1,band_sizes(7)) complex(6,6).*ones(1,band_sizes(6)) complex(5,5).*ones(1,band_sizes(5)) complex(4,4).*ones(1,band_sizes(4)) complex(3,3).*ones(1,band_sizes(3)) complex(2,2).*ones(1,band_sizes(2)) complex(1,1).*ones(1,band_sizes(1)-1) zeros(1,44)];
    gain_signal = [gain_signal 1.*ones(1,band_sizes(2)) 2.*ones(1,band_sizes(3)) 3.*ones(1,band_sizes(4)) 4.*ones(1,band_sizes(5)) 5.*ones(1,band_sizes(6)) 6.*ones(1,band_sizes(7)) 7.*ones(1,band_sizes(8)-1) 8.*ones(1,174)];
end

% Band Number and Grab Accumulator signals are good, but repetitive. 
% We only need to show that the Controller works for multiple rounds of 
% FFT data and produces accurate results on time.
band_num_signal = band_num(1,1:length(gain_signal));
grab_accumulator_signal = grab_accumulator(1:length(gain_signal));

%% Converting Signals to Appropriate Data Type
gain_signal = fi(gain_signal,1,16,8);
band_num_signal = cast(band_num_signal,'uint8');
grab_accumulator_signal = cast(grab_accumulator_signal,'logical');

%% Comparing Signals to Validate Structure

% gain_check = isequal(logical(diff(gain(7:end))),logical(diff(gain_signal(7:end))));
% FFT_data_check = isequal(logical(diff(FFT_data)),logical(diff(real(FFT_data_signal))));
% adjusted_gain_check = isequal(logical(diff(adjusted_gain(72:end))),logical(diff(adjusted_gain_signal(72:end))));

%% Simulation Stop Time
stop_time          = length(gain_signal)/fs;
