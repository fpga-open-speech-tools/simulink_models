%%%%%%% Nov 2015 : since very low CRs can be used (< ~1.1) then ANSI definitions of gain change typically do not work very
%%%%%%% well, or barmy time constants calculated.   Hence need to handle these.  Also, since fast  limiter tracks slow mean,
%%%%%%% for very low CRs, need to trap case where slow mean would not change fast mean ever, so fast was over active 
%%%%%%% (1) Updated from ISO/BS 25 dB step change in gain and settle to within 2 dB, to ANSI 2003 35 dB step change and
%%%%%%% slightly different settling requirements. 
%%%%%%% (2) inserted auto code so that at low CRs (< 1.14), the time constants do not end up so close to or even exceeding
%%%%%%% unity that the slow mean is never calculated or update so slowly that the fast limiter comes into action too often
%%%%%%% For low CRs, fast limiter really ought to be seen as/set more as a channel MPO 
%%%%%%% MAS, 19-11-2015

%%%%%%% Oct 2012, now can put in channel limiter: only  really relevant for SLOW time constants on first stage compressor
%%%%%%% this version handles multiple input levels : previously compressor was assumed to be operating on signals at 65 dB ref input level.,
%%%%%%% and gain was applied externally.  Therefore overall gain was set to 0dB for each channel RMS. 
%%%%%%% all parameters now passed in from outside
%%%%%%% channel_AGC, only single attack/decay is possible: user specifies time constants here
%% attack and release times used to be defined as time for output to reach within 2 dB of
%% steady state after 25 dB step change in input.  Recently the ANSI standard has changed
%% to 4 dB after 35 dB step.  Whatever, measured attack and release times will vary with
%% compression ratio used, and for some low ratios, may not even achieve 4 dB change in gain 
%% so a litle interpretation/simulation is required by the user, to match on the scale they require.
%% Stone & Moore compression papers usually simulate & equate the compressors on the "fr" scale, 
%% or fractional reduction in modulation (for examples see Stone & Moore, JASA 2003, 2004, 2008)
%% Stone & Moore also use what they call an "envelope compressor", which involves a 2-pole low-pass
%% filter of envelope with a near-Bessel response IIR filter.  The audio is then delayed relative to 
%% the gain signal, leaving a gain control system with a very clean envelope. (see Robinson &
%% Huntington 1973, poster abstract in JASA).  HOWEVER, for slower-acting compressors (equivalent
%% to release times greater than about 70 msec), the delay becomes impractical for real-time
%% applications, so it has not been included here.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [controlled_signal, pc_act] = dualchannel_AGC(signal, fs, t_att, t_rel, cr, chan0dBgn_lvl, chan_dBthr, deltaFSdB, t_attlim, t_rellim, diagnostic) %% thresh is in db units
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ANSI_ATTdB = 3; %% X dB, ATT time defined as settlement within this (in dB)
ANSI_RELdB = 4;  %% Y dB, REL time defined as settlement within this (in dB)
ANSI_STEPdB = 35;%% for this step change in input (55-90 dB SPL)  
min_dstpdB = ANSI_STEPdB/8;%% set minimum attack & release time constants to ensure that auto-calculation does not end up with no adjustment at low CRs. Here /8 effective when CR<=1.14 

expon = (1-cr)/cr; %%%%% exponent for envelope to gain conversion
cthresh = 10.^(.05*chan_dBthr);
zerodBpt = max(chan_dBthr, chan0dBgn_lvl);  %%% gain is 0dB for greater of compress. threshold OR reference level.
if diagnostic, fprintf(1,'\ndualchannel_AGC:\t cr = %4.2f, att=%4.1f, rel=%4.0f msec, normalise %5.1fdB', cr, t_att, t_rel, -zerodBpt*expon); end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% normalising gain to get 0dB gain from compressor for channel ip when presented with 65 dB wideband LTASS
g0dB = (10.^(-.05*chan0dBgn_lvl)) .^ expon ;  %% implicit inversion by '-' for normalisation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% need sig to drive AGC, but only concerned with what happens to envelope
%%%% for ANSI_STEPdB  change in input, sig envelope has to change to level that would give gain within ANSI_RELdB or
%%%% ANSI_ATTdB of final gain.  But at low CRs, may not even have such a gain change, so need to handle possible error
%%%% watch out for very low CRs in line below, Nov 2015, put in limit to prevent dstp < 0 
dstp_att = max(min_dstpdB, ANSI_STEPdB - ANSI_ATTdB*cr/(cr-1)); %%% full gain change, and.... to be within X dB of final $$$$ post 2008 error updated 14 Feb 2013 $$$$
dstp_rel = max(min_dstpdB, ANSI_STEPdB - ANSI_RELdB*cr/(cr-1)); %%% full gain change, and.... to be within Y dB of final $$$$ post 2008 error updated 14 Feb 2013 $$$$
if min(dstp_att, dstp_rel) == min_dstpdB,fprintf(1,'\n\tWARNING : CR very low in this channel : check fast limiter has not been over-active'); end
%% if dstp==0 then k_xyz = 1 inline below, so put in maximum value (< 1), related to standard
k_att = 10.^(.05*(-dstp_att/(t_att*fs/1000))); %% t_att in msec, hence /1000
k_rel = 10.^(.05*(-dstp_rel/(t_rel*fs/1000))); %% ditto

