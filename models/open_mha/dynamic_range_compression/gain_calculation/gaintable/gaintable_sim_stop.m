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
gain_addr_low_matlab  = zeros(sim_length,1);
gain_addr_high_matlab = zeros(sim_length,1);
frac_matlab           = zeros(sim_length,1);
gain_low_matlab       = zeros(sim_length,1);
gain_high_matlab      = zeros(sim_length,1);
gain_matlab           = zeros(sim_length,1);

%% Calculate Gain Table Results
index_array = gtmin:gtstep:X_high+gtstep;
for i = 1:sim_length
    temp = data_in_array(i);
    if(temp >= X_high)
        temp = X_high;
    end
    band_number_calc = mod(i,8)+1;
    for j = 1:table_length
        if((temp >= index_array(j)) && (temp < index_array(j+1)))
            gain_addr_low_matlab(i)  = ((band_number_calc -1) * table_length) + j;
            gain_addr_high_matlab(i) = ((band_number_calc -1) * table_length) + j + 1;
            frac_matlab(i)           = (temp - index_array(j))/3;
            gain_low_matlab(i)       = vy(gain_addr_low_matlab(i));
            gain_high_matlab(i)      = vy(gain_addr_high_matlab(i));
            gain_matlab(i)           = linear_interpolation_source(gain_high_matlab(i), gain_low_matlab(i), frac_matlab(i));
            break
        end
    end
end

%% Plot Results
if debug == true
    figure
    subplot(6,1,1)
    plot(gain_addr_low_matlab)
    hold on
    plot(gain_addr_low_sim_out,'--')
    legend('MATLAB','Simulink')
    title('Gain Address - Low: Simulation')

    subplot(6,1,2)
    plot(gain_addr_high_matlab)
    hold on
    plot(gain_addr_high_sim_out,'--')
    legend('MATLAB','Simulink')
    title('Gain Address - High: Simulation')

    subplot(6,1,3)
    plot(frac_matlab)
    hold on
    plot(frac_sim_out,'--')
    legend('MATLAB','Simulink')
    title('Prelook Up Table - Fractional Simulation')

    subplot(6,1,4)
    plot(gain_low_matlab)
    hold on
    plot(gain_low_sim_out,'--')
    legend('MATLAB','Simulink')
    title('Gain Low Simulation')

    subplot(6,1,5)
    plot(gain_high_matlab)
    hold on
    plot(gain_high_sim_out,'--')
    legend('MATLAB','Simulink')
    title('Gain High Simulation')

    sim_out(:,1,1) = gain_sim_out(1,1,:);
    subplot(6,1,6)
    plot(gain_matlab)
    hold on
    plot(sim_out,'--')
    legend('MATLAB','Simulink')
    title('Gain Result Simulation')
else
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