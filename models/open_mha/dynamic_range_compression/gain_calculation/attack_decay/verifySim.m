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
% Coefficient Arrays
addr_attack_matlab   = zeros(total_stim,1);
addr_decay_matlab    = zeros(total_stim,1);
c1_a_matlab          = zeros(total_stim,1);
c2_a_matlab          = zeros(total_stim,1);
c1_d_matlab          = zeros(total_stim,1);
c2_d_matlab          = zeros(total_stim,1);
% Attack and Decay Reults
attack_filter_matlab = zeros(total_stim,1);
decay_filter_matlab  = zeros(total_stim,1);


%% Calculate the Results
decay_attack_tau  = 0;
[decay_c1_a, decay_c2_a] = o1_lp_coeffs(decay_attack_tau,fs);

for i = 1:1:total_stim
    addr_attack_matlab(i,1) = (band_num_input(i) - 1) * num_coeff;
    addr_decay_matlab(i,1)  = ((band_num_input(i) - 1) * num_coeff) + 1;
    c1_a_matlab(i,1)        = ad_coeffs(addr_attack_matlab(i,1) + 1);  % Account for MATLAB Array Indexing starting at 1
    c2_a_matlab(i,1)        = 1 - c1_a_matlab(i,1);
    c1_d_matlab(i,1)        = ad_coeffs(addr_decay_matlab(i,1) + 1);   % Account for MATLAB Array Indexing starting at 1
    c2_d_matlab(i,1)        = 1 - c1_d_matlab(i,1);
    if(i <= 8) % Initial Condition
        attack_filter_matlab(i,1) = o1_ar_filter(data_input(i,1), c1_a_matlab(i,1), c2_a_matlab(i,1), c1_a_matlab(i,1), c2_a_matlab(i,1), buf_a(i,1));
        decay_filter_matlab(i,1)  = o1_ar_filter(attack_filter_matlab(i,1), decay_c1_a, decay_c2_a, c1_d_matlab(i,1),  c2_d_matlab(i,1), buf_d(i,1));
    else
        attack_filter_matlab(i,1) = o1_ar_filter(data_input(i,1), c1_a_matlab(i,1), c2_a_matlab(i,1), c1_a_matlab(i,1), c2_a_matlab(i,1), attack_filter_matlab(i-num_bands,1));
        decay_filter_matlab(i,1)  = o1_ar_filter(attack_filter_matlab(i,1), decay_c1_a, decay_c2_a, c1_d_matlab(i,1),  c2_d_matlab(i,1), decay_filter_matlab(i-num_bands,1));
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

figure
subplot(6,1,1)
plot(addr_attack_matlab)
hold on
plot(addr_attack_sim_out(1:end-1),'--')
legend('MATLAB Code','Simulink')
title('Attack Address Simulation')

subplot(6,1,2)
plot(addr_decay_matlab)
hold on
plot(addr_decay_sim_out(1:end-1),'--')
legend('MATLAB Code','Simulink')
title('Decay Address Simulation')

subplot(6,1,3)
plot(c1_a_matlab)
hold on
plot(c1_a_sim_out(2:end),'--')
legend('MATLAB Code','Simulink')
title('C1 Attack Cofficient Read Simulation')

subplot(6,1,4)
plot(c2_a_matlab)
hold on
plot(c2_a_sim_out(2:end),'--')
legend('MATLAB Code','Simulink')
title('C2 Attack Cofficient Read Simulation')

subplot(6,1,5)
plot(c1_d_matlab)
hold on
plot(c1_d_sim_out(2:end),'--')
legend('MATLAB Code','Simulink')
title('C1 Decay Cofficient Read Simulation')

subplot(6,1,6)
plot(c2_d_matlab)
hold on
plot(c2_d_sim_out(2:end),'--')
legend('MATLAB Code','Simulink')
title('C2 Decay Cofficient Read Simulation')