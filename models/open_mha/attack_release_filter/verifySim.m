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

%% Verify that the test data got encoded, passed through the model, and
% decoded correctly.  The input (modified by gain) and output values should be identical.

close all;
data_input    = testSignal.audio(:,1);
totalstim     = length(data_input);
ar_filter_out = zeros(1,totalstim);
%% MHA Lowpass Fitler
% mha_filter.hh - Line 200-203

for i = 1:totalstim
    if(i == 1)
        ar_filter_out(1,i) = (c1_a * 65) + (c2_a * data_input(i));
    else
        if(data_input(i) > ar_filter_out(1,i-1))
            ar_filter_out(1,i) = (c1_a * ar_filter_out(1,i-1)) + (c2_a * data_input(i));
        else
            ar_filter_out(1,i) = (c1_r * ar_filter_out(1,i-1)) + (c2_r * data_input(i));
        end
    end
end

%% Plot the Results
figure
subplot(2,1,1)
plot(data_input)
title('Audio Input')
legend('input')

sim_out = mp.dataOut;
subplot(2,1,2)
plot(ar_filter_out)
hold on
plot(sim_out,'--')
legend('MATLAB Function','Simulink')
title('MATLAB vs Simulink Output')