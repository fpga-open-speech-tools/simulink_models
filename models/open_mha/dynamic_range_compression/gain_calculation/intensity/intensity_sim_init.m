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

%% NOTES

% The following script is designed as an init script for the Intensity
% Simulink model. It sets the parameters for both the 
% Simulink model and the comparison MATLAB computation. In addition, it 
% provides the test signals for the Simulink Model.

%% Declare Sampling Rate

fs = 48000;

%% Declare Data Type

Wbits = 40;    %fixdt(1,Wbits,Fbits)
Fbits = 32;

%% Declare FFT Parameters

FFTsize = 256;
num_bins = FFTsize/2 + 1;
freq = linspace(0,24000,129);
binwidth = (fs/2)/(FFTsize/2);

%% Declare Freq Band Information

% *** 2 Band Test Info *** %
% num_bands = 2;
% ef = [0 11999 24000];

% *** 8 Band Test Info *** %
num_bands = 8;
ef = [0 250 500 750 1000 2000 4000 12000 24000];

% Calculate Freq Band State Controller Parameters
band_sizes = calculate_band_sizes(ef, num_bins, binwidth, num_bands);
band_edges = calculate_band_edges(ef, num_bins, binwidth, num_bands);
mirrored_band_edges = calculate_mirrored_band_edges(band_sizes, FFTsize, num_bins, num_bands);
band_edges = [band_edges mirrored_band_edges];


