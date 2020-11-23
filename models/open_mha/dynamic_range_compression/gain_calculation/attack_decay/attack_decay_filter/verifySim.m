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
attack_filter_matlab = zeros(total_stim,1);
decay_filter_matlab  = zeros(total_stim,1);

for i =1:1:total_stim
    % Based on Line 282 from dc.cpp
    if(i == 1) % Initial Condition
        attack_filter_matlab(i,1) = o1_ar_filter(data_input(i,1), attack_c1_a, attack_c2_a, attack_c1_r, attack_c2_r, buf_a);
        decay_filter_matlab(i,1)  = o1_ar_filter(attack_filter_matlab(i,1), decay_c1_a, decay_c2_a, decay_c1_r, decay_c2_r, buf_d);
    else
        attack_filter_matlab(i,1) = o1_ar_filter(data_input(i,1), attack_c1_a, attack_c2_a, attack_c1_r, attack_c2_r, attack_filter_matlab(i-1,1));
        decay_filter_matlab(i,1)  = o1_ar_filter(attack_filter_matlab(i,1), decay_c1_a, decay_c2_a, decay_c1_r, decay_c2_r, decay_filter_matlab(i-1,1));
    end
end

%% Plot the Results
figure
subplot(3,1,1)
plot(data_input)
legend("Audio Input Wave")
title("Audio Input")

subplot(3,1,2)
plot(attack_filter_matlab)
hold on
plot(attack_filter_sim,'--')
legend('MATLAB Code','Simulink')
title('Attack Filter Simulation')

subplot(3,1,3)
plot(decay_filter_matlab)
hold on
plot(delay_filter_sim,'--')
legend('MATLAB Code','Simulink')
title('Decay Filter Simulation')