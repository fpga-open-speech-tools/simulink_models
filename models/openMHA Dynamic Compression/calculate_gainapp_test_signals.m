% Matthew Blunt
% openMHA Gain Application Controller Input Signal Calculation Script for
% Subsystem Verification
% 12/14/20

%% Load Original Signals
load('gainapp_original_signals.mat');

%% Declare Parameters
system_delay = 70;
accumulator_delay = 64;
band_sizes = [2;1;2;1;5;11;43;64];
    
%% Calculate New Test Signals

% Now creating new signals w/ appropriate delay adjustments
gain_signal = [zeros(1,system_delay - accumulator_delay)];
grab_accumulator_signal = [zeros(1,system_delay - accumulator_delay)];
FFT_data_signal = [zeros(1,system_delay + 1)];
adjusted_gain_signal = [zeros(1,system_delay + 1)];

% Adjusting new signals to mirror associated band_number
for i = 1:4
    FFT_data_signal = [FFT_data_signal complex(1,1).*ones(1,band_sizes(1)) complex(2,2).*ones(1,band_sizes(2)) complex(3,3).*ones(1,band_sizes(3)) complex(4,4).*ones(1,band_sizes(4)) complex(5,5).*ones(1,band_sizes(5)) complex(6,6).*ones(1,band_sizes(6)) complex(7,7).*ones(1,band_sizes(7)) complex(8,8).*ones(1,band_sizes(8)) complex(8,8).*ones(1,band_sizes(8)-1) complex(7,7).*ones(1,band_sizes(7)) complex(6,6).*ones(1,band_sizes(6)) complex(5,5).*ones(1,band_sizes(5)) complex(4,4).*ones(1,band_sizes(4)) complex(3,3).*ones(1,band_sizes(3)) complex(2,2).*ones(1,band_sizes(2)) complex(1,1).*ones(1,band_sizes(1)-1) zeros(1,44)];
    adjusted_gain_signal = [adjusted_gain_signal 1.*ones(1,band_sizes(1)) 2.*ones(1,band_sizes(2)) 3.*ones(1,band_sizes(3)) 4.*ones(1,band_sizes(4)) 5.*ones(1,band_sizes(5)) 6.*ones(1,band_sizes(6)) 7.*ones(1,band_sizes(7)) 8.*ones(1,band_sizes(8)) 8.*ones(1,band_sizes(8)-1) 7.*ones(1,band_sizes(7)) 6.*ones(1,band_sizes(6)) 5.*ones(1,band_sizes(5)) 4.*ones(1,band_sizes(4)) 3.*ones(1,band_sizes(3)) 2.*ones(1,band_sizes(2)) 1.*ones(1,band_sizes(1)-1) ones(1,44)];
    gain_signal = [gain_signal 1.*ones(1,band_sizes(2)) 2.*ones(1,band_sizes(3)) 3.*ones(1,band_sizes(4)) 4.*ones(1,band_sizes(5)) 5.*ones(1,band_sizes(6)) 6.*ones(1,band_sizes(7)) 7.*ones(1,band_sizes(8)-1) 8.*ones(1,174)];
end

% Band Number and Grab Accumulator signals are good, but repetitive. 
% We only need to show that the Controller works for multiple rounds of 
% FFT data and produces accurate results on time.
band_num = band_num(1,1:length(gain_signal));
band_num_signal = band_num;
grab_accumulator = grab_accumulator(1:length(gain_signal));
grab_accumulator_signal = grab_accumulator;
% 
% % Similarly, we will cut all original signal sizes for comparison
gain = gain(1,1:length(gain_signal));
FFT_data = FFT_data(1,1:length(FFT_data_signal));
adjusted_gain = adjusted_gain(1,1:length(adjusted_gain_signal));

%% Comparing Signals to Validate Structure

% gain_check = isequal(logical(diff(gain(7:end))),logical(diff(gain_signal(7:end))));
% FFT_data_check = isequal(logical(diff(FFT_data)),logical(diff(real(FFT_data_signal))));
% adjusted_gain_check = isequal(logical(diff(adjusted_gain(72:end))),logical(diff(adjusted_gain_signal(72:end))));