% %% Simulation Input Signals (Controlled Input Signal Test Case)
% 
% % Declare FFT Data Input Signal
% % Translate desired dB value and number of bins per band into symmetric FFT
% % data
% 
% % Signal Length Multiplier
% input_length = 6;
% 
% % Calculating FFT values according to desired band dB values
% for i = 1:num_bands
%    [Pa2val1(i),FFTval1(i)] = dB2lin(55,band_sizes(i));
%    [Pa2val2(i),FFTval2(i)] = dB2lin(90,band_sizes(i));
% end
% 
% % Calculating DC and Nyquist bin values, accounting for their
% % representation only once in the FFT stream\
% FFTval1(num_bands+1) = sqrt((Pa2val1(num_bands)/band_sizes(num_bands))/2);
% FFTval1(num_bands+2) = sqrt((Pa2val1(1)/band_sizes(1))/2);
% FFTval2(num_bands+1) = sqrt((Pa2val2(num_bands)/band_sizes(num_bands))/2);
% FFTval2(num_bands+2) = sqrt((Pa2val2(1)/band_sizes(1))/2);
% 
% % Organizing FFT Data Input Vectors
% i = 1;
% FFT_data_real = [];
% FFT_data_imag = [];
% for i = 1:input_length/3
%     FFT_data_real = [FFT_data_real FFTval1(10) FFTval1(1).*ones(1,band_sizes(1)-1) FFTval2(2).*ones(1,band_sizes(2)) FFTval1(3).*ones(1,band_sizes(3)) FFTval2(4).*ones(1,band_sizes(4)) FFTval1(5).*ones(1,band_sizes(5)) FFTval2(6).*ones(1,band_sizes(6)) FFTval1(7).*ones(1,band_sizes(7)) FFTval2(8).*ones(1,band_sizes(8)-1) FFTval2(9) FFTval2(8).*ones(1,band_sizes(8)-1) FFTval1(7).*ones(1,band_sizes(7)) FFTval2(6).*ones(1,band_sizes(6)) FFTval1(5).*ones(1,band_sizes(5)) FFTval2(4).*ones(1,band_sizes(4)) FFTval1(3).*ones(1,band_sizes(3)) FFTval2(2).*ones(1,band_sizes(2)) FFTval1(1).*ones(1,band_sizes(1)-1) zeros(1,44)];
%     FFT_data_imag = [FFT_data_imag FFTval1(10) FFTval1(1).*ones(1,band_sizes(1)-1) FFTval2(2).*ones(1,band_sizes(2)) FFTval1(3).*ones(1,band_sizes(3)) FFTval2(4).*ones(1,band_sizes(4)) FFTval1(5).*ones(1,band_sizes(5)) FFTval2(6).*ones(1,band_sizes(6)) FFTval1(7).*ones(1,band_sizes(7)) FFTval2(8).*ones(1,band_sizes(8)-1) FFTval2(9) FFTval2(8).*ones(1,band_sizes(8)-1) FFTval1(7).*ones(1,band_sizes(7)) FFTval2(6).*ones(1,band_sizes(6)) FFTval1(5).*ones(1,band_sizes(5)) FFTval2(4).*ones(1,band_sizes(4)) FFTval1(3).*ones(1,band_sizes(3)) FFTval2(2).*ones(1,band_sizes(2)) FFTval1(1).*ones(1,band_sizes(1)-1) zeros(1,44)];
% end
% i = 1;
% for i = 1:input_length/3
%     FFT_data_real = [FFT_data_real FFTval2(10) FFTval2(1).*ones(1,band_sizes(1)-1) FFTval1(2).*ones(1,band_sizes(2)) FFTval2(3).*ones(1,band_sizes(3)) FFTval1(4).*ones(1,band_sizes(4)) FFTval2(5).*ones(1,band_sizes(5)) FFTval1(6).*ones(1,band_sizes(6)) FFTval2(7).*ones(1,band_sizes(7)) FFTval1(8).*ones(1,band_sizes(8)-1) FFTval1(9) FFTval1(8).*ones(1,band_sizes(8)-1) FFTval2(7).*ones(1,band_sizes(7)) FFTval1(6).*ones(1,band_sizes(6)) FFTval2(5).*ones(1,band_sizes(5)) FFTval1(4).*ones(1,band_sizes(4)) FFTval2(3).*ones(1,band_sizes(3)) FFTval1(2).*ones(1,band_sizes(2)) FFTval2(1).*ones(1,band_sizes(1)-1) zeros(1,44)];
%     FFT_data_imag = [FFT_data_imag FFTval2(10) FFTval2(1).*ones(1,band_sizes(1)-1) FFTval1(2).*ones(1,band_sizes(2)) FFTval2(3).*ones(1,band_sizes(3)) FFTval1(4).*ones(1,band_sizes(4)) FFTval2(5).*ones(1,band_sizes(5)) FFTval1(6).*ones(1,band_sizes(6)) FFTval2(7).*ones(1,band_sizes(7)) FFTval1(8).*ones(1,band_sizes(8)-1) FFTval1(9) FFTval1(8).*ones(1,band_sizes(8)-1) FFTval2(7).*ones(1,band_sizes(7)) FFTval1(6).*ones(1,band_sizes(6)) FFTval2(5).*ones(1,band_sizes(5)) FFTval1(4).*ones(1,band_sizes(4)) FFTval2(3).*ones(1,band_sizes(3)) FFTval1(2).*ones(1,band_sizes(2)) FFTval2(1).*ones(1,band_sizes(1)-1) zeros(1,44)];
% end
% i = 1;
% for i = 1:input_length/3
%     FFT_data_real = [FFT_data_real FFTval1(10) FFTval1(1).*ones(1,band_sizes(1)-1) FFTval2(2).*ones(1,band_sizes(2)) FFTval1(3).*ones(1,band_sizes(3)) FFTval2(4).*ones(1,band_sizes(4)) FFTval1(5).*ones(1,band_sizes(5)) FFTval2(6).*ones(1,band_sizes(6)) FFTval1(7).*ones(1,band_sizes(7)) FFTval2(8).*ones(1,band_sizes(8)-1) FFTval2(9) FFTval2(8).*ones(1,band_sizes(8)-1) FFTval1(7).*ones(1,band_sizes(7)) FFTval2(6).*ones(1,band_sizes(6)) FFTval1(5).*ones(1,band_sizes(5)) FFTval2(4).*ones(1,band_sizes(4)) FFTval1(3).*ones(1,band_sizes(3)) FFTval2(2).*ones(1,band_sizes(2)) FFTval1(1).*ones(1,band_sizes(1)-1) zeros(1,44)];
%     FFT_data_imag = [FFT_data_imag FFTval1(10) FFTval1(1).*ones(1,band_sizes(1)-1) FFTval2(2).*ones(1,band_sizes(2)) FFTval1(3).*ones(1,band_sizes(3)) FFTval2(4).*ones(1,band_sizes(4)) FFTval1(5).*ones(1,band_sizes(5)) FFTval2(6).*ones(1,band_sizes(6)) FFTval1(7).*ones(1,band_sizes(7)) FFTval2(8).*ones(1,band_sizes(8)-1) FFTval2(9) FFTval2(8).*ones(1,band_sizes(8)-1) FFTval1(7).*ones(1,band_sizes(7)) FFTval2(6).*ones(1,band_sizes(6)) FFTval1(5).*ones(1,band_sizes(5)) FFTval2(4).*ones(1,band_sizes(4)) FFTval1(3).*ones(1,band_sizes(3)) FFTval2(2).*ones(1,band_sizes(2)) FFTval1(1).*ones(1,band_sizes(1)-1) zeros(1,44)];    
% end
% 
% % Declare Signal for Individual Band during each time step
% Lst1 = [55.*ones(1,input_length/3) 90.*ones(1,input_length/3) 55.*ones(1,input_length/3)];
% Lst2 = [90.*ones(1,input_length/3) 55.*ones(1,input_length/3) 90.*ones(1,input_length/3)];
% 
% % Find length of input signal
% inlength = length(FFT_data_real);
% 
% % Calculate Valid Signal
% valid_data = zeros(size(FFT_data_real));
% valid_data(find(FFT_data_real)) = 1;
% 
% % Declare Bin Number Signal
% bin_num = [];
% for i = 1:(inlength/300)
%    bin_num = [bin_num 0:1:255 zeros(1,44)];
% end
% 
% % Calculate Band Number Signal
% for i = 1:inlength
%     band_num(i) = band_state_controller(bin_num(i), band_edges, num_bins, FFTsize, valid_data(i));
% end
% 
% % Calculate Accumulator Reset Signal
% accumulator_reset = [];
% for i = 1:(inlength/300)
%     accumulator_reset = [accumulator_reset 1 logical(diff(band_num(1:300)))];
% end
% 
%% Simulation Input Signals (Random Input Signal Test Case)

% Declare FFT Data Input Signal

% Signal Length Multiplier
input_length = 6;

% Organizing FFT Data Input Vectors
i = 1;
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
