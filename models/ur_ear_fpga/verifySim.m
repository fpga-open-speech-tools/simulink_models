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

data_input = testSignal.audio(:,1);
total_stim = length(data_input);
rep_time   = total_stim * tdres;

debug_flag = 0;

if(debug_flag == 0)
    % Debug Flag == 0 
    mex 'validation\model_IHC_BEZ2018.c' 'validation\complex.c'                             % Compile the UR EAR IHC BEZ2018 Model
    anm_source_out = model_IHC_BEZ2018(data_input', cf, 1, tdres, rep_time, cohc, cihc, 2); % Simulate the Auditory Nerve Model

    % Plot the Results
    figure
    subplot(2,1,1)
    plot(data_input)
    title('Audio Input')

    subplot(2,1,2)
    plot(anm_source_out(1,93:end))
    hold on
    plot(an_sim_out,'--')
    legend('C Source Code','Simulink')
    title('UR EAR - Auditory Nerve Simulation')
    
elseif(debug_flag == 1)   
    % Debug Flag == 1 
    mex 'validation\model_IHC_BEZ2018_debug.c' 'validation\complex.c' % Compile the UR EAR IHC BEZ2018 Model
    [mef_source_out, rsigma_source_out, c1_chirp_source_out, c2_wbgt_source_out, anm_source_out] = model_IHC_BEZ2018_debug(data_input', cf, 1, tdres, rep_time, cohc, cihc, 2); % Simulate the Auditory Nerve Model

    % Plot the Results
    figure
    subplot(6,1,1)
    plot(data_input)
    title('Audio Input')

    subplot(6,1,2)
    plot(mef_source_out)
    hold on
    plot(mef_out_sim,'--')
    legend('C Source Code','Simulink')
    title('UR EAR - Middle Ear Filter Simulation')

    subplot(6,1,3)
    plot(rsigma_source_out)
    hold on
    plot(rsigma_sim_out,'--')
    legend('C Source Code','Simulink')
    title('UR EAR - R Sigma Simulation')

    subplot(6,1,4)
    plot(c1_chirp_source_out)
    hold on
    plot(c1_chirp_sim_out,'--')
    legend('C Source Code','Simulink')
    title('UR EAR - C1 Filter Simulation')

    subplot(6,1,5)
    plot(c2_wbgt_source_out)
    hold on
    plot(c2_wbgt_sim_out,'--')
    legend('C Source Code','Simulink')
    title('UR EAR - C2 Filter Simulation')

    subplot(6,1,6)
    plot(anm_source_out(1,93:end))
    hold on
    plot(an_sim_out,'--')
    legend('C Source Code','Simulink')
    title('UR EAR - Auditory Nerve Simulation')
end

