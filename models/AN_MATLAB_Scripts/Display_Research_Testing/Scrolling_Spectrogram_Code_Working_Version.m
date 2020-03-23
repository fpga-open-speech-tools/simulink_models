%% Scrolling Spectrogram Code
% Hezekiah Austin
% Last Modification: 2020-02-11
% Parts to work on are marked with ???

%% Ojectives
% Create a MATLAB script which does the following
% Creates a test signal
% Creates a spectrogram of the test signal as a reference
% Creates a scrolling spectrogram
%   Scrolling left to right
%   Displays a section of the test signal spectrum
%       Section width must be easily modified
%           connected to fs or parameter
%   Stops when the end of the test signal is reached
%       The srolling needs to stop
%       The last section needs to still displayed
%       Maybe a stop button too?
%   Starts when the test signal is input

% Clear everything
clear all;
close all;
clc;

% Test Signal
% Chirp
T = 0:0.001:1;
X = chirp(T,100,1,200,'q');

% Reference Spectrogram
% spectrogram(X,128,120,128,1E3, 'yaxis'); 
% title('Quadratic Chirp');

% Display Section Length
n = 50;

% Pause between displaying
pause_length = 0.00001;

% Sampling Frequency of the Spectrogram
fs = 1E3;

% Set the figure size to full screen
fh = figure('WindowState','fullscreen');
set(fh, 'ToolBar', 'none');
set(fh, 'MenuBar', 'none');

% ??? This needs some more work
% Objective: Maxinize the size of the window inside the figure when it is
% displayed.
% Getting screensize and setting the figure size
% screensize = get(0, 'Screensize');
% fh = figure('InnerPosition',screensize);

% For Loop to generate a scrolling spectrogram
for i = 0:n:940
    spectrogram(X,128,120,128,1E3, 'yaxis');
    title('Scrolling Maybe');
    xlim([i, i+n]);
    drawnow;
    pause(pause_length);
end


