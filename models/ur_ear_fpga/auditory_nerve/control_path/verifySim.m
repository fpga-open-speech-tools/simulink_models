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

data_input      = testSignal.audio(:,1);
totalstim       = length(data_input);
wbout           = zeros(1,totalstim);
ohc_sim         = zeros(1,totalstim);
ohc_boltzman    = zeros(1,totalstim);
c_grdelay       = zeros(1,totalstim);
c_rsigma        = zeros(1,totalstim);
c_tauc1         = zeros(1,totalstim);
c_tauwb         = zeros(1,totalstim);
c_wbgain        = zeros(1,totalstim);
c_wbgain_actual = zeros(1,length(data_input));
tmpgain         = zeros(1,totalstim);

%% CP Wideband Gamatone Filter Simulation
mex 'cp_wideband_gammatone_filter\WbGammaTone.c' complex.c % Compile CP WB Gammatone Filter Source
mex 'outer_hair_cell\outer_hair_cell_source.c'             % Compile Outer Hair Cell Source
mex 'calc_tau\calc_tau_source.c'                           % Compile Calc Tau Source

lasttmpgain = wbgain_i;

for i = 1:length(data_input)
    if(i == 1)
        wbout(1,i) = WbGammaTone(data_input(i),tdres,centerfreq,i-1,tauwb_i,wbgain_i,wborder, TauWBMax, cf);
    else
        wbout(1,i) = WbGammaTone(data_input(i),tdres,centerfreq,i-1,c_tauwb(1,i-1),c_wbgain_actual(1,i-1),wborder, TauWBMax, cf);
    end
    ohc_sim(1,i) = outer_hair_cell_source(wbout(1,i), ohcasym, s0, s1, x1, tdres, Fcohc, i-1, gainohc, orderohc, bmTaumin, bmTaumax);
    [c_grdelay(1,i), c_rsigma(1,i), c_tauc1(1,i), c_tauwb(1,i), c_wbgain(1,i)] = calc_tau_source(tdres, cf, centerfreq, ohc_sim(1,i));
    grd = int32(c_grdelay(i));
    if((grd+i) < length(data_input))
        tmpgain(grd+i) = c_wbgain(i);
    end
    if(tmpgain(i) == 0)
        tmpgain(i) = lasttmpgain;
    end
    c_wbgain_actual(i) = tmpgain(i);
    lasttmpgain = c_wbgain_actual(i);
end

%% Plot the Results
figure
subplot(7,1,1)
plot(data_input)
legend('Middle Ear Filter Result Wave')
title('Audio Input')

sim_out = mp.dataOut;
subplot(7,1,2)
plot(c_rsigma)
hold on
plot(sim_out,'--')
legend('C Source Code','Simulink')
title('rsigma')

subplot(7,1,3)
plot(c_wbgain)
hold on
plot(s_wbgain,'--')
legend('C Source Code','Simulink')
title('wbgain')

subplot(7,1,4)
plot(c_tauwb)
hold on
plot(tauwb,'--')
legend('C Source Code','Simulink')
title('tauwb')

subplot(7,1,5)
plot(c_tauc1)
hold on
plot(tauc1,'--')
legend('C Source Code','Simulink')
title('tauc1')

subplot(7,1,6)
plot(wbout)
hold on
plot(s_wbout,'--')
legend('C Source Code','Simulink')
title('wbout')

subplot(7,1,7)
plot(c_wbgain_actual)
hold on
plot(wbgain,'--')
% hold on
% wbgain_actual_error = abs(wbgain(1:end-1) - c_wbgain_actual.');
% plot(wbgain_actual_error)
legend('C Source Code','Simulink', 'error')
title('wbgain C Source Code vs Simulink Output')
