%% Moore et al 2008 E&H paper suggests that shape would be better as -7.5
%% dB/oct, at least up to 8 kHz, and -13 dB/oct above there.

%% to take white noise and re-shape to ideal SII, ie flat to 500 Hz, and sloping -9db/oct
%% beyond that. Durn in secs, and fs is sampling rate.

%% FIR filter width is always 10 msec
function eh2008_nse = gen_eh2008_speech_noise(durn, fs)
%%%%% ideal pre-emphasis (starts off as SII 1997), then rescaled for Moore et al. 2008
hz =       [0, 100,200,450, 550,707,1000,1414, 2000, 2828,4000,5656,8000,16e3,32e3];
emphasis = [0,0., 0., 0, -0.5,-4.5, -9.,-13.5, -18,-22.5,-27,-31.5,-36.,-51,-66];  %% NB last two are -15dB/oct before rescaling below
emphasis = emphasis*(7.5/9); %%% this rescales so that we get -7.5 dB/oct up to 8kHz, and -13 dB/oct above that 
norm_freq  = hz./(fs/2); 
last_f = max(find(norm_freq < 1));
norm_freq = [norm_freq(1:last_f) 1];
emph_nyq  = emphasis(last_f) + 9*log10(norm_freq(last_f))/log10(2); %% -9 dB/oct constant slope
norm_emph = [emphasis(1:last_f) emph_nyq];
m = exp(log(10)*norm_emph/20);

%%% whatever fs, 10 msec window, but make sure that it is even
b = fir2(2*ceil(10*(fs/2000)),norm_freq,m); % f= 1 is equiv to Nyquist
%%freqz(b,1,2048,fs); grid on; set(gca,'ylim',[-40 2],'xlim',[10 max(8000, fs/2)],'xscale','log');
%%% high-pass filter to remove low freqs (will be 2-pass with filtfilt)..........
[hpfB, hpfA] = ellip(3,.1,50,100/(fs/2),'high');
%%freqz(hpfB,hpfA,4096,fs); grid on; set(gca,'ylim',[-80 2],'xlim',[10 max(8000, fs/2)],'xscale','log');
%%%% white noise, 0 DC
nburst = (rand(1,round(durn*fs+length(b)))-0.5); 
eh2008_nse = filter(b,1,nburst);
eh2008_nse = filtfilt(hpfB, hpfA, eh2008_nse); %%% remove low-freq noise that may bias RMS estimate, -33dB at 50 Hz
%%figure(2); psd(eh2008_nse,2048,fs); set(gca,'xlim',[20 8000],'xscale','log'); figure(1);
%%% used to stop here pre-Jan2004
%% this introduces a delay so remove it, ie time-ADVANCE audio
dly_shift = floor(length(b)/2); %%% compensating shift to time-align all filter outputs
valid_len = length(eh2008_nse)-dly_shift;%% _advance_ filter outputs
eh2008_nse(1:valid_len) =  eh2008_nse(1+dly_shift:end); %%% time advance
eh2008_nse = eh2008_nse(1:round(durn*fs)); %%% return exactly what was asked for.....

