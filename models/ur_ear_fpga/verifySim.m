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
% close all;

data_input = testSignal.audio(:,1);
total_stim = length(data_input);
rep_time   = total_stim * tdres;

debug_flag = 0;

if(debug_flag == 0)
    % Disable the Debug Outputs
    mex 'validation\model_IHC_BEZ2018.c' 'validation\complex.c'                             % Compile the UR EAR IHC BEZ2018 Model
    anm_source_out = model_IHC_BEZ2018(data_input', cf, 1, tdres, rep_time, cohc, cihc, 2); % Simulate the Auditory Nerve Model

    % Plot the Results
    figure
    subplot(2,1,1)
    plot(data_input)
    title(['Audio Input: Sampling Freq: ' num2str(Fs) ' Hz'])

    subplot(2,1,2)
    plot(anm_source_out)
    hold on
    plot(an_sim_out,'--')
    legend('C Source Code','Simulink')
    title(['UR EAR - Auditory Nerve Simulation: Char Freq = ' num2str(cf) ' Hz'])
    
elseif(debug_flag == 1)   
    % Enable the Intermediate Steps and Plotting
    mex 'validation\model_IHC_BEZ2018_debug.c' 'validation\complex.c' % Compile the UR EAR IHC BEZ2018 Debug Source
    [mef_source_out, rsigma_source_out, c1_chirp_source_out, c2_wbgt_source_out, c1_nl_source_out, c2_nl_source_out, ihc_source_out, anm_source_out] = model_IHC_BEZ2018_debug(data_input', cf, 1, tdres, rep_time, cohc, cihc, 2); % Simulate the Auditory Nerve Model

    % Plot the Results
    figure
    subplot(2,1,1)
    plot(data_input)
    title('Audio Input')

    subplot(2,1,2)
    plot(mef_source_out)
    hold on
    plot(mef_out_sim,'--')
    legend('C Source Code','Simulink')
    title('UR EAR - Middle Ear Filter Simulation')
    
    figure
    subplot(7,1,1)
    plot(rsigma_source_out)
    hold on
    plot(rsigma_sim_out,'--')
    legend('C Source Code','Simulink')
    title('UR EAR - R Sigma Simulation')

    subplot(7,1,2)
    plot(c1_chirp_source_out)
    hold on
    plot(c1_chirp_sim_out,'--')
    legend('C Source Code','Simulink')
    title('UR EAR - C1 Filter Simulation')

    subplot(7,1,3)
    plot(c2_wbgt_source_out)
    hold on
    plot(c2_wbgt_sim_out,'--')
    legend('C Source Code','Simulink')
    title('UR EAR - C2 Filter Simulation')
    
    subplot(7,1,4)
    plot(c1_nl_source_out)
    hold on
    plot(c1_nl_sim_out,'--')
    legend('C Source Code','Simulink')
    title('UR EAR - C1 NL Simulation')
    
    subplot(7,1,5)
    plot(c2_nl_source_out)
    hold on
    plot(c2_nl_sim_out,'--')
    legend('C Source Code','Simulink')
    title('UR EAR - C2 NL Simulation')
    
    subplot(7,1,6)
    plot(ihc_source_out)
    hold on
    plot(ihc_sim_out,'--')
    legend('C Source Code','Simulink')
    title('UR EAR - IHC Temp Simulation')
    
    subplot(7,1,7)
    plot(anm_source_out)
    hold on
    plot(an_sim_out,'--')
    legend('C Source Code','Simulink')
    title(['UR EAR - Auditory Nerve Simulation: Char Freq = ' num2str(cf) ' Hz'])
end

