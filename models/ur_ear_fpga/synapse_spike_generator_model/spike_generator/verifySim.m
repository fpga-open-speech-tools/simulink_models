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

%% 
close all;

% Call SpikeGenerator to generate the matlab output
mex spikegen_source.c complex.c
mex spikegen_pseudorandom.c complex.c

data_input = testSignal.audio(:,1);

totalstim = length(data_input);

sptimeVect = zeros(1,length(data_input));
spCountVect = zeros(1,length(data_input));
trd_vectorVect = zeros(1,length(data_input));
randNums = rand(1,length(data_input));
    

% Define some parameters
total_mean_rate = sum(data_input/length(data_input));
MaxArraySizeSpikes = length(data_input)*nrep;

syn_out = 2e5*data_input';

% [sptime_mattt, spCount_matt, trd_vector_matt] = SpikeGenerator_matt(data_input, double(zz), tdres, t_rd_rest, t_rd_init, tau, t_rd_jump, nSites, tabs, trel, elapsed_time, unitRateInterval, oneSiteRedock);
% [spCount_sim, sptime_sim, trd_vector_sim] = spikegen_source(synout, tdres, t_rd_rest, t_rd_init, tau, t_rd_jump, nSites, tabs, trel, spont, totalstim, nrep, total_mean_rate, MaxArraySizeSpikes, sptime, trd_vector);
[spCount_source, sptime_source, trd_vector_source, sp_count_redock_1, sp_count_redock_2, sp_count_redock_3, sp_count_redock_4] = spikegen_pseudorandom(...
    syn_out, randNums, tdres, t_rd_rest, t_rd_init, tau, t_rd_jump, nSites, tabs, trel, spont, totalstim, nrep, total_mean_rate, MaxArraySizeSpikes, double(unitRateInterval), double(oneSiteRedock));                                                              
                                                                
[counts, valid] = integrateCounts(integrationTime,sp_count_redock_1,sp_count_redock_2,sp_count_redock_3,sp_count_redock_4);


%%

figure
% subplot(221)
% hold on
% plot(sptime_source)
% plot(sptime,'--')
% hold off
% legend('C Source Code','Simulink')
% title('C Source Code vs Simulink Output')

% subplot(111)
hold on
plot(trd_vector_source)
plot(trd_vector,'--')
hold off
legend('C Source','Intern code','Simulink')
title('C Source Code vs Simulink Output')
% end
% 
% subplot(223)
% hold on
% plot(spCount_source)
% plot(spCount,'--')
% hold off
% legend('C Source Code','Simulink')
% title('C Source Code vs Simulink Output')


figure
subplot(2,1,1)
plot(data_input)
legend('IHC Lowpass Filter Result')
title('Audio Input')

sim_out = mp.dataOut;
subplot(2,1,2)
plot([ 0 1 ], [0 0])
hold on
plot(sim_out,'--')
legend('C Source Code','Simulink')
title('C Source Code vs Simulink Output')



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

% %--Accumulator Results---
% figure
% subplot(2,1,1)
% plot(counts)
% hold on
% plot(spike_count_sim_out,'--')
% legend('MATLAB Function','Simulink')
% title('Accumulator: Counts')
% 
% subplot(2,1,2)
% plot(valid)
% hold on
% plot(spike_valid_sim_out(2:end),'--')
% legend('MATLAB Function','Simulink')
% title('Accumulator: Valid')





























