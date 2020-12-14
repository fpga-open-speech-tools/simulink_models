% Copyright 2020 Audio Logic
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

%% Initialzie
close all;
sim_length = length(data_in_array);
band_number_calc      = zeros(sim_length,1);
plt_index_matlab      = zeros(sim_length,1);
gain_addr_low_matlab  = zeros(sim_length,1);
gain_addr_high_matlab = zeros(sim_length,1);
frac_matlab           = zeros(sim_length,1);
gain_low_matlab       = zeros(sim_length,1);
gain_high_matlab      = zeros(sim_length,1);
gain_matlab           = zeros(sim_length,1);

%% Calculate Gain Table Results
% index_array = 0:dB_step:100;
k = 0;
for i = 1:sim_length
    temp = data_in_array(i);
    if(temp >= X_high)
        temp = X_high;
    end
    band_number_calc(i) = mod(k,8)+1;
    for j = 1:prelookup_table_size
        if((temp >= input_levels_db(j)) && (temp < input_levels_db(j+1)))
            plt_index_matlab(i)      = j - 1; % Account for MATLAB Indexing with 1 and Simulink with 0
            frac_matlab(i)           = mod(double(temp),dB_step)/dB_step;
            gain_addr_low_matlab(i)  = ((band_number_calc(i) - 1) * prelookup_table_size) + plt_index_matlab(i);
            gain_addr_high_matlab(i) = ((band_number_calc(i) - 1) * prelookup_table_size) + plt_index_matlab(i) + 1;
            gain_low_matlab(i)       = vy(gain_addr_low_matlab(i)  + 1);
            gain_high_matlab(i)      = vy(gain_addr_high_matlab(i) + 1);
            gain_matlab(i)           = linear_interpolation_source(gain_high_matlab(i), gain_low_matlab(i), frac_matlab(i));
            break
        end
    end
    k = k + 1;
end

%% Plot Results
if debug == true
    figure
    subplot(2,1,1)
    plot(data_in.Data)
    title('Simulation Data In')
    
    subplot(2,1,2)
    plot(band_number_calc)
    hold on
    plot(gt_band_number_sim_out,'--')
    legend('MATLAB','Simulink')
    title('Band Number')
    
    figure
    subplot(2,1,1)
    plot(plt_index_matlab)
    hold on
    plot(prelookup_table_index_sim,'--')
    legend('MATLAB','Simulink')
    title('Pre-Lookup Table Index: Simulation')
    
    subplot(2,1,2)
    plot(frac_matlab)
    hold on
    plot(frac_sim_out,'--')
    legend('MATLAB','Simulink')
    title('Prelook Up Table - Fractional: Simulation')
    
    subplot(7,1,3)
    plot(gain_addr_low_matlab)
    hold on
    plot(gain_addr_low_sim_out,'--')
    legend('MATLAB','Simulink')
    title('Gain Address - Low: Simulation')

    subplot(7,1,4)
    plot(gain_addr_high_matlab)
    hold on
    plot(gain_addr_high_sim_out,'--')
    legend('MATLAB','Simulink')
    title('Gain Address - High: Simulation')

    subplot(7,1,5)
    plot(gain_low_matlab)
    hold on
    plot(gain_low_sim_out,'--')
    legend('MATLAB','Simulink')
    title('Gain Low: Simulation')

    subplot(7,1,6)
    plot(gain_high_matlab)
    hold on
    plot(gain_high_sim_out,'--')
    legend('MATLAB','Simulink')
    title('Gain High: Simulation')

    sim_out(:,1,1) = gain_sim_out(1,1,:);
    subplot(7,1,7)
    plot(gain_matlab)
    hold on
    plot(sim_out,'--')
    legend('MATLAB','Simulink')
    title('Gain Result: Simulation')
else
   figure;
   plot(data_in.Data)
   
   figure;
   gain_sim_plot(:,1,1) = gain_sim_out(1,1,:);
   subplot(3,1,1)
   plot(gain_sim_plot)
   legend('Simulink')
   title('Gain Simulation')
   
   subplot(3,1,2)
   plot(band_number_sim_out)
   legend('Simulink')
   title('Band Number Simulation')
   
   subplot(3,1,3)
   plot(grab_accumulator_sim_out)
   legend('Simulink')
   title('Grab Accumulator Simulation')
end