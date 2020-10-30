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

middle_ear_filter_out = testSignal.audio(:,1);
totalstim             = length(middle_ear_filter_out);
c1_chirp_filter       = zeros(1,totalstim);
c2_wideband_filter    = zeros(1,totalstim);
inner_hair_cell_out   = zeros(1,totalstim);

%% C1 Chirp Filter
mex C1ChirpFilt.c complex.c
for i = 1:totalstim
    c1_chirp_filter(1,i) = C1ChirpFilt(middle_ear_filter_out(i), tdres, cf, i-1, taumax, rsigma);
end

%% C2 Wideband Filter
mex C2ChirpFilt.c complex.c
for i = 1:totalstim
    c2_wideband_filter(1,i) = C2ChirpFilt(middle_ear_filter_out(i), tdres, cf, i-1, taumaxc2, fcohcc2);
end

%% Inner Hair Cell
mex inner_hair_cell_source.c complex.c
for i = 1:totalstim
    inner_hair_cell_out(1,i) = inner_hair_cell_source(c1_chirp_filter(i), slope_c1, ihcasym_c1, c2_wideband_filter(i), slope_c2, ihcasym_c2, tdres, Fcihc, i-1, gainihc, orderihc);
end

%% Complete Auditory Nerve
% mex auditory_nerve_source.c complex.c
% for i = 1:totalstim
%     inner_hair_cell_out(1,i) = auditory_nerve_source(middle_ear_filter_out(i), tdres, cf, i-1, taumax, rsigma, taumaxc2, fcohcc2, slope_c1, ihcasym_c1, slope_c2, ihcasym_c2, Fcihc, gainihc, orderihc);
% end

%% Synapse
pla_nl_out = NLBeforePLA(inner_hair_cell_out, totalstim, spont, cf);
syn_out    = PowerLaw(pla_nl_out, totalstim, randNums, Fs);

%% Plot the Results
figure
subplot(2,1,1)
plot(middle_ear_filter_out)
legend('Middle Ear Filter Result Wave')
title('Audio Input')

sim_out = mp.dataOut;
subplot(2,1,2)
plot(syn_out)
hold on
plot(sim_out,'--')
legend('C Source Code','Simulink')
title('C Source Code vs Simulink Output')
