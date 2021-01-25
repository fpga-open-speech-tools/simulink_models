% mp = sm_stop_verify(mp)
%
% Matlab function that verifies the model output 

% Inputs:
%   mp, which is the model data structure that holds the model parameters
%
% Outputs:
%   mp, the model data structure that now contains the left/right channel
%   data, which is in the following format:
%          mp.left_data_out         - The processed left channel data
%          mp.left_time_out         - time of left channel data
%          mp.right_data_out        - The processed right channel data
%          mp.right_time_out        - time of right channel data
%
% Copyright 2019 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Connor Dack
% Audio Logic
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

%% Plot the Input to the FFT and the Output to the FFT
close all;

data_input_left  = testSignal.audio(:,1);
data_input_right = testSignal.audio(:,2);
sim_out          = double(squeeze(data_out.data));
left_channel     = sim_out(143:end,1);
right_channel    = sim_out(:,2);

figure
plot(data_input_left)
hold on
plot(left_channel)
legend('Input', 'Output')
title('FFT Validation - Left Channel')

figure
plot(data_input_right)
hold on
plot(right_channel)
legend('Input', 'Output')
title('FFT Validation - Right Channel')

% fft_matlab = abs(fft(data_input_left));
% sim_out    = double(squeeze(fft_out.data));
% left_channel = abs(sim_out(:,1));
% figure
% plot(fft_matlab)
% hold on
% plot(left_channel);