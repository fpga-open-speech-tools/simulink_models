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
addpath(genpath('band_controller'));         % Frequency Band State Controller
addpath(genpath('intensity'));               % Intensity Conversion
addpath(genpath('dB_lookup_table'));         % pa2 to dB Look Up Table
addpath(genpath('..\referenced_functions')); % Frost Library

load('fft_simulation.mat')
%% Open MHA Parameters
audio_fs           = 48e3;                          % Audio Sampling Rate from the AD1939
fft_up_sample_rate = 128;                           % FFT Up Sample Rate
fs                 = audio_fs * fft_up_sample_rate; % Samplig Frequency
coeff_size         = 8;                             % Coefficient Address Size
num_bands          = 8;                             % Number of Frequency Bands
band_number        = 1:1:num_bands;                 % Create an array of band numbers
num_coeff          = 2;                             % Number of C1 Coefficients required by the Attack and Decay Filter

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

%% Initialization 
% Declare FFT Parameters
FFTsize = 256;
num_bins = FFTsize/2 + 1;
freq = linspace(0,24000,129);
binwidth = (audio_fs/2)/(FFTsize/2);

%% Declare Freq Band Information
num_bands = 8;
ef = [0 250 500 750 1000 2000 4000 12000 24000];

% Calculate Freq Band State Controller Parameters
band_sizes = calculate_band_sizes(ef, num_bins, binwidth, num_bands);
band_edges = calculate_band_edges(ef, num_bins, binwidth, num_bands);
mirrored_band_edges = calculate_mirrored_band_edges(band_sizes, FFTsize, num_bins, num_bands);
band_edges = [band_edges mirrored_band_edges];

%% Simulation Time
stop_time = fft_valid_sim.Time(end);