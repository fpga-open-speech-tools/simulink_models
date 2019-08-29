%#codegen
% prepare constants
X_thresh = 1*10^(0.05*(0-85));
% preallocations
calib_bpfs = zeros(1730,5);
X_sweep = zeros(6,192001);
recombGain = zeros(1,5);
ig_eq = zeros(1,289);
delayFix = zeros(1,5);

% Amplitudes of 0 dBA ,    20 dBA  ,   40 dBA    ,   60 dBA     ,    80 dBA, 85 dBA
Amplitudes = [X_thresh, X_thresh*10, X_thresh*100, X_thresh*1000, X_thresh*10000, 1]; %, X_thresh*100000];

fMin = 100; %Hz
fMax = 10000; %Hz
Fs = 48000; %Hz
Ts = 1/Fs;
tt = 0:Ts:4;
deltaF = (fMax - fMin)/tt(end);
X_sweep = Amplitudes'*sin(2*pi*(fMin*tt +  0.5*deltaF*tt.*tt)) ;
X_out = zeros(6,length(tt));



NChans = 5;
[chan_cfs, chan_thrs, ~, ~] ...
   = InitializeCompressionSettings(NChans);

insrt_frqs = [125, 250, 500, 1000, 2000, 3000, 4000, 6000, 8000, 10000 ]; %% decimal values
insrt_gns = [0 3 5 10 15 20 25 30 30 30]; %% prescribed dB for 65 dB input
%insrt_gns = 5*ones(1,length(insrt_frqs));  %no prescription
%n_insrts = length(insrt_gns);
dBA65 = 0.1;
UPPER_FREQ_LIM = min(11e3, 0.90*Fs/2);
[ig_eq, calib_bpfs, ~, ~, Calib_recomb_dBpost] ...
    = update_channel_params(Fs, NChans, chan_cfs, chan_thrs, insrt_frqs, insrt_gns, ...
    dBA65, UPPER_FREQ_LIM, 6, 1, 1, 1) ;  %% calculates channel edge frequencies, generates expected band levels for LTASS SWN to calibrate compressors & filterbank

recombGain = 10.^(0.05.*Calib_recomb_dBpost);

X_high = 1;

spec_size = 1024;

% prepare  delay constants
Initialize_Delay_Values;    
% model the compression wrapper for each vol and band, without the table
% size limitation
%%
% preallocations
calib_bpfsF = zeros(1730,5);
X_sweepF = zeros(6,192001);
recombGainF = zeros(1,5);
ig_eqF = zeros(1,289);
delayFixF = zeros(1,5);

calib_bpfsF(:) = calib_bpfs(1:1730,1:5);
X_sweepF(:) = X_sweep(1:6,1:192001);
recombGainF(:) = recombGain(1:5);
ig_eqF(:) = ig_eq(1:289);
delayFix(:) = delayFix(1:5);
%%

argsIn = {calib_bpfsF, X_sweepF, recombGainF, ig_eqF, delayFixF, max_gain_prescript};
fiaccel fixedPointTesting...
    -args argsIn...
    -nargout 3
%%
tic;
[X_out_RxF , max_gain_prescriptF, freq_inF]  = fixedPointTesting_mex(calib_bpfsF, X_sweepF, recombGainF, ig_eqF, delayFixF, max_gain_prescript);toc