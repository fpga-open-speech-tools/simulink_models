% verify_sim.m
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

%% Calculate the Results



%% Plot the Results
if debug
    % Frequency Band Controller Simulation
    figure()
    subplot(3,1,1)
    plot(bin_num_sim_out)
    title("Bin Number Simulation")

    subplot(3,1,2)
    plot(band_num_sim_out);
    ylabel('Frequency Band Number');
    title('Band Number Simulation');

    subplot(3,1,3)
    plot(fft_valid_sim.Data)
    hold on
    plot(valid_sim_out, '--')
    legend('Input', 'Simulink')
    title("Valid Signal Simulation")
    
    % Intensity and dB ConversionSimulation
    figure
    subplot(4,1,1)
    plot(grab_accumulator_sim_out)
    title("Grab Accumulator Trigger Simulation")
    
    subplot(4,1,2)
    plot(band_num_sim_out)
    title("Band Number Simulation")

    subplot(4,1,3)
    plot(level_sim_out)
    title("Level Simulation")
    
    subplot(4,1,4)
    plot(level_dB_sim_out)
    title("Level dB Simulation")
else
    figure;
    subplot(3,1,1)
    plot(level_dB_sim)
    title('Level dB Conversion Simulation')

    subplot(3,1,2)
    plot(grab_accumulator_sim)
    title('Accumulator Trigger Simulation')

    subplot(3,1,3)
    plot(band_number_sim)
    title('Band Number Simulation')
end