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

%% Compute the C Source Output
close all;

load rsigma.mat                                          % Load Rsigma
mex 'c1_chirp_filter\C1ChirpFilt.c' complex.c            % Compile C1 Filter Source
mex 'c2_wideband_filter\C2ChirpFilt.c' complex.c         % Compile C2 Filter Source
mex 'inner_hair_cell\inner_hair_cell_source.c' complex.c % Compile the IHC Source

% Initialize Data Arrays
data_input          = testSignal.audio(:,1);
rsigma_plot         = zeros(1,length(data_input));
c1_chirp_out        = zeros(1,length(data_input));
c2_wbf_out          = zeros(1,length(data_input));
c1_nl_source_out    = zeros(1,totalstim);
c2_nl_source_out    = zeros(1,totalstim);
inner_hair_cell_out = zeros(1,length(data_input));

for i = 1:length(data_input)
    rsigma_plot(i)           = rsigma_sim_in.data(i);
    c1_chirp_out(1,i)        = C1ChirpFilt(data_input(i), tdres, cf, i-1, bmTaumax, rsigma_plot(i));
    c2_wbf_out(1,i)          = C2ChirpFilt(data_input(i), tdres, cf, i-1, bmTaumax, 1/ratiobm);
    [c1_nl_source_out(1,i), c2_nl_source_out(1,i), inner_hair_cell_out(1,i)] = inner_hair_cell_source(c1_chirp_filter(i), slope_c1, ihcasym_c1, c2_wideband_filter(i), slope_c2, ihcasym_c2, tdres, Fc_ihc, i-1, gain_ihc, order_ihc);
end

%% Plot the Results
figure
subplot(2,1,1)
plot(data_input)
legend('Middle Ear Filter Result')
title('Audio Input')

subplot(2,1,2)
plot(rsigma_plot)
legend('Rsigma')
title('R Sigma Input')

figure
subplot(5,1,1)
plot(c1_chirp_filter)
hold on
plot(c1_chirp_sim_out,'--')
legend('C Source Code','Simulink')
title('C1 Filter Simulation')

subplot(5,1,2)
plot(c2_wideband_filter)
hold on
plot(c2_scaled_sim_out,'--')
legend('C Source Code','Simulink')
title('C2 Filter Simulation')

subplot(5,1,3)
plot(c1_nl_source_out)
hold on
plot(c1_nl_sim_out, '--')
legend('C Source Code','Simulink')
title('C1 NL Simulation')

subplot(5,1,4)
plot(c2_nl_source_out)
hold on
plot(c2_nl_sim_out, '--')
legend('C Source Code','Simulink')
title('C2 NL Simulation')

sim_out = mp.dataOut;
subplot(5,1,5)
plot(inner_hair_cell_out)
hold on
plot(sim_out,'--')
legend('C Source Code','Simulink')
title('Filter Path Results')
