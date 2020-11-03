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
mex calc_tau_source.c

data_input  = testSignal.audio(:,1);
c_grdelay = zeros(1,length(data_input));
c_rsigma = zeros(1,length(data_input));
c_tauc1 = zeros(1,length(data_input));
c_tauwb = zeros(1,length(data_input));
c_wbgain = zeros(1,length(data_input));

for i = 1:length(data_input)
    [c_grdelay(1,i), c_rsigma(1,i), c_tauc1(1,i), c_tauwb(1,i), c_wbgain(1,i)] = calc_tau_source(tdres, cf, centerfreq, data_input(i));
end

figure
subplot(6,1,1)
plot(data_input)
legend('tmptauc1 Input Wave')
title('Audio Input')

sim_out = mp.dataOut;
subplot(6,1,2)
plot(c_grdelay)
hold on
plot(grdelay,'--')
legend('C Source Code','Simulink')
title('grdelay C Source Code vs Simulink Output')

subplot(6,1,3)
plot(c_rsigma)
hold on
plot(rsigma,'--')
legend('C Source Code','Simulink')
title('rsigma C Source Code vs Simulink Output')

subplot(6,1,4)
plot(c_tauc1)
hold on
plot(tauc1,'--')
legend('C Source Code','Simulink')
title('tauc1 C Source Code vs Simulink Output')


subplot(6,1,5)
plot(c_tauwb)
hold on
plot(tauwb,'--')
legend('C Source Code','Simulink')
title('tauwb C Source Code vs Simulink Output')

subplot(6,1,6)
plot(c_wbgain)
hold on
plot(wbgain,'--')
legend('C Source Code','Simulink')
title('wbgain C Source Code vs Simulink Output')