%% time constants for limiter: no chance to change attack, 2.5msec, but release can be varied externally.
CRLIM = 100; %% true limiter...............
dstp_limatt = max(min_dstpdB, ANSI_STEPdB - ANSI_ATTdB*CRLIM/(CRLIM-1)); %%% full gain change, and.... to be within X dB of final
dstp_limrel = max(min_dstpdB, ANSI_STEPdB - ANSI_RELdB*CRLIM/(CRLIM-1)); %%% full gain change, and.... to be within Y dB of final
k_attlim = 10.^((-.05*(dstp_limatt+ANSI_ATTdB))/(t_attlim*fs/1000)); %% ANSI X & YdB appears here
k_rellim = 10.^((-.05*(dstp_limrel+ANSI_RELdB))/(t_rellim*fs/1000)); %% t_att & t_rel in msec, hence /1000
deltaFSlin = 10.^(-.05*deltaFSdB); %% FAST-SLOW threshold difference : INVERT & convert to linear value
ExponLim = (1-CRLIM)/CRLIM; %%%%% exponent for envelope to gain conversion
%% single attack/decay on fullwave rectified linear envelope
%%%% NB implicit time shift of 1 sample since recursive structure involved
%%function envn = AGC_loop(ip, k_att, k_rel, thresh); %% thresh is linear
t_ix = length(signal);
env = zeros(1,1+t_ix);
env(1) = cthresh; %% start at CThresh value
%% similar for limiter array & start value 
envlim = zeros(1,1+t_ix);
envlim(1) = cthresh; %% start at CThresh value
for ix = 1:t_ix
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% standard channel compressor averageing process
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    env_ip = abs(signal(ix)); %% full wave rectify
    if env_ip > env(ix) %% attacking
        k = k_att;
    else %% releasing
        k = k_rel;
    end
    %% subtlety in next line is that estimate of envelope never goes below "thresh".  This stops "deadbands"
    %% developing when the signal suddenly attacks from nothing.  Envelope may then take a longer time to come
    %% back to a level where the gain changes
    env(ix+1) = max(cthresh,(1-k)*env_ip + k*env(ix)); %%%%% NEW 31-12-2001, externally defined threshold
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% Oct 2012, put in channel limiter, threshold floats with slower mean from above
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    env_ip = env_ip * deltaFSlin; %% want LIMITER mean to track relative to SLOW levels
    if env_ip > envlim(ix); %% attacking
        k = k_attlim;
    else %% releasing
        k = k_rellim;
    end
    %% save envelope as RELATIVE envelope compared to stage1 mean.
    envlim(ix+1) = max(cthresh, (1-k).*env_ip + k.*envlim(ix)); %% NB env_ip already reduced for this part of loop
end

%%% return only relevant part of envelope
%% envn = env(2:t_ix+1); %% here is implicit time shift
%% gain signal comes from raising envelope to a power 
gain_envlp = (env .^ expon) * g0dB;
limit= find(envlim > env);  %% only calculate exponent & division when limiter in action
gain_lim   = ((envlim(limit)./env(limit)) .^ ExponLim);  %% normalise gain change relative to slower envelope measure
gain_envlp(limit) = gain_envlp(limit).* gain_lim; %% pull in limiter gain

pc_act = round(10000*length(limit)/length(gain_envlp))/100; %% activity measure, to 0.01%
% % % Nov 2015 checking of time constants
% % % figure(999); plot(20*log10(gain_envlp),'c'); hold on; plot(20*log10(envlim),'r');  plot(20*log10(env),'g'); grid on; hold off;
% % % x = ginput(2); set(gca, 'xlim',[x(1,1) x(2,1)]); f = ginput(2) ; a = (f(2,2)-f(1,2)); b = 1000*(f(2,1)-f(1,1))/fs;
% % % fprintf(1,'\n %5.1f dB in %7.1f msecs=%6.3fdB/msec, require slope of %6.3fdB/msec',a,b,a/b, dstp_rel/t_rel); pause; figure(1); 

%%%%%% implement time-ADVANCE of gain,
% if time_shiftmsec ~= 0
%     gain_envlp = time_advance(gain_envlp, time_shiftmsec, fs, (cthresh.^expon));%% add padding 09-03-06
% end
%% move shortening of gain arrray to here
controlled_signal = signal .* gain_envlp(2:t_ix+1)'; %% when processing wav files need ['] transpose
