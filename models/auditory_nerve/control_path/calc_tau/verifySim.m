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

% data_input  = testSignal.audio(:,1);
% c_grdelay = zeros(1,length(data_input));
% c_rsigma = zeros(1,length(data_input));
% c_tauc1 = zeros(1,length(data_input));
% c_tauwb = zeros(1,length(data_input));
% c_wbgain = zeros(1,length(data_input));
%  c_wbgain_actual = zeros(1,length(data_input));
%  tmpgain = zeros(1,length(data_input));
% m_grdelay = zeros(1,length(data_input));
% m_tmpcos = zeros(1,length(data_input));
% m_wbgain_actual = zeros(1,length(data_input));
% 
% for i = 1:length(data_input)
%     [c_grdelay(1,i), c_rsigma(1,i), c_tauc1(1,i), c_tauwb(1,i), c_wbgain(1,i)] = calc_tau_source(tdres, cf, centerfreq, data_input(i));
% end

figure
subplot(7,1,1)
plot(data_input)
legend('tmptauc1 Input Wave')
title('Audio Input')

lasttmpgain = wbgain_i;

% for i = 1:length(data_input)
%     grd = int32(c_grdelay(i));
%     if((grd+i) < length(data_input))
%         tmpgain(grd+i) = c_wbgain(i);
%     end
%     if(tmpgain(i) == 0)
%         tmpgain(i) = lasttmpgain;
%     end
%     c_wbgain_actual(i) = tmpgain(i);
%     lasttmpgain = c_wbgain_actual(i);
% end

subplot(7,1,2)
plot(c_grdelay)
hold on
plot(grdelay,'--')
grdelay_error = abs(grdelay(1:end-1) - c_grdelay.');
plot(grdelay_error)
legend('C Source Code','Simulink', 'error')
title('grdelay C Source Code vs Simulink Output')

subplot(7,1,3)
plot(c_wbgain)
hold on
plot(s_wbgain,'--')
hold on
wbgain_error = abs(s_wbgain(1:end-1) - c_wbgain.');
plot(wbgain_error)
legend('Matlab','Simulink', 'error')
title('wbgain before delay C Source Code vs Simulink Output')


subplot(7,1,4)


% plot(c_rsigma)
% hold on
% plot(s_rsigma,'--')
% legend('C Source Code','Simulink')
% title('rsigma C Source Code vs Simulink Output')

subplot(7,1,5)
plot(c_tauc1)
hold on
plot(tauc1,'--')
tauc1_error = abs(tauc1(1:end-1) - c_tauc1.');
plot(tauc1_error)
legend('C Source Code','Simulink', 'error')
title('tauc1 C Source Code vs Simulink Output')

subplot(7,1,6)
plot(c_tauwb)
hold on
plot(tauwb,'--')
tauwb_error = abs(tauwb(1:end-1) - c_tauwb.');
plot(tauwb_error)
legend('C Source Code','Simulink', 'error')
title('tauwb C Source Code vs Simulink Output')

subplot(7,1,7)
plot(c_wbgain_actual)
hold on
plot(wbgain,'--')
hold on
wbgain_actual_error = abs(wbgain(1:end-2) - c_wbgain_actual.');
plot(wbgain_actual_error)
legend('C Source Code','Simulink', 'error')
title('wbgain C Source Code vs Simulink Output')
