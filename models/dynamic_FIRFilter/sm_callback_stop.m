% sm_callback_stop
%
% This scripts captures the output signals and then verifies that
% these signals are correct. The script runs after the simulation stops.  
% This is called in the StopFcn callback found in Model Explorer.
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
% Flat Earth Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com

%% Put the output into the FIR Test Sets into a data struct 
% The "To Workspace" block won't accept structs
mp.Avalon_Sink_Data.Time    = Avalon_Sink_Data.Time;    % time
mp.Avalon_Sink_Data.Data    = Avalon_Sink_Data.Data;    % data      
mp.Avalon_Sink_Channel.Data = Avalon_Sink_Channel.Data; % channel
mp.Avalon_Sink_Valid.Data   = Avalon_Sink_Valid.Data;   % valid


if mp.sim_prompts == 1  % sim_prompts is set in Run_me_first.m   This is turned off when the model is converted to VHDL since we don't want to run the verification multiple times at this point (HDL coder runs the simulation multiple times)
    mp = sm_stop_process_output(mp);  % get the output and convert from Avalon to vector
%     mp = sm_stop_verify(mp);          % verify that the output is correct
end

%% Plot some stuff
close all; % Close any plots prior to output plots
figure;
% Grab the output data and time vectors - cast to type double

time = 0: 1 / mp.Fs : length(mp.left_data_out)*1/mp.Fs;
time = time(1:end-1)';
% Time domain chirp plot
subplot(211);
plot(time, mp.left_data_out, 'LineWidth', 0.01);
xlim([0, stop_time])
xlabel('Time [sec]');
title('Left Data');

% Spectrogram
subplot(212);
%spectrogram(mp.left_data_out,8192,7800,8192,mp.Fs, 'yaxis');   % Display the spectrogram.
ylim([1 2]);  
title('HPF Filtered Speech Signal Chirp Spectrogram');
print('lpfFilt_speech_chirp_signal', '-dpng');


figure;
% Grab the output data and time vectors - cast to type double

time = 0: 1 / mp.Fs : length(mp.right_data_out)*1/mp.Fs;
time = time(1:end-1)';
% Time domain chirp plot
subplot(211);
plot(time, mp.right_data_out, 'LineWidth', 0.01);
xlim([0, stop_time])
xlabel('Time [sec]');
title('Right Data');

% Spectrogram
subplot(212);
%spectrogram(mp.left_data_out,8192,7800,8192,mp.Fs, 'yaxis');   % Display the spectrogram.
ylim([1 2]);  
title('HPF Filtered Signal Chirp Spectrogram');
print('lpfFilt_speech_chirp_signal', '-dpng');



