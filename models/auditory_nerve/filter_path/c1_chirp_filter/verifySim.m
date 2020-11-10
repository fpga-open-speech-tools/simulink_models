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
%close all;
mex C1ChirpFilt.c complex.c
data_input   = testSignal.audio(:,1);
rsigma_plot  = zeros(1,length(data_input));
c1_chirp_out = zeros(1,length(data_input));

for i = 1:length(data_input)
    rsigma_plot(i) = rsigma_sim_in.data(i);
    c1_chirp_out(1,i) = C1ChirpFilt(data_input(i), tdres, cf, i-1, taumax, rsigma_plot(i));
end

%% Plot the Results
figure
subplot(3,1,1)
plot(data_input)
legend('Middle Ear Filter Result')
title('Audio Input')

subplot(3,1,2)
plot(rsigma_plot)
legend('Rsigma')
title('R Sigma Input')

sim_out = mp.dataOut;
subplot(3,1,3)
plot(c1_chirp_out)
hold on
plot(sim_out,'--')
legend('C Source Code','Simulink')
title('C1 Chirp Results')
