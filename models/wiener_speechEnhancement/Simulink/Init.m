% sm_callback_init
%
% This scripts initializes the model variables and parameters. The script 
% runs before the simulation starts.  This is called in the InitFcn callback 
% found in Model Explorer.
%
% Copyright 2019 Flat Earth Inc
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Ross K. Snider
% Justin P. Williams
% Flat Earth Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com
clc; clear all; close all;

%% Model Parameter Initialization
% Load Audio File
windowSize = 0.5e-3;
[cleanAudio, Fs] = audioread('sp03.wav');
% Fs = 16 kHz, resample to 48 kHz
cleanAudio = resample(cleanAudio, 3*Fs, Fs);
Fs = 3*Fs;
% Add noise
stddev = 0.1/6; % this makes it so the noise is approximately between [-0.05, 0.05]
noise = randn(size(cleanAudio))*stddev;
noisyAudio = cleanAudio + noise;
Ts = 1/Fs;
t = 0 : Ts : Ts * length(noisyAudio);
t = t(1:length(t)-1)';
stopTime = t(length(t));
winSize = round(windowSize / Ts);
win     = zeros(winSize, 1);

%% Constant Inputs
mean_denom = 1 / length(winSize); 
% Used for finding the mean and not have 
        % more than necessary divides in our model
noise_std = stddev;
% For the purposes of this model, the noise will have static standard dev

%% Avalon Inputs
% Load Audio Signal
Sink_Data = [t, noisyAudio];

% Sink_Channel
Sink_Channel = ones(length(Sink_Data), 1);
Left_Win     = win;
Right_Win    = win;
Avalon_Sink_Valid = ones(length(Sink_Data), 1);


