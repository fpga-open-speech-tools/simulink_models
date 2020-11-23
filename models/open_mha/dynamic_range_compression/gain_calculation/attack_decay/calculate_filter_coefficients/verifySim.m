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
total_stim         = length(band_num_input);
addr_attack_matlab = zeros(total_stim,1);
addr_decay_matlab  = zeros(total_stim,1);
c1_a_matlab        = zeros(total_stim,1);
c2_a_matlab        = zeros(total_stim,1);
c1_d_matlab        = zeros(total_stim,1);
c2_d_matlab        = zeros(total_stim,1);

%% Calculate the Results
for i = 1:1:total_stim
    addr_attack_matlab(i,1) = (band_num_input(i) - 1) * num_coeff;
    addr_decay_matlab(i,1)  = ((band_num_input(i) - 1) * num_coeff) + 1;
    c1_a_matlab(i,1)        = ad_coeffs(addr_attack_matlab(i,1) + 1);  % Account for MATLAB Array Indexing starting at 1
    c2_a_matlab(i,1)        = 1 - c1_a_matlab(i,1);
    c1_d_matlab(i,1)        = ad_coeffs(addr_decay_matlab(i,1) + 1);   % Account for MATLAB Array Indexing starting at 1
    c2_d_matlab(i,1)        = 1 - c1_d_matlab(i,1);
end

%% Plot the Results
figure
subplot(7,1,1)
plot(band_num_input)
hold on
plot(Avalon_Sink_Data)

subplot(7,1,2)
plot(addr_attack_matlab)
hold on
plot(addr_attack_sim_out,'--')
legend('MATLAB Code','Simulink')
title('Attack Address Simulation')

subplot(7,1,3)
plot(addr_decay_matlab)
hold on
plot(addr_decay_sim_out,'--')
legend('MATLAB Code','Simulink')
title('Decay Address Simulation')

subplot(7,1,4)
plot(c1_a_matlab)
hold on
plot(c1_a_sim_out,'--')
legend('MATLAB Code','Simulink')
title('C1 Attack Cofficient Read Simulation')

subplot(7,1,5)
plot(c2_a_matlab)
hold on
plot(c2_a_sim_out,'--')
legend('MATLAB Code','Simulink')
title('C2 Attack Cofficient Read Simulation')

subplot(7,1,6)
plot(c1_d_matlab)
hold on
plot(c1_d_sim_out,'--')
legend('MATLAB Code','Simulink')
title('C1 Decay Cofficient Read Simulation')

subplot(7,1,7)
plot(c2_d_matlab)
hold on
plot(c2_d_sim_out,'--')
legend('MATLAB Code','Simulink')
title('C2 Decay Cofficient Read Simulation')