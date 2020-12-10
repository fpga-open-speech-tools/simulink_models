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
debug = false;

%% Model Parameters
fs          = 48e3;        % Sampling Freq
X_high      = 90;          % Declare maximum dB output suitable for Gain Table
num_bands   = 8;           % Number of Frequency Bands
band_number = 1:num_bands; % Band Number Array

% Gain Table Parameters
gtmin = 0;
gtstep = 3;
gtdata = [0 15 25 32 34 36 38 40 39.25 38.5 37.75 37 36.25 35.5 34.75 34 33.25 32.5 31.75 31 28 25 22 19 16 13 10 7 4 1 -2 -2];
table_length = length(gtdata);

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

%% Simulation Input Signals
input_levels_db = zeros(table_length,1);
for i = 1:table_length
    input_levels_db(i) = gtmin + (i-1)*gtstep;
end

% Declaring Gain Vectors for each Frequency Band in dB and Concatenating
gt_db = [];
for i = 1:num_bands
    gt_db = [gt_db gtdata];
end

% Map dB gains to Linear Factors
gt = 10.^(gt_db./20);

% Transposing Table to Simulate DP Memory Table
dp_gt = gt';

% Sizing DP Table to match Address Port Width of RAM Block
numgainentries = table_length*num_bands;
RAM_size = ceil(log2(numgainentries));
% RAM_size = ceil(log2(numgainentries));   % number of bits
RAM_addresses = 2^RAM_size;
vy = dp_gt;
for i = length(dp_gt)+1:RAM_addresses
    vy(i,1) = 0;
end


dB_length = 100;
data_in_array = zeros(dB_length*num_bands,1);
for i = 1:dB_length
    for j = 1:num_bands
        data_in_array(((i-1)*num_bands) + j,1) = i;
    end
end

time      = (0:length(data_in_array)-1)/fs;
stop_time = time(end);

if(strcmp(sim_type,'double'))
    data_in   = timeseries(data_in_array,time);
elseif(strcmp(sim_type,'fxpt'))
    data_in_array = fi(data_in_array,gain_coeff_fp_sign,gain_coeff_fp_size,gain_coeff_fp_dec);
    data_in   = timeseries(data_in_array,time);
end
    
    