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
attack_buff_matlab           = zeros(audio_length,num_bands);
attack_filter_matlab         = zeros(audio_length,num_bands);
attack_filter_sim_matrix     = zeros(audio_length,num_bands);
attack_filter_opt_sim_matrix = zeros(audio_length,num_bands);

delay_buff_matlab           = zeros(audio_length,num_bands);
decay_filter_matlab         = zeros(audio_length,num_bands);
decay_filter_sim_matrix     = zeros(audio_length,num_bands);
decay_filter_opt_sim_matrix = zeros(audio_length,num_bands);

input_temp = zeros(audio_length,num_bands);

%% Calculate the Results
% Based on Line 282 from dc.cpp
for i = 1:1:audio_length
    for j = 1:1:num_bands
        if(i == 1) % Initial Condition
            attack_buff_matlab(i,j)   = buf_a(j,1);
            attack_filter_matlab(i,j) = o1_ar_filter_source(data_input_matrix(i,j), attack_c1_a_array(j,1), attack_c2_a_array(j,1), attack_c1_r_array(j,1), attack_c2_r_array(j,1), attack_buff_matlab(i,j));
            
            delay_buff_matlab(i,j)    = buf_d(j,1);
            decay_filter_matlab(i,j)  = o1_ar_filter_source(attack_filter_matlab(i,j), decay_c1_a_array(j,1), decay_c2_a_array(j,1), decay_c1_r_array(j,1), decay_c2_r_array(j,1), delay_buff_matlab(i,j));
        else
            attack_buff_matlab(i,j)   = attack_filter_matlab(i-1,j);
            attack_filter_matlab(i,j) = o1_ar_filter_source(data_input_matrix(i,j), attack_c1_a_array(j,1), attack_c2_a_array(j,1), attack_c1_r_array(j,1), attack_c2_r_array(j,1), attack_buff_matlab(i,j));
            
            delay_buff_matlab(i,j)    = decay_filter_matlab(i-1,j);
            decay_filter_matlab(i,j)  = o1_ar_filter_source(attack_filter_matlab(i,j), decay_c1_a_array(j,1), decay_c2_a_array(j,1), decay_c1_r_array(j,1), decay_c2_r_array(j,1), delay_buff_matlab(i,j));
        end
    end
end

%% Parse the Simulink Results
for i = 1:audio_length
    for j = 1:num_bands
        attack_filter_sim_matrix(i,j)     = attack_filter_sim(((i-1)*num_bands) + j,1);
        attack_filter_opt_sim_matrix(i,j) = attack_filter_opt_sim(((i-1)*num_bands) + j,1);
        
        decay_filter_sim_matrix(i,j)  = decay_filter_sim(((i-1)*num_bands) + j,1);
        decay_filter_opt_sim_matrix(i,j) = decay_filter_opt_sim(((i-1)*num_bands) + j,1);
        
        input_temp(i,j) = data_input_array(((i-1)*num_bands) + j,1);
    end    
end

%% Plot the Results
for j = 1:num_bands
    figure
    subplot(3,1,1)
    plot(data_input_matrix(:,j))
    hold on
    plot(input_temp(:,j),'--')
    legend('Input: Matrix', 'Input Array')
    title(['Input  - Band Number: ' num2str(j)])
    
    subplot(3,1,2)
    plot(attack_filter_matlab(:,j))
    hold on
    plot(attack_filter_sim_matrix(:,j),'--')
    hold on
    plot(attack_filter_opt_sim_matrix(:,j),'.')
    legend('MATLAB Code','Simulink','Simulink Optimization')
    title(['Attack Filter Simulation - Band Number: ' num2str(j)])


    subplot(3,1,3)
    plot(decay_filter_matlab(:,j))
    hold on
    plot(decay_filter_sim_matrix(:,j),'--')
    hold on
    plot(decay_filter_opt_sim_matrix(:,j),'.')
    legend('MATLAB Code','Simulink','Simulink Optimization')
    title(['Decay Filter Simulation - Band Number: ' num2str(j)])
end