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

bin_intensity(1:inlength) = FFT_data_real(1:inlength).^2 + FFT_data_imag(1:inlength).^2;
for i = 1:inlength
    level_in(i) = accumulate_band(bin_intensity(i), accumulator_reset(i), bin_num(i), num_bins);
end
% *** openMHA Source File, Function Call: dc.cpp 
% *** openMHA Source File, Function Call Lines: 404 (colored_intensity) 
% *** openMHA Source File, Computation: mha_signal.cpp
% *** openMHA Source File, Computation Lines: 1937-1965 

%% Compare Results


%% Plot Results