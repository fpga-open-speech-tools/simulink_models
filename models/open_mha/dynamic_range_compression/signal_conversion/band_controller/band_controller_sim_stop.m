% Copyright 2020 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Matthew Blunt
% Audio Logic
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

% openMHA Dynamic Compression Simulink Model Code
% Frequency Band State Controller Test/Verification Simulation Stop Script
% 11/18/2020

%% NOTES

% The following script is designed to isolate and test the Frequency Band
% State Controller simulation results against expected results calculated 
% via openMHA source code methods.


close all;
%% Calculate openMHA Results
% 
% % Code modified to match edge frequency syntax. Bands are simply split into
% % rectangular windows according to edge frequency vector ef for all
% % positive frequencies.
% j = 1;
% for i = 1:FFTsize/2+1
%     if (i-1)*binwidth <= ef(j+1)
%         band_num(i) = j;
%     else band_num(i) = j+1;
%         j = j+1;
%     end
% end
% % *** openMHA Source File, Function Call: fftfilterbank.cpp 
% % *** openMHA Source File, Function Call Lines: 173-188 
% % *** openMHA Source File, Computation: mha_fftfb.cpp
% % *** openMHA Source File, Computation Lines: 353-358 & 480-505 (for edge frequencies)

%% Plot Results
figure()
subplot(3,1,1)
plot(bin_num_out)
title("Bin Number Simulation")

subplot(3,1,2)
plot(band_num_out);
ylabel('Frequency Band Number');
title('Band Number Simulation');

subplot(3,1,3)
plot(fft_valid_sim.Data)
hold on
plot(valid_out, '--')
legend('Input', 'Simulink')
title("Valid Signal Simulation")
