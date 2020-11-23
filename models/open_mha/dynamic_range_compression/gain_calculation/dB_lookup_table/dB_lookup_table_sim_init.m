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
% dB Lookup Table Test/Verification Simulation Init Script
% 11/18/2020

clear all;
close all;

%% NOTES

% The following script is designed as an init script for the dB Lookup
% Table Simulink model. It sets the parameters for both the 
% Simulink model and the comparison MATLAB computation. In addition, it 
% provides the test signals for the Simulink Model.


%% Declare Sampling Rate

fs = 48000;

%% Declare Simulation Input Signals

% Data Input Signal (Input Level level_in)
% Designed to simulate all possible input intensity levels
% from 0 dB to 96 dB
dB_level_in = linspace(0,96,20000);
% Converting input signal from units of dBSPL to Pascal-squared
[level_in,FFTval] = dB2lin(dB_level_in,1);

% load('level_in.mat');

%% Declare Stop Time

stop_time = (length(level_in) - 1)/fs;
