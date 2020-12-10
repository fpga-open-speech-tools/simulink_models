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

band_num_matlab    = zeros(audio_length * num_bands, 1);
addr_attack_matlab = zeros(audio_length * num_bands, 1);
addr_decay_matlab  = zeros(audio_length * num_bands, 1);

c1_a_matlab_combined = zeros(audio_length * num_bands, 1);
c2_a_matlab_combined = zeros(audio_length * num_bands, 1);
c1_d_matlab_combined = zeros(audio_length * num_bands, 1);
c2_d_matlab_combined = zeros(audio_length * num_bands, 1);
% C1 and C2 Coefficients
c1_a_matlab          = fi(zeros(audio_length,num_bands), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);
c1_a_simulink        = fi(zeros(audio_length,num_bands), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);
c2_a_matlab          = fi(zeros(audio_length,num_bands), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);
c2_a_simulink        = fi(zeros(audio_length,num_bands), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);
c1_d_matlab          = fi(zeros(audio_length,num_bands), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);
c1_d_simulink        = fi(zeros(audio_length,num_bands), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);
c2_d_matlab          = fi(zeros(audio_length,num_bands), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);
c2_d_simulink        = fi(zeros(audio_length,num_bands), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);
% Attack Filter Results
attack_buff_matlab           = zeros(audio_length,num_bands);
attack_filter_matlab         = zeros(audio_length,num_bands);
attack_filter_sim_matrix     = zeros(audio_length,num_bands);
attack_filter_opt_sim_matrix = zeros(audio_length,num_bands);
%Decay Filter Results
delay_buff_matlab           = zeros(audio_length,num_bands);
decay_filter_matlab         = zeros(audio_length,num_bands);
decay_filter_sim_matrix     = zeros(audio_length,num_bands);
decay_filter_opt_sim_matrix = zeros(audio_length,num_bands);

input_temp = zeros(audio_length,num_bands);

%% Calculate the Results
% Based on Line 282 from dc.cpp
for i = 1:1:audio_length
    for j = 1:1:num_bands    
        band_num_matlab(((i-1)*num_bands) + j,1)      = j;
        addr_attack_matlab(((i-1)*num_bands) + j,1)   = (j - 1) * num_coeff;
        addr_decay_matlab(((i-1)*num_bands) + j,1)    = ((j - 1) * num_coeff) + 1;
        
        % Coefficient Matrices
        c1_a_matlab(i,j) = attack_c1_a_array(j,1);
        c2_a_matlab(i,j) = attack_c2_a_array(j,1);
        c1_d_matlab(i,j) = decay_c1_r_array(j,1);
        c2_d_matlab(i,j) = decay_c2_r_array(j,1);
        if(i == 1) % Initial Condition
            attack_buff_matlab(i,j)   = buf_a(j,1);
            attack_filter_matlab(i,j) = o1_ar_filter_source(data_input_matrix(i,j), c1_a_matlab(i,j), c2_a_matlab(i,j), c1_a_matlab(i,j), c2_a_matlab(i,j), attack_buff_matlab(i,j));
            
            delay_buff_matlab(i,j)    = buf_d(j,1);
            decay_filter_matlab(i,j)  = o1_ar_filter_source(attack_filter_matlab(i,j), 0, 1, c1_d_matlab(i,j), c2_d_matlab(i,j), delay_buff_matlab(i,j));
        else
            attack_buff_matlab(i,j)   = attack_filter_matlab(i-1,j);
            attack_filter_matlab(i,j) = o1_ar_filter_source(data_input_matrix(i,j), c1_a_matlab(i,j), c2_a_matlab(i,j), c1_a_matlab(i,j), c2_a_matlab(i,j), attack_buff_matlab(i,j));
            
            delay_buff_matlab(i,j)    = decay_filter_matlab(i-1,j);
            decay_filter_matlab(i,j)  = o1_ar_filter_source(attack_filter_matlab(i,j), 0, 1, c1_d_matlab(i,j), c2_d_matlab(i,j), delay_buff_matlab(i,j));
        end
    end
end

