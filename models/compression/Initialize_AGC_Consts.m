%Initialize_AGC_Consts

Ts_system = Ts;
Fs_system = Fs;

%% setting up constants for dualchannelAGC(i)
ANSI_ATTdB = 3; %% X dB, ATT time defined as settlement within this (in dB)
ANSI_RELdB = 4;  %% Y dB, REL time defined as settlement within this (in dB)
ANSI_STEPdB = 35;%% for this step change in input (55-90 dB SPL)  
min_dstpdB = ANSI_STEPdB/8;%% set minimum attack & release time constants to ensure that auto-calculation does not end up with no adjustment at low CRs. Here /8 effective when CR<=1.14 

expon     = (1-chan_crs)./chan_crs;   %1xNChans
cthresh   = 10.^(0.05.*dig_chan_dBthrs); %1xNChans
zerodBpt = max(dig_chan_dBthrs', dig_chan_lvl_0dBgain')'; %1xNChans
g0dB = (10.^(-0.05*dig_chan_lvl_0dBgain)) .^ expon; %1xNChans
dstp_att = min_dstpdB.*ones(1,NChans);
dstp_att = max(dstp_att', (ANSI_STEPdB - ANSI_ATTdB.*chan_crs./(chan_crs-1))' )';
dstp_rel = min_dstpdB.*ones(1,NChans);
dstp_rel = max(dstp_att', (ANSI_STEPdB - ANSI_RELdB.*chan_crs./(chan_crs-1))' )';

if min(dstp_att, dstp_rel) == min_dstpdB,fprintf(1,'\n\tWARNING : CR very low in this channel : check fast limiter has not been over-active'); end

% k_att = 10.^(.05*(-dstp_att./(t_atts*Fs/1000))); %% t_att in msec, hence /1000
% k_rel = 10.^(.05*(-dstp_rel./(t_rels*Fs/1000))); %% ditto

% CRLIM = 100; %% true limiter...............

% dstp_limatt = min_dstpdB.*ones(1,NChans);
% dstp_limatt = max(dstp_att', (ANSI_STEPdB - ANSI_ATTdB.*CRLIM./(CRLIM-1))' )';
% dstp_limrel = min_dstpdB.*ones(1,NChans);
% dstp_limrel = max(dstp_att', (ANSI_STEPdB - ANSI_RELdB.*CRLIM./(CRLIM-1))' )';
% k_attlim = 10.^((-.05*(dstp_limatt+ANSI_ATTdB))./(ta_lim*Fs/1000)); %% ANSI X & YdB appears here
% k_rellim = 10.^((-.05*(dstp_limrel+ANSI_RELdB))./(tr_lim*Fs/1000)); %% t_att & t_rel in msec, hence /1000
% deltaFSlin = 10.^(-.05*deltaFSdB);
% ExponLim = (1-CRLIM)/CRLIM;

chan_recomb_gain = 10.^((0.05*Calib_recomb_dBpost));