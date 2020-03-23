%% Scrolling Spectrogram Code
% Hezekiah Austin
% Last Modification: 2020-02-13
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

% Test Signal Sines
N = 2048*4;
n = 0:N-1;
w0 = 2*pi/5;
test_signal_1 = sin(w0*n)+10*sin(2*w0*n);
test_signal_2 = sin(3w0*n)+10*sin(4w0*n);

% % Test Signal Chirp
% T = 0:0.00001:1;
% test_signal = chirp(T,0,1,250);


% ??? Reference Spectrogram and subplot used to testing. REMOVE WHEN DONE
figure(1)
spectrogram(test_signal_1,'yaxis');
title('Spectrogram of Test Signal');




% Pause between Displaying Sections on the Spectrogram
% This controls the scrolling speed
pause_length = 0.01;

% Sampling Frequency of the Spectrogram
fs = 1E3;

% Set the figure size to full screen
% fh = figure('WindowState','fullscreen');
% set(fh, 'ToolBar', 'none');
% set(fh, 'MenuBar', 'none');


% Number of Data Points Being Grabbed
m = 1000;

% Counting the Number of Sections
section_counter = 1;
loop_counter = 0;

for i = 1:1:round(length(test_signal_1)/m)
    
    % Grabs an m wide section of test signal
    X = test_signal_1( (1 +(section_counter-1)*m) :(section_counter*m));
    
    
    % If statement to stop the Scrolling Spectrogram
    % This statement will trigger if the data grabbing overruns the
    % updating of the FPGA
    % ??? Possible updates:
    % 1. Change this to a pause and wait for the FPGA to
    % update the data and then continue running.
    % 2. Setup a control from the keyboard to end the Scrolling
    % Spectrogram.
    if (section_counter*m) > length(test_signal_1)
        break;
    end
    
    % Data Section Length
    n = round(length(X)/15);
    
    % Window and Noverlap
    window_size = round(n);
    overlap_size = round(window_size/2);
    
    % Scrolling Spectrogram
    for j = 1:n:length(X)
        
        % End loop when scrolling reaches end of section
        if (j + n) > length(X)
            break;
        end
        
        % Grabbing a section of data from output signal
        % Data sections must overlap by 50% and be greater than window length for
        % spectrogram
        X_section = X(j:(j+n));
        figure(2)
        spectrogram(X_section,window_size,overlap_size,256,fs, 'yaxis');
        title('Test of Scrolling');
        set(gca,'Xticklabel',[])
        drawnow;
        pause(pause_length);
        
        
    end
    
    % Step to Next Section
    section_counter = section_counter + 1;
    
    % Prints information to command line
    loop_counter = loop_counter + 1
    ans = loop_counter*m
    length_test_signal = length(test_signal_1)
    % Updates test signal
    test_signal_1 = [test_signal_1 test_signal_2];
end


