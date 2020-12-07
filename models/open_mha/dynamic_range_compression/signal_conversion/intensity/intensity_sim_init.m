% intensity_sim_init.m 
%
% The following script is designed as an init script for the Intensity
% Simulink model. It sets the parameters for both the 
% Simulink model and the comparison MATLAB computation. In addition, it 
% provides the test signals for the Simulink Model.
%
% Copyright 2020 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Matthew Blunt
% Audio Logic
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

% openMHA Dynamic Compression Simulink Model Code
% Intensity Test/Verification Simulation Init Script
% 11/18/2020

clear all;
close all;

%% Declare Sampling Rate
fs = 48000;

%% Simulation Type - Either 'double' or 'fxpt'
sim_type = 'fxpt';                  

% Data Input/Feedback Fixed Point Paramters
in_fp_size = 40; % Word Size
in_fp_dec  = 32; % Fractional Bits
in_fp_sign = 1;  % Unsigned = 0, Signed = 1

% Define the Input Data Types
if(strcmp(sim_type,'double'))
    input_type    = 'double';
elseif(strcmp(sim_type,'fxpt'))
    input_type    = fixdt(in_fp_sign,in_fp_size,in_fp_dec);
end

%% Declare FFT Parameters
FFTsize = 256;
num_bins = FFTsize/2 + 1;
freq = linspace(0,24000,129);
binwidth = (fs/2)/(FFTsize/2);

%% Declare Freq Band Information
% *** 8 Band Test Info *** %
num_bands = 8;
ef = [0 250 500 750 1000 2000 4000 12000 24000];

% Calculate Freq Band State Controller Parameters
band_sizes = calculate_band_sizes(ef, num_bins, binwidth, num_bands);
band_edges = calculate_band_edges(ef, num_bins, binwidth, num_bands);
mirrored_band_edges = calculate_mirrored_band_edges(band_sizes, FFTsize, num_bins, num_bands);
band_edges = [band_edges mirrored_band_edges];

%% Simulation Input Signals (Random Input Signal Test Case)
% Signal Length Multiplier
input_length = 6;

% Organizing FFT Data Input Vectors
% i = 1;
FFT_data_real = [];
FFT_data_imag = [];
for i = 1:input_length
    FFT_data_real = [0.1.*rand(1,256) zeros(1,44)];
    FFT_data_imag = [0.1.*rand(1,256) zeros(1,44)];
end

% Find length of input signal
inlength = length(FFT_data_real);

% Calculate Valid Signal
valid_data = zeros(size(FFT_data_real));
valid_data(find(FFT_data_real)) = 1;

% Declare Bin Number Signal
bin_num = [];
for i = 1:(inlength/300)
   bin_num = [bin_num 0:1:255 zeros(1,44)];
end

% Calculate Band Number Signal
for i = 1:inlength
    band_num(i) = band_state_controller(bin_num(i), band_edges, num_bins, FFTsize, valid_data(i));
end

% Calculate Accumulator Reset Signal
accumulator_reset = [];
for i = 1:(inlength/300)
    accumulator_reset = [accumulator_reset 1 logical(diff(band_num(1:300)))];
end

%% Simulation Time
stop_time = (inlength - 1)/fs;
