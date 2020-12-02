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
% Intensity Test/Verification Simulation Stop Script
% 11/18/2020

%% NOTES

% The following script is designed to isolate and test the Intensity
% simulation results against expected results calculated via openMHA source
% code methods.

%% Calculate openMHA Results
level_in = zeros(inlength,1);

for i = 1:inlength
    level_in(i,1) = colored_intensity(FFT_data_real(i), FFT_data_imag(i), accumulator_reset(i), bin_num(i), FFTsize);
end
% *** openMHA Source File, Function Call: dc.cpp 
% *** openMHA Source File, Function Call Lines: 404 (colored_intensity) 
% *** openMHA Source File, Computation: mha_signal.cpp
% *** openMHA Source File, Computation Lines: 1937-1965 

%% Plot Results

% Note that the only relevant results are those that correspond to
% positive frequency bins. Thus, for an FFT size of 256, these are the
% first 129 bins after each valid_data signal high.

figure()
plot(level_in(1:FFTsize/2));
hold on;
plot(out.level_in(1:FFTsize/2),'--');
hold off;
legend('Expected Intensity Values','Simulink Intensity Values');
xlabel('Sample Number');
ylabel('Intensity Level [Pa^2]');
title('Sound Intensity Level: Actual vs. Expected Results');

figure()
plot(abs(level_in(1:FFTsize/2) - out.level_in(1:FFTsize/2)'));
xlabel('Sample Number');
ylabel('Intensity Level Difference[Pa^2]');
title('Difference Error Between openMHA and Simulink Intensity Levels');
