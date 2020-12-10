% dynamic_range_compression_init.m  
%
% Copyright 2020 AudioLogic, Inc
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Matthew Blunt, Connor Dack
% AudioLogic, Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

%% Calculate the Results

%% Plot the Results
if debug == true
    figure;
    subplot(3,1,1)
    plot(drc_gain_sim_out)
    legend('Simulink')
    title('DRC Gain Simulation')
    
    subplot(3,1,2)
    plot(modified_FFT_data_real)
    legend('Simulink')
    title('FFT Data: Real')

    subplot(3,1,2)
    plot(modified_FFT_data_imag)
    legend('Simulink')
    title('FFT Data: Imaginary')
    
else
    figure;
    subplot(4,1,1)
    plot(modified_FFT_data_real)
    legend('Simulink')
    title('FFT Data: Real')

    subplot(4,1,2)
    plot(modified_FFT_data_imag)
    legend('Simulink')
    title('FFT Data: Imaginary')
    
    subplot(4,1,3)
    plot(fft_valid_sim_out)
    legend('Simulink')
    title('FFT Valid Simulation')
    
    subplot(4,1,4)
    plot(fft_frame_pulse_sim_out)
    legend('Simulink')
    title('FFT Frame Pulse Simulation')
end