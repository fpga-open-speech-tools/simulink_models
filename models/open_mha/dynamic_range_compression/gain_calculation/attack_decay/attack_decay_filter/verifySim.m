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
% Copyright 2020 AudioLogic, Inc
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
attack_buff_matlab       = zeros(audio_length,num_bands);
attack_buff_sim_matrix   = zeros(audio_length,num_bands);
attack_filter_matlab     = zeros(audio_length,num_bands);
attack_filter_sim_matrix = zeros(audio_length,num_bands);

delay_buff_matlab        = zeros(audio_length,num_bands);
delay_buff_sim_matrix    = zeros(audio_length,num_bands);
decay_filter_matlab      = zeros(audio_length,num_bands);
delay_filter_sim_matrix  = zeros(audio_length,num_bands);

%% Calculate the Results
% Based on Line 282 from dc.cpp
for i = 1:1:audio_length
    for j = 1:1:num_bands
        if(i == 1) % Initial Condition
            attack_buff_matlab(i,j)   = buf_a(j,1);
            attack_filter_matlab(i,j) = o1_ar_filter(data_input_matrix(i,j), attack_c1_a_array(j,1), attack_c2_a_array(j,1), attack_c1_r_array(j,1), attack_c2_r_array(j,1), attack_buff_matlab(i,j));
            
            delay_buff_matlab(i,j)    = buf_d(j,1);
            decay_filter_matlab(i,j)  = o1_ar_filter(attack_filter_matlab(i,j), decay_c1_a_array(j,1), decay_c2_a_array(j,1), decay_c1_r_array(j,1), decay_c2_r_array(j,1), delay_buff_matlab(i,j));
        else
            attack_buff_matlab(i,j)   = attack_filter_matlab(i-1,j);
            attack_filter_matlab(i,j) = o1_ar_filter(data_input_matrix(i,j), attack_c1_a_array(j,1), attack_c2_a_array(j,1), attack_c1_r_array(j,1), attack_c2_r_array(j,1), attack_buff_matlab(i,j));
            
            delay_buff_matlab(i,j)    = decay_filter_matlab(i-1,j);
            decay_filter_matlab(i,j)  = o1_ar_filter(attack_filter_matlab(i,j), decay_c1_a_array(j,1), decay_c2_a_array(j,1), decay_c1_r_array(j,1), decay_c2_r_array(j,1), delay_buff_matlab(i,j));
        end
    end
end

%% Parse the Simulink Results
for i = 1:audio_length
    for j = 1:num_bands
        attack_buff_sim_matrix(i,j)   = attack_buff_sim(((i-1)*num_bands) + j,1);
        attack_filter_sim_matrix(i,j) = attack_filter_sim(((i-1)*num_bands) + j,1);
        
        delay_buff_sim_matrix(i,j)    = decay_buff_sim(((i-1)*num_bands) + j,1);
        delay_filter_sim_matrix(i,j)  = delay_filter_sim(((i-1)*num_bands) + j,1);
    end    
end

%% Plot the Results
if num_bands == 1
    figure
    plot(data_input(:,1))
    legend('Audio Input Wave')
    title(['Number of Bands = ' num2str(num_bands)])
    
    figure
    subplot(4,1,1)
    plot(attack_buff_matlab(:,1))
    hold on
    plot(attack_buff_sim_matrix(:,1),'--')
    legend('MATLAB Code','Simulink')
    title('Attack Buffer Simulation')
    
    subplot(4,1,2)
    plot(attack_filter_matlab(:,1))
    hold on
    plot(attack_filter_sim_matrix(:,1),'--')
    legend('MATLAB Code','Simulink')
    title('Attack Filter Simulation')
    
    subplot(4,1,3)
    plot(delay_buff_matlab(:,1))
    hold on
    plot(delay_buff_sim_matrix(:,1),'--')
    legend('MATLAB Code','Simulink')
    title('Decay Buffer Simulation')

    subplot(4,1,4)
    plot(decay_filter_matlab(:,1))
    hold on
    plot(delay_filter_sim_matrix(:,1),'--')
    legend('MATLAB Code','Simulink')
    title('Decay Filter Simulation')
elseif num_bands == 2
    figure
    plot(data_input(:,1))
    legend('Audio Input Wave')
    title(['Number of Bands = ' num2str(num_bands)])
    
    figure
    subplot(4,1,1)
    plot(attack_buff_matlab(:,1))
    hold on
    plot(attack_buff_sim_matrix(:,1),'--')
    legend('MATLAB Code','Simulink')
    title('Attack Buffer Simulation - Band 1')
    
    subplot(4,1,2)
    plot(attack_filter_matlab(:,1))
    hold on
    plot(attack_filter_sim_matrix(:,1),'--')
    legend('MATLAB Code','Simulink')
    title('Attack Filter Simulation - Band 1')
    
    subplot(4,1,3)
    plot(delay_buff_matlab(:,1))
    hold on
    plot(delay_buff_sim_matrix(:,1),'--')
    legend('MATLAB Code','Simulink')
    title('Decay Buffer Simulation - Band 1')

    subplot(4,1,4)
    plot(decay_filter_matlab(:,1))
    hold on
    plot(delay_filter_sim_matrix(:,1),'--')
    legend('MATLAB Code','Simulink')
    title('Decay Filter Simulation - Band 1')
        
    figure
    subplot(4,1,1)
    plot(attack_buff_matlab(:,2))
    hold on
    plot(attack_buff_sim_matrix(:,2),'--')
    legend('MATLAB Code','Simulink')
    title('Attack Buffer Simulation - Band 2')
    
    subplot(4,1,2)
    plot(attack_filter_matlab(:,2))
    hold on
    plot(attack_filter_sim_matrix(:,2),'--')
    legend('MATLAB Code','Simulink')
    title('Attack Filter Simulation - Band 2')
    
    subplot(4,1,3)
    plot(delay_buff_matlab(:,2))
    hold on
    plot(delay_buff_sim_matrix(:,2),'--')
    legend('MATLAB Code','Simulink')
    title('Decay Buffer Simulation - Band 2')

    subplot(4,1,4)
    plot(decay_filter_matlab(:,2))
    hold on
    plot(delay_filter_sim_matrix(:,2),'--')
    legend('MATLAB Code','Simulink')
    title('Decay Filter Simulation - Band 2')
elseif num_bands == 8
    figure
    subplot(5,1,1)
    plot(data_input(:,1))
    legend('Audio Input Wave')
    title(['Number of Bands = ' num2str(num_bands)])

    subplot(5,1,2)
    plot(attack_filter_matlab(:,1))
    hold on
    plot(attack_filter_sim_matrix(:,1),'--')
    legend('MATLAB Code','Simulink')
    title('Attack Filter Simulation - Band 1')

    subplot(5,1,3)
    plot(decay_filter_matlab(:,1))
    hold on
    plot(delay_filter_sim_matrix(:,1),'--')
    legend('MATLAB Code','Simulink')
    title('Decay Filter Simulation - Band 1')
    
    subplot(5,1,4)
    plot(attack_filter_matlab(:,8))
    hold on
    plot(attack_filter_sim_matrix(:,8),'--')
    legend('MATLAB Code','Simulink')
    title('Attack Filter Simulation - Band 8')

    subplot(5,1,5)
    plot(decay_filter_matlab(:,8))
    hold on
    plot(delay_filter_sim_matrix(:,8),'--')
    legend('MATLAB Code','Simulink')
    title('Decay Filter Simulation - Band 8')
else
    msg = [num2str(num_bands) ' Bands not supported for plotting'];
    f = warndlg(msg,'Warning'); 
end