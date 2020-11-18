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
% Copyright 2020 AudioLogic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Tyler Davis
% AudioLogic, Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

%% 
close all;

data_input = testSignal.audio(:,1);

[counts, valid] = integrateCounts(integrationTime,spcountRedock1_prev,spcountRedock2_prev,spcountRedock3_prev,spcountRedock4_prev);

figure
subplot(2,1,1)
hold on
plot(data_input)
plot(Avalon_Sink_Data.Data(:,1),'--')
hold off;
legend('Input data','Output data')
title('Audio Input')

sim_out = mp.dataOut;
subplot(2,1,2)
plot(sim_out)
hold on
plot(sim_out,'--')
legend('MATLAB Function','Simulink')
title('MATLAB Source vs Simulink Output')

figure
subplot(2,1,1)
hold on
plot(counts)
plot(squeeze(countTotal.Data(2:end)),'--')
hold off
legend('MATLAB Function','Simulink')
title('MATLAB Source vs Simulink Output')

subplot(2,1,2)
hold on
plot(valid)
plot(squeeze(countValid.Data(2:end)),'--')
hold off
legend('MATLAB Function','Simulink')
title('MATLAB Source vs Simulink Output')


validCounts_mlab = counts(boolean(valid));
validCounts_sim  = countTotal.Data(boolean(countValid.Data));

[validCounts_mlab(1:10) validCounts_sim(1:10)];






