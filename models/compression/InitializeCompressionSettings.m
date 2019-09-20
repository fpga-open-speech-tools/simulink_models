%% script [AidSettingsXChans.m] where X is [1, 3, 5, 8, 12, 16, or 22]
%function [aligndelaymsec, chan_cfs, chan_crs, chan_thrs, pcact, t_atts, ta_lim, tr_lim] = AidSettingsXChans(NChans)
function [chan_cfs, chan_thrs, t_atts, t_rels] = InitializeCompressionSettings(NChans) %[aligndelaymsec]

%% Presumes that [NChans] has been set externally
%aligndelaymsec = 0; %% time delay for audio alignment with gain signal (post Fullgrabe et al, 2010 or 2011)
%%% remaining data should be 1-D arrays with NChans of parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% compression channel data, cf = 0 if not active, all arrays should be same length
%% compression thresholds specified relative to channel SPL for 65 dB input: FIXED in [update_channel_params]
r = nthroot(100, NChans+3);
a = 100*(r^2);
chan_cfs = a*r.^(1:NChans);
%% slow:
t_atts = zeros(1,5); t_rels = zeros(1,5);
t_atts(1) = 200; if NChans>1, t_atts(2:NChans)= 100; end
switch (NChans)
   case 1; t_rels(1) = [2000];
   case 3; t_rels(1:3) = [2000 1500 1200];
   otherwise; t_rels(1:3) = [2000 1500 1200]; t_rels(4:NChans) = 1000;
end

%% fast:
% t_atts(1:NChans) = 5;
% t_rels(1:NChans) = 40;
chan_thrs = zeros(1,NChans);
chan_thrs(1:ceil(NChans/2)) = -15; chan_thrs(floor(NChans/2)+1:ceil(3*NChans/4)) = -10; chan_thrs(ceil(3*NChans/4):NChans) = -5; chan_thrs(NChans)=0;


%end