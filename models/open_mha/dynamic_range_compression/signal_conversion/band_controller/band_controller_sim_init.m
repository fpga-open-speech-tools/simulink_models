% The following script is designed as an init script for the Frequency Band
% State Controller Simulink model. It sets the parameters for both the 
% Simulink model and the comparison MATLAB computation. In addition, it 
% provides the test signals for the Simulink Model.
%
% Copyright 2020 Audio Logic
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

% openMHA Dynamic Compression Simulink Model Code
% Frequency Band State Controller Test/Verification Simulation Init Script
% 11/18/2020
%% Initialization
load fft_simulation.mat

%% Open MHA Parameters
audio_fs  = 48e3;
fs        = 128 * audio_fs;
FFTsize   = 256;
num_bins  = FFTsize/2 + 1;
freq      = linspace(0,24000,129);
binwidth  = (audio_fs/2)/(FFTsize/2);

stop_time = fft_valid_sim.Time(end);
%% Declare Freq Band Information
num_bands = 8;
ef = [0 250 500 750 1000 2000 4000 12000 24000];

% Calculate Freq Band State Controller Parameters
band_sizes = calculate_band_sizes(ef, num_bins, binwidth, num_bands);
band_edges = calculate_band_edges(ef, num_bins, binwidth, num_bands);
mirrored_band_edges = calculate_mirrored_band_edges(band_sizes, FFTsize, num_bins, num_bands);
band_edges = [band_edges mirrored_band_edges];