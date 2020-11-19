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
% AudioLogic, Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

%% Initialize
close all;

mex 'spike_generator\spikegen_pseudorandom.c' complex.c
mex 'spike_generator\spikegen_source.c' complex.c
data_input = testSignal.audio(:,1);
totalstim  = length(data_input);

%% Random Parameters from Spike Gen Validation 
% Need to investigate
total_mean_rate = sum(data_input/length(data_input));
MaxArraySizeSpikes = length(data_input)*nrep;

%% Compute the Results
pla_nl_out = NLBeforePLA(data_input, totalstim, spont, cf);
syn_out    = PowerLaw(pla_nl_out, totalstim, randNums, Fs);

[spCount_source, sptime_source, trd_vector_source, sp_count_redock_1, sp_count_redock_2, sp_count_redock_3, sp_count_redock_4] = spikegen_source( ...
    syn_out, tdres, t_rd_rest, t_rd_init, tau, t_rd_jump, nSites, tabs, trel, spont, totalstim, nrep, total_mean_rate, MaxArraySizeSpikes);


% [spCount_source, sptime_source, trd_vector_source, sp_count_redock_1, sp_count_redock_2, sp_count_redock_3, sp_count_redock_4] = spikegen_pseudorandom(...
%     syn_out, randNumsSpikeGen, tdres, t_rd_rest, t_rd_init, tau, t_rd_jump, nSites, tabs, trel, spont, totalstim, nrep, total_mean_rate, MaxArraySizeSpikes, double(unitRateInterval), double(oneSiteRedock));

  
  
[counts, valid] = integrateCounts(integrationTime,sp_count_redock_1,sp_count_redock_2,sp_count_redock_3,sp_count_redock_4);

%% Plot the Results
%--Input and Synapse Results---
figure
subplot(3,1,1)
plot(data_input)
legend('Inner Hair Cell Output Wave')
title('Audio Input')

subplot(3,1,2)
plot(pla_nl_out)
hold on
plot(nl_pla_sim_out, '--')
legend('MATLAB Function','Simulink')
title('Non-linear PLA Filter Simulation')

subplot(3,1,3)
plot(syn_out)
hold on
plot(syn_sim_out,'--')
legend('MATLAB Function','Simulink')
title('PLA Simulation')

%--Spike Gen Results---
figure
subplot(4,1,1)
plot(sp_count_redock_1)
hold on
plot(sp_count_redock_1_sim,'--')
legend('C Source','Simulink')
title('Spike Count: Redock Site 1')

subplot(4,1,2)
plot(sp_count_redock_2)
hold on
plot(sp_count_redock_2_sim,'--')
legend('C Source','Simulink')
title('Spike Count: Redock Site 2')

subplot(4,1,3)
plot(sp_count_redock_3)
hold on
plot(sp_count_redock_3_sim,'--')
legend('C Source','Simulink')
title('Spike Count: Redock Site 3')

subplot(4,1,4)
plot(sp_count_redock_4)
hold on
plot(sp_count_redock_4_sim,'--')
legend('C Source','Simulink')
title('Spike Count: Redock Site 4')

%--Accumulator Results---
figure
subplot(2,1,1)
plot(counts)
hold on
plot(spike_count_sim_out,'--')
legend('MATLAB Function','Simulink')
title('Accumulator: Counts')

subplot(2,1,2)
plot(valid)
hold on
plot(spike_valid_sim_out(2:end),'--')
legend('MATLAB Function','Simulink')
title('Accumulator: Valid')