%% Debug Results
if debug == true
    for i = 1:audio_length-1
        for j = 1:num_bands
            input_temp(i,j) = data_input_array(((i-1)*num_bands) + j + 1,1);

            c1_a_matlab_combined(((i-1)*num_bands) + j + 1,1) = attack_c1_a_array(j,1);
            c2_a_matlab_combined(((i-1)*num_bands) + j + 1,1) = attack_c2_a_array(j,1);
            c1_d_matlab_combined(((i-1)*num_bands) + j + 1,1) = decay_c1_r_array(j,1);
            c2_d_matlab_combined(((i-1)*num_bands) + j + 1,1) = decay_c2_r_array(j,1);

            %DP-RAM Coefficients
            c1_a_simulink(i,j) = c1_a_sim_out(((i-1)*num_bands) + j + 1,1);
            c2_a_simulink(i,j) = c2_a_sim_out(((i-1)*num_bands) + j + 1,1);
            c1_d_simulink(i,j) = c1_d_sim_out(((i-1)*num_bands) + j + 1,1);
            c2_d_simulink(i,j) = c2_d_sim_out(((i-1)*num_bands) + j + 1,1);

            % Attack and Decay Filter
            attack_filter_opt_sim_matrix(i,j) = attack_filter_sim(((i-1)*num_bands) + j,1);
            decay_filter_opt_sim_matrix(i,j) = decay_filter_sim(((i-1)*num_bands) + j,1);
        end    
    end

    temp = round(stim_length/2);

    figure
    subplot(3,1,1)
    plot(band_num_matlab)
    hold on
    plot(band_num_sim_out,'--')
    legend('MATLAB', 'Simulink')
    title('Band Number Simulation')

    subplot(3,1,2)
    plot(addr_attack_matlab)
    hold on
    plot(addr_attack_sim_out,'--')
    legend('MATLAB Code','Simulink')
    title('Attack Address Simulation')

    subplot(3,1,3)
    plot(addr_decay_matlab)
    hold on
    plot(addr_decay_sim_out,'--')
    legend('MATLAB Code','Simulink')
    title('Decay Address Simulation')

    figure
    subplot(4,1,1)
    plot(c1_a_matlab_combined)
    hold on
    plot(c1_a_sim_out,'--')
    legend('MATLAB Code','Simulink')
    title('C1 Attack - Interleafed Simulation')

    subplot(4,1,2)
    plot(c2_a_matlab_combined)
    hold on
    plot(c2_a_sim_out,'--')
    legend('MATLAB Code','Simulink')
    title('C2 Attack - Interleafed Simulation')

    subplot(4,1,3)
    plot(c1_d_matlab_combined)
    hold on
    plot(c1_d_sim_out,'--')
    legend('MATLAB Code','Simulink')
    title('C1 Decay - Interleafed Simulation')

    subplot(4,1,4)
    plot(c2_d_matlab_combined)
    hold on
    plot(c2_d_sim_out,'--')
    legend('MATLAB Code','Simulink')
    title('C2 Decay - Interleafed Simulation')

    for j = 1:num_bands
        figure
        subplot(7,1,1)
        plot(data_input_matrix(:,j))
        hold on
        plot(input_temp(:,j),'--')
        legend('Input: Matrix', 'Input Array')
        title(['Input  - Band Number: ' num2str(j)])

        subplot(7,1,2)
        plot(c1_a_matlab(1:end-1,j))
        hold on
        plot(c1_a_simulink(1:end-1,j),'--')
        legend('MATLAB Code','Simulink')
        title(['C1 A Simulation - Band Number: ' num2str(j)])

        subplot(7,1,3)
        plot(c2_a_matlab(1:end-1,j))
        hold on
        plot(c2_a_simulink(1:end-1,j),'--')
        legend('MATLAB Code','Simulink')
        title(['C2 A Simulation - Band Number: ' num2str(j)])

        subplot(7,1,4)
        plot(c1_d_matlab(1:end-1,j))
        hold on
        plot(c1_d_simulink(1:end-1,j),'--')
        legend('MATLAB Code','Simulink')
        title(['C1 D Simulation - Band Number: ' num2str(j)])

        subplot(7,1,5)
        plot(c2_d_matlab(1:end-1,j))
        hold on
        plot(c2_d_simulink(1:end-1,j),'--')
        legend('MATLAB Code','Simulink')
        title(['C2 D Simulation - Band Number: ' num2str(j)])

        subplot(7,1,6)
        plot(attack_filter_matlab(1:end-1,j))
        hold on
        plot(attack_filter_opt_sim_matrix(1:end-1,j),'--')
        hold on
        legend('MATLAB Code','Simulink')
        title(['Attack Filter Simulation - Band Number: ' num2str(j)])

        subplot(7,1,7)
        plot(decay_filter_matlab(1:end-1,j))
        hold on
        plot(decay_filter_opt_sim_matrix(1:end-1,j),'--')
        legend('MATLAB Code','Simulink')
        title(['Decay Filter Simulation - Band Number: ' num2str(j)])
    end
else
    figure
    subplot(3,1,1)
    plot(band_number_sim_out)
    legend('Simulink')
    title('Band Number Simulation')  
    
    subplot(3,1,2)
    plot(grab_accumulator_sim_out)
    legend('Simulink')
    title('Grab Accumulator Trigger Simulation')  
    
    level_dB_plot(:,1,1) = avalon_source_data(1,1,:);
    subplot(3,1,3)
    plot(level_dB_plot)
    legend('Simulink')
    title('Level dB Filtered Simulation')  
end