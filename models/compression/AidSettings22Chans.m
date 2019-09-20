%%%%%%%%%%%%%%%%%%%%%%% MARINA'S SIMULATED HEARING AID

%% script [AidSettingsXChans.m] where X is [1, 3, 5, 8, 12, 16, or 22]
%% Presumes that [NChans] has been set externally
aligndelaymsec = 0; %% time delay for audio alignment with gain signal (post Fullgrabe et al, 2010 or 2011)MSC changed it to 0
%%% remaining data should be 1-D arrays with NChans of parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% compression channel data, cf = 0 if not active, all arrays should be same length
%% compression thresholds specified relative to channel SPL for 65 dB input: FIXED in [update_channel_params]
chan_cfs = [125 185 255 337 433 545 676 829 1008 1216 1460 1746 2079 2468 2923 3455 4077 4804 5653 6645 7805 9161];%% assumed geometric spacing : edges/crossovers will be ratio spaced
%%SLOW compression
% t_atts = [50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50]; %% attack times msec
% t_rels = [3000 3000 3000 3000 3000 3000 3000 3000 3000 3000 3000 3000 3000 3000 3000 3000 3000 3000 3000 3000 3000 3000]; %% msec
%% FAST compression
t_atts = [10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10]; %% attack times msec
t_rels = [100 100 100 100 100 100 100 100 100 100 100 100 100 100 100 100 100 100 100 100 100 100]; %% msec
%%Tom Empson slow22
% chan_crs = [1 1.02 1.03 1.08 1.11 1.15 1.21 1.26 1.28 1.33 1.45 1.56 1.73 1.98 2.30 2.52 2.78 2.81 2.46 2.20 2.05 3.18];
%%Brian Moore fast22
% chan_crs= [1 1 1 1 1 1.04 1.12 1.25 1.47 1.53 1.69 1.85 2.07 2.11 2.08 2.19 2.41 2.79 3 3 2.98 3]
chan_thrs = [-14 -14 -14 -14 -14 -15 -15 -16 -16 -16 -17 -17 -18 -18 -18 -19 -19 -19 -20 -20 -20 -20]; %% dB rel channel RMS when carrying 65 dB SWN
% ALL LINEAR
chan_crs= [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Channel limiter settings: compression ratios FIXED in dualchannel_AGC (100)
% deltaFSdB = [13 13  13  13  13 13 13 13 13 13 13 13 12 12 12 12 11 11 11 11 10 10]; %% Limiter threshold distance above slower compression mean (ie tracking ONLY)
deltaFSdB = [20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20];
pcact = zeros(size(deltaFSdB)); %% leave at 0, but NChans worthpercentage of time that limiter was active, updates every [recalculate]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% auto-populate limiter attack and release times from (a) minimum value for each and (b) ratio of change from high freq down to low
ta_min  = 2; ta_range = 3; %% minimum attack time for limiter, and multiplier to increase it towards lower freq chans
ta_lims = ta_min * (1 +  ((NChans:-1:1)./NChans)*(ta_range-1));
ta_lim    = round(min(t_atts/2, ta_lims)); %% Limiter attack times
tr_min  = 40; tr_range = 2; %% minimum release time for limiter, and multiplier to increase it towards lower freq chans
tr_lims = tr_min * (1 +  ((NChans:-1:1)./NChans)*(tr_range-1));
tr_lim   = round(min(t_rels/2, tr_lims)); %% Limiter release times
