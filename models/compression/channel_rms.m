%% was measure_rms, but cut down to prevent throwing loads of text to command window, Feb 09
%% 
%% Sept 2005, standardise on measuring RMS, not tracking percentage of frames
%%  dB_rel_rms is threshold relative to first-stage rms
function [rms, active] = channel_rms(signal, fs, dB_rel_rms); %% measure RMS of audio signal in a standard way 

first_stage_rms = sqrt(sum(signal.^2)/length(signal));
winlen = ceil(0.01*fs);
%% use this RMS to generate key threshold to get more accurate RMS
key_thr_dB = max(20*log10(first_stage_rms) +  dB_rel_rms(1), -70);%% Nov2003, put max in here for when signal is close to 0
if length(dB_rel_rms) > 1 %% possibility of tracking percentage of frames, rather than threshold (%-age comes in as second parameter in dB_rel_rms)
    [key new_thr_dB] = generate_key_percent(signal, [key_thr_dB dB_rel_rms(2)], winlen); %%%% move key_thr_dB to account for noise less peakier than signal
else
    [key new_thr_dB] = generate_key_percent(signal, key_thr_dB, winlen); %%%% move key_thr_dB to account for noise less peakier than signal
end
rms = sqrt(sum(signal(key).^2)/length(key));
active = 100*length(key)/length(signal); %% percent active
