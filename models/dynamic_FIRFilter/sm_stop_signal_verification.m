% Signal_verification
%
% This script evaluates the outputs of the data from the Simulink PFIR
% model. 
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

close all; clc;     % DON'T CLEAR VARIABLES
%% Pull Avalon Data Out
channel = Avalon_Sink_Channel.data(:);
data    = Avalon_Sink_Data.data(:);
error   = Avalon_Sink_Error.data(:);
valid   = Avalon_Sink_Valid.data(:);

%% Separate Avalon Data to Respective Channels
%  Interpret the data output of the model with its respective channels.
%  Verify the processing is correct on each channel

% Left Channel
lChan   = find(channel == 1);
lData   = data(lChan);

% Right Channel
rChan   = find(channel==0);
rData   = data(rChan);

% Convert to Doubles for Plots
lDataDouble = double(lData);
rDataDouble = double(rData); 
%% Plot Signal Data
    % Plot Spectrograms of the Outputs
    figure(1) % Left  Channel
    spectrogram(lDataDouble,8192,7800,8192,mp.Fs, 'yaxis');
    title('Left Channel -> Processed');
    % Limit the frequency axis to relevant range
%     axis([80 600 0 0.1]);
    
    
    figure(2) % Right Channel 
    spectrogram(rDataDouble,8192,7800,8192,mp.Fs, 'yaxis');
    title('Right Channel -> Processed');
    % Limit the frequency axis to relevant range
%     axis([80 200 0 0.15]);

