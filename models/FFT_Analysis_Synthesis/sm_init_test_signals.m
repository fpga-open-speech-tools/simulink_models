function mp = sm_init_test_signals(mp)
[y,Fs] = audioread('../../test_signals/acoustic.wav');
y_resampled = resample(y,mp.Fs,Fs);  % resample to change the sample rate to mp.Fs
if (mp.fastsim_flag == 2) || (mp.fastsim_flag == 3)
    mp.test_signal.left  = y_resampled(1:mp.Naudio_samples);
    mp.test_signal.right = y_resampled(1:mp.Naudio_samples);
else
    mp.test_signal.left  = y_resampled;
    mp.test_signal.right = y_resampled;
end
mp.test_signal.Nsamples = length(mp.test_signal.left);
mp.test_signal.duration = length(mp.test_signal.left) * mp.Ts;



%% Convert to time series objects that can be read from "From Workspace" blocks
Nsamples = mp.test_signal.Nsamples;
timevals  =  (0:(Nsamples-1))*mp.Ts;  
mp.Source_Data_Left  = timeseries(mp.test_signal.left,timevals);
mp.Source_Data_Right = timeseries(mp.test_signal.right,timevals);

