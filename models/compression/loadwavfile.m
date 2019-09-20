%%loadwavfile : alternative way of getting file into simulator
function [VALID_WAV_FILE, sig, Fs, nbits, file_rms_dB, NStreams] = ...
    loadwavfile ...
        (ipfiledigrms)
    
[newfile, newpath] = uigetfile('*.wav','Open Signal File To Process.....');
if isequal(newfile,0) || isequal(newpath,0)
    fprintf(1,'\nFile not found'); VALID_WAV_FILE = 0;
else
    [sig, Fs] = audioread(strcat(newpath,newfile));
    opplayer  = audioplayer(sig, Fs);
    nbits = opplayer.bitspersample;
    %sig = resample(sig,48000,Fs);
    %Fs = 48000;
    fprintf(1, '\nFile %s%s found', newpath, newfile);
    [hpfB, hpfA] = ellip(3,.1,30,40*1.22/(Fs/2),'high'); %% protective high-pass to remove infrasonics, flat to 50 Hz, < -55 below 20 Hz
    sigsize = size(sig);
    NStreams = min(size(sig));
    if sigsize(1) == NStreams, sig = sig'; end %% transform into standard shape
    if NStreams == 2 %% stereo signal, so adjust all tracks by same amount
        sig(:, 1) = filtfilt(hpfB, hpfA, sig(:, 1)); %%% quick and dirty high-pass filter, NB double pass gives linear phase.
        sig(:, 2) = filtfilt(hpfB, hpfA, sig(:, 2)); %%% quick and dirty high-pass filter, NB double pass gives linear phase.
        sig_mono = mean(sig,2);
        [rms, active] = channel_rms(sig_mono, Fs, [-13 65]); %% measure RMS of audio signal in a standard way
        file_rms_dB = 20*log10(rms);  %% save for later, incase ipfiledigrms gets updated
        adjustdB = ipfiledigrms - file_rms_dB;
        sig = sig * 10.^(.05*adjustdB); %% perform adjustment
        fprintf(1,'\nHigh-passed at 50 Hz to remove infrasonics in BOTH wav channels.\nAssuming file originally starts at 65 dB ip, so adjusting BOTH by %5.1fdB',adjustdB);
    else %% mono or multi-channel signal: treat each as separate signal
        for ix_Str = 1:NStreams
            sig(:, ix_Str) = filtfilt(hpfB, hpfA, sig(:, ix_Str)); %%% quick and dirty high-pass filter, NB double pass gives linear phase.
            %%function [rms, active] = channel_rms(signal, fs, dB_rel_rms); %% measure RMS of audio signal in a standard way
            [rms, active] = channel_rms(sig(:, ix_Str), Fs, [-13 65]); %% measure RMS of audio signal in a standard way
            file_rms_dB = 20*log10(rms);  %% save for later, in case ipfiledigrms gets updated
            adjustdB = ipfiledigrms - file_rms_dB;
            fprintf(1,'\nHigh-passed at 50 Hz to remove infrasonics in wav channel %d.\nAssuming file originally starts at 65 dB ip, so adjusting level by %5.1fdB \n',ix_Str,adjustdB);
            %% currently assume that signal is input at 65 dB SPL, so if file RMS deviates from this then adjust
            sig(:, ix_Str) = sig(:, ix_Str) * 10.^(.05*adjustdB); %% perform adjustment
        end
    end
    VALID_WAV_FILE = 1; %% flag to permit processing/offering of saving
end

end


