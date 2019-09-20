%% was originally filterbank design plus AGC, but now split so that now just AGC, Mar 2016
%% enables calibration for filterbank overlap to be carried out separately. MAS
%% needs new variable to reduce channel gains in recombination.  Calculated in [CalibrateFilterbankOverlap]

%% input & output of compressor is equated to have 0dB gain at channel rms
%% last channel is ALWAYS high-pass only.  Band-pass channels are reduced in
%% width to be less than length(lpf)+length(hpf), which will reduce perfection
%% of recombination.

%% to perform compression in a multi-channel filterbank aid.  Filters signal into channels with band-pass filters designed from
%% specifying the edge frequencies of the channels.  Design technique is to design high-pass edge first, then low-pass design and
%% convolve the two to make a band-pass filter.  Low-pass of stage N is complemented to make the high-pass of stage N+1, so that
%% when recombining should get near flat response.  Minor ripples do remain because of windowing that goes on to reduce the
%% span of the FIR coefficiaents.  Length of FIR for each channel adapts to be approx similar on a log frequency scale.
%% Consequently we will get variable delay in each channel.  Hence software removes this before adding back all channel signals to
%% make the ouput signal.
%% the filterbank desing contains a couple of "magic numbers" such as firlen0, which determines the maximum size of the FIR, and
%% hence rate of cut at the channel edges.  Additionally, there is also a beta value for a couple of kaiser windows which are
%% chosen (a) to tame the tails of the bpf filters and (b) later to reduce the span of the convolved lpf/hpf pair.  Consequently
%% these values also modify the roll-off rate near the top of the filter. If the filters do not cross over at around -6 dB then
%% there will be a lumpy recombination response.  User needs to tailor these numbers until he/she is happy with the filter shape.
%% Do not want too long a time-domain response because (a) this is associated with  a long time delay, or (b) listeners may hear
%% pre-echoes

%% NB this version does not do filtering of channel signals post compression, so side-band modulations are not suppressed
%% no noise band modulation in here:really a multi-channel acoustic aidsimulation.  Simpler return to calling program.  Need special case to
%% handle single channel AGC.
%%% backward compatible, but in Dec03 AGC_type (last var in call) now has
%%% two values, AGC_type and shift in compression threshold from standard 13 dB below RMS

function [proc,  pc_act] = Nchan_FbankAGCAid(signal, nchans, bpf, fs, t_atts, t_rels, chan_crs, dig_chan_lvl_0dBgain, dig_chan_dBthrs, deltaFSdB, t_attlim, t_rellim, recombdB, diagnostic) %(aligndelay)
proc_len = length(signal);
proc = zeros(proc_len,1); %%%% output array
pc_act = zeros(1, nchans);
%%%%% now perform meat of processing, channel separation and processing before recombination
for ix = 1:nchans %%% run firs, gradually increase window to reduce tails
    bpf_len  = bpf(1,ix); %% extract filter length and .........
    bpf_chan = bpf(2:bpf_len+1,ix); %% .......extract filter
% % %     [hz fz] = freqz(bpf_chan, 1, 2.^(nextpow2(fs/6)), fs);
% % %     figure(1010); semilogx(fz,20*log10((abs(hz)+1e-7)),'b'); hold on ; set(gca,'xlim',[70 1.1*fs/2],'ylim',[-75 2]); grid on ;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    chan_signal= filter(bpf_chan,1,signal); %% bandpass , then adjust for delay
    dly_shift = floor(bpf_len/2); %%% compensating shift to time-align all filter outputs
    valid_len = proc_len-dly_shift;%% _advance_ filter outputs
    chan_signal(1:valid_len) = chan_signal(1+dly_shift:proc_len); %%% time advance
    chan_signal(1+valid_len:proc_len) = 0.; %%% kill the rest
    %%dig_chan_lvl_0dBgain : digital channel levels for equiv 65 dB wideband ip, where compressor should give 0 dB gain
    %% new_chan_signal = channel_AGC(chan_signal, fs, t_atts(ix), t_rels(ix), chan_crs(ix), dig_chan_lvl_0dBgain(ix), dig_chan_dBthrs(ix), aligndelay, diagnostic ); %% thresholds now dB
    %% function [controlled_signal pc_act] = dualchannel_AGC(signal, fs, t_att, t_rel, cr, chan0dBgn_lvl, chan_dBthr, time_shiftmsec, deltaFSdB, , zzt_attlim, t_rellim, diagnostic) %% thresh is in db units
%     fprintf(1,'\n[%d] ', ix);
    [new_chan_signal, pc_act(ix)] = dualchannel_AGC(chan_signal, fs, t_atts(ix), t_rels(ix), chan_crs(ix), dig_chan_lvl_0dBgain(ix), dig_chan_dBthrs(ix), deltaFSdB(ix), t_attlim(ix), t_rellim(ix), diagnostic ); %% thresholds now dB
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    proc = proc + new_chan_signal*10.^(.05*recombdB(ix));  %% ready for return to calling program, new gain change to allow for channel overlaps. Mar 2016
end
% % % figure(1010); hold off; 