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

%% Initialization
close all;
mex inner_hair_cell_source.c complex.c

c1_chirp_filter     = testSignal.audio(:,1);
c2_wideband_filter  = testSignal2.audio(:,1);
c1_nl_source_out    = zeros(1,length(c1_chirp_filter));
c2_nl_source_out    = zeros(1,length(c1_chirp_filter));
inner_hair_cell_out = zeros(1,length(c1_chirp_filter));

%% Validate the Model with Mex

for i = 1:length(c1_chirp_filter)
    [c1_nl_source_out(1,i), c2_nl_source_out(1,i), inner_hair_cell_out(1,i)] = inner_hair_cell_source(c1_chirp_filter(i), slope_c1, ihcasym_c1, c2_wideband_filter(i), slope_c2, ihcasym_c2, tdres, Fc_ihc, i-1, gain_ihc, order_ihc);
end

%% Plot the Results
figure
subplot(4,1,1)
plot(c1_chirp_filter)
hold on
plot(c2_wideband_filter)
legend('C1 Chirp Filter Wave','C2 Wideband Filter Wave')
title('Audio Input')

subplot(4,1,2)
plot(c1_nl_source_out)
hold on
plot(c1_nl_sim_out, '--')
legend('C Source Code','Simulink')
title('Audio Input')

subplot(4,1,3)
plot(c2_nl_source_out)
hold on
plot(c2_nl_sim_out, '--')
legend('C Source Code','Simulink')
title('Audio Input')

sim_out = mp.dataOut;
subplot(4,1,4)
plot(inner_hair_cell_out)
hold on
plot(sim_out,'--')
legend('C Source Code','Simulink')
title('C Source Code vs Simulink Output')
