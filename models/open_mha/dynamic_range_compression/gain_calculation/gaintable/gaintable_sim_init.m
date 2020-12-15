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

%% Initialize
addpath(genpath('linear_interpolation'));
addpath(genpath('..\..\referenced_functions'));

%% Debug Mode
debug = true;

%% Model Parameters
fs          = 48e3;        % Sampling Freq
num_bands   = 8;           % Number of Frequency Bands
band_number = 1:num_bands; % Band Number Array

% Pre Lookup Parameters
dB_min  = 0;
dB_step = 4;
prelookup_table_size = 24;

% Gain Parameters
dB_gain_low  = 20;
dB_gain_high = 50;

%% Simulation Type - Either 'double' or 'fxpt'
sim_type = 'fxpt';                  

% Gain - Fixed Point Paramters
gain_coeff_fp_size = 16; % Word Size
gain_coeff_fp_dec  = 8;  % Fractional Bits
gain_coeff_fp_sign = 1;  % Unsigned = 0, Signed = 1

% Prelook Up Table: Fractional - Fixed Point Paramters
frac_coeff_fp_size = 32; % Word Size
frac_coeff_fp_dec  = 32; % Fractional Bits
frac_coeff_fp_sign = 0;  % Unsigned = 0, Signed = 1

% Data Input/Feedback Fixed Point Paramters
in_fp_size = 40; % Word Size
in_fp_dec  = 32; % Fractional Bits
in_fp_sign = 1;  % Unsigned = 0, Signed = 1

% Define the Input Data Types
if(strcmp(sim_type,'double'))
    input_type      = 'double';
    gain_coeff_type = 'double';
    frac_coeff_type = 'double';
elseif(strcmp(sim_type,'fxpt'))
    input_type      = fixdt(in_fp_sign,in_fp_size,in_fp_dec);
    gain_coeff_type = fixdt(gain_coeff_fp_sign,gain_coeff_fp_size,gain_coeff_fp_dec);
    frac_coeff_type = fixdt(frac_coeff_fp_sign,frac_coeff_fp_size,frac_coeff_fp_dec);
end

%% Gain Table Parameters
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

%% Simulation Input Signals
sim_length = 100;
data_in_array = zeros(sim_length*num_bands,1);
for i = 1:sim_length
    for j = 1:num_bands
        data_in_array(((i-1)*num_bands) + j,1) = i;
    end
end

data_in_array = cat(1,data_in_array(1:num_bands*prelookup_table_size), data_in_array);

time      = (0:length(data_in_array)-1)/fs;
stop_time = time(end);

data_in   = timeseries(data_in_array,time);    
    