%% recalculate:  to recalculate aid simulation after settings have changed,
function [proc_sig]...
    = recalculate ...
        (NChans, sig, Fs, re_level, calib_bpfs, t_atts, t_rels, ...
        chan_crs, dig_chan_lvl_0dBgain, dig_chan_dBthrs, deltaFSdB, ... %[aligndelaymsec]
        ta_lim, tr_lim, Calib_recomb_dBpost, ig_eq, DIAGNOSTIC)
    
%%function aperture = prescription_design_function(frqs, gains_dB, fs, span_msec, diagnostic);
%% Nov 2012, with extended low freq prescription, set to always plot achieved response

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(1,'\nApplying IG65(SWN).......');
%%% ig65 applied before compression
eq_sig = filter(ig_eq, 1, sig); 
%%% which means that compression thresholds need to be calculated on signal post-eq (done in [update_channel_params]
fprintf(1,'\nApplying multi-channel compression.......');

%% updated function mid-Feb 2008, so that compressor can take input levels not at 65 dB SPL equiv.
%% jun 2015, now returns bps coefficients in fixed array: first element isn umber of taps, second 
%% [re_level = 10.^(.05*(equiv_ipSPL-65));] is calculated earlier in calling script, shifts signal level up or down to account for level required 
%%function proc = Nchan_FbankAid(signal, edges, fs, t_atts, t_rels, chan_crs, dig_chan_lvl_0dBgain, dig_chan_dBthrs, aligndelay, diagnostic);
%% dig_chan_lvl_0dBgain & dig_chan_dBthrs are set in update_channel_params, (a) digital rms channel levels for 65 dB 
%% equiv ip, where compressor will have 0dB gain and (b) digital rms channel levels for compression thresholds.
%%function [proc  bpf  pc_act] = Nchan_FbankAid(signal, edges, fs, t_atts, t_rels, chan_crs, dig_chan_lvl_0dBgain, dig_chan_dBthrs, aligndelay, deltaFSdB, t_attlim, t_rellim, diagnostic);
% % [proc_sig  bpfs  pcact] = Nchan_FbankAid( (eq_sig*re_level) , edges, Fs, t_atts, t_rels, chan_crs, dig_chan_lvl_0dBgain, dig_chan_dBthrs, aligndelaymsec, deltaFSdB, ta_lim, tr_lim, DIAGNOSTIC);
% % Mar 2016 Split Nchan_FbankAid into two parts : (a) filterbank design and (b) processing of signal
%%% Aim is to get calibraiton signal out of filterbank to account for overlap, so filtebrank design performed elsewhere
% % PART 1  :function [bpf] = Nchan_FbankDesign(edges, fs, diagnostic);
% % [bpfs] = Nchan_FbankDesign(edges, Fs, DIAGNOSTIC); %% Mar 2016 now calculated in update_channel_params
% %  PART 2 : process signal : note with calibrated bpfs, from [update_channel_params]
% % function [proc  pc_act] = Nchan_FbankAGCAid(signal, nchans, bpf, fs, t_atts, t_rels, chan_crs, dig_chan_lvl_0dBgain, dig_chan_dBthrs, aligndelay, deltaFSdB, t_attlim, t_rellim, recombdB, diagnostic);
[proc_sig, pcact] = Nchan_FbankAGCAid( (eq_sig*re_level), NChans, calib_bpfs, Fs, t_atts, t_rels, chan_crs, dig_chan_lvl_0dBgain, dig_chan_dBthrs, deltaFSdB, ta_lim, tr_lim, Calib_recomb_dBpost, DIAGNOSTIC);

fprintf(1,'\nChannel limiter activity in %%-ages of samples: \n');
for ix_cf = 1:NChans
    %%%% limiter activity proportion
    fprintf(1, '[%2d] %.2f ', ix_cf, pcact(ix_cf) ); 
    if ~mod(ix_cf,5), fprintf('\n'); end %% %% layout limiter activation neatly on screen
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% scale output now done solely on play_audio, or saving to wav file

end