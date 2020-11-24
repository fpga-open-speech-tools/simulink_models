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

%% Initialization
close all;
data_input = testSignal.audio(:,1);
total_stim = length(data_input);

%% Calculate the Results
open_mha_drc_filter_sim = zeros(total_stim,1);

for i =1:1:total_stim
    open_mha_drc_filter_sim(i,1) = o1_ar_filter_source(data_input(i,1), c1_a_random_in, c2_a_random_in, c1_r_random_in, c2_r_random_in, buf_random_in);
end

%% Plot the Results
figure
subplot(2,1,1)
plot(data_input)
legend("Audio Input Wave")
title("Audio Input")

subplot(2,1,2)
plot(open_mha_drc_filter_sim)
hold on
plot(Avalon_Sink_Data,'--')
legend('MATLAB Code','Simulink')
title('Open MHA DRC Filter Simulation')