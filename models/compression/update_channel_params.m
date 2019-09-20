function [ig_eq, calib_bpfs, dig_chan_lvl_0dBgain, dig_chan_dBthrs, Calib_recomb_dBpost] = ...
    update_channel_params ...
        (Fs, NChans, chan_cfs, chan_thrs, insrt_frqs, insrt_gns, ipfiledigrms, UPPER_FREQ_LIM, ...
        EQ_SPAN_MSEC, PRESCRIPT, DIAGNOSTIC, CALIB_DIAGNOSTIC)

%%%  Mar 2016, apart from calibrating the compressor channels, now calculates the apparent gain increase
%%%  due to overlap between filter channels.  Involves splitting filterbank aid into two parts: design of 
%%%  band-pass FIRs as well as filtering & implementation of AGC
%%%  For interest, have also kept in the calculation of band powers for both the calibration signal with and without IG65 applied

%%% update_channel_params, to change edges array, as well as band levels when a channel cf changes.
edges = sqrt ( chan_cfs(2:end) .* chan_cfs(1:end-1) ); %% geometric mean
dummy_low_edge = edges(1)*(chan_cfs(1)/chan_cfs(2)); %% not used directly in Nchan_FbankAid, but helps with filter design, save for later
edges = [edges  UPPER_FREQ_LIM]; %% end stops to make software work, lowest not really implemented in software, upper set in main script
%%% spoof lowest edge freq for filyterbank design, not power calculations, does not produce edge in filterbank design
fb_edges = [dummy_low_edge  edges]; %% will need dummy low edge to make filterbank design software work, lowest not implemented in software other than transition width
[bpfs] = Nchan_FbankDesign(fb_edges, Fs, DIAGNOSTIC); %% Mar2016 move design of filterbank to here
real_edges = [100  edges]; %% these are what are useful in calculation of channel powers [eg CalibrateFilterbankOverlap], not fir design

%%% moved here from [recalculate] in Mar2016
%%function aperture = prescription_design_function(frqs, gains_dB, fs, span_msec, diagnostic);
%% Nov 2012, with extended low freq prescription, set to always plot achieved response
[ig_eq, all_ok] = prescription_design_function(insrt_frqs, insrt_gns, Fs, EQ_SPAN_MSEC, PRESCRIPT); %% separate switch in [aid_sim] to turn off plotting.
if ~all_ok, fprintf(1,'\nWARNING: only achieved bandlimited IG65 : (is the sampling rate too low for the prescription?)'); end

%%%%%%%%%%%%%%%%%%%%%%%  Replacement code Apr 2016 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Mar 2016, calculate filterbank summation compared to ideal band powers, replace [eandh2008_band_levels]
%%% calculate as if filters were idfeal, non-overlapping rectangels, and as actually implemented.  Also calculate these for
%%% before & after application of insertion gain (IG65)
%%% function [BPF_ChanCalNsedBpost, BPF_ChanCalNsedBpre dBpost_correct dBpre_correct] = CalibrateFilterBankOverlap(bpfs, fs, nchans, edges, ig65_eqfir);
% % % [BPF_ChanCalNsedBpost, BPF_ChanCalNsedBpre, dBpost_correct, dBpre_correct] = CalibrateFilterBankOverlap(bpfs, Fs, NChans, real_edges, ig_eq); %% creates array [BPF_ChanCalNsedB] from unity RMS EH2008 noise sample
% % % function [chan_reldB_lvls , chan_reldB_lvls_postig65, BPF_chan_reldB_lvls, BPF_chan_reldB_lvls_postig65, RecombinedBPF_dBpre, RecombinedBPF_dBpost, geo_cfs] = CalibrateFilterBankOverlap(bpfs, fs, nchans, edges, ig65_eqfir);
[chan_reldB_lvls , chan_reldB_lvls_postig65, BPF_chan_reldB_lvls, BPF_chan_reldB_lvls_postig65, RecombinedBPF_dBpre, RecombinedBPF_dBpost, geo_cfs] = CalibrateFilterBankOverlap(bpfs, Fs, NChans, real_edges, ig_eq);

%%%%%%%%%%%%%%%%%%%%%%%  Replaced Apr 2016 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% spoof lowest edge freq, does not produce edge in filterbank design, useful for integration bandwidths
% % function [dB_lvls, dB_lvls_posteq, geo_cfs] = eandh2008_band_levels(eq_frs, eq_gns, fs, band_edges);
% % [chan_reldB_lvlsX, chan_reldB_lvls_postig65X, geo_cfsX] = eandh2008_band_levels(insrt_frqs, insrt_gns, Fs, real_edges);  %% calculate channel powers relative to 0dB total power, assuming SII-shaped spectrum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
chan_dBSPL_lvls = 65 + chan_reldB_lvls; %% interim working only, band levels HARD-WIRED to reference of 65 dB input, BEFORE ig65 eq.
spl_chan_thrs   = chan_dBSPL_lvls + chan_thrs; %% equivalent SPL of channel compression threshold, for printing to GUI only

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% compression is appled post insertion gain, so compression thresholds need to be adjusted to account for levl change
dig_chan_lvl_0dBgain = ipfiledigrms + chan_reldB_lvls_postig65; %% digital channel levels for equiv wideband 65 dB ip, where compressor should give 0 dB gain
dig_chan_dBthrs      = dig_chan_lvl_0dBgain + chan_thrs; %% real, rather than relative compression thresholds for digital processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

calib_bpfs = bpfs; %% safety copy
FBanalysis_dBpost = chan_reldB_lvls_postig65 - BPF_chan_reldB_lvls_postig65; %% correction to filterbank to ensure correct channel power estimation (analysis)
FBanalysis_dBpre  = chan_reldB_lvls - BPF_chan_reldB_lvls; %% NOT USED (pre IG65 correction to filterbank to ensure correct channel power estimation (analysis))
FBanal_recomb_dBpost = chan_reldB_lvls_postig65 - RecombinedBPF_dBpost; %% TOTAL correction to filterbank for analysis + recombination (used in Nchan_FbankAGCAid.m)
FBanal_recomb_dBpre  = chan_reldB_lvls - RecombinedBPF_dBpre; %% NOT USED (pre IG65 correction to filterbank for analysis + recombination)
fprintf(1,'\nCorrections necessary to correct for filterbank overlap (dB):');
fprintf(1,'\n(a) channel analysis BEFORE AGC (b) channel recombination AFTER AGC (as implemented)');
Calib_recomb_dBpost= FBanal_recomb_dBpost - FBanalysis_dBpost; %% final stage (recombination) correction to be used with channles separated by [calib_bpfs]
Calib_recomb_dBpre = FBanal_recomb_dBpre  - FBanalysis_dBpre; %% NOT USED
for ix = 1:NChans %% reduce original filterbank design which had 0dB at centre of bands, to account for power estimation error.
    if CALIB_DIAGNOSTIC, fprintf(1,'\n Chan %2d : %6.1f %6.1f ', ix, FBanalysis_dBpost(ix), Calib_recomb_dBpost(ix)  ); end
    calib_bpfs(2:end,ix)  = calib_bpfs(2:end,ix) .* 10.^(0.05 * FBanalysis_dBpost(ix)); %% apply inverse correction in level
end
% % fprintf(1,'\nFlat %5.2f : Eq %5.2f, FB eq Eq %5.2f ', 10*log10(sum(10.^(.1*chan_reldB_lvls))), 10*log10(sum(10.^(.1*chan_reldB_lvls_postig65))), 10*log10(sum(10.^(.1*BPF_ChanCalNsedBpost))));
% % fprintf(1,'\n');
if CALIB_DIAGNOSTIC,  %% plot & print out filterbank channel responses before and after calibration for overlap
    for ix = 1:NChans
        [hzb fzb]  = freqz(bpfs(2:(bpfs(1,ix)+1),ix), 1, 2.^(nextpow2(Fs/6)), Fs);
        [hzc fzc]  = freqz(calib_bpfs(2:(calib_bpfs(1,ix)+1),ix), 1, 2.^(nextpow2(Fs/6)), Fs);
        figure(999*CALIB_DIAGNOSTIC);
        semilogx(fzb,20*log10((abs(hzb)+1e-7)),'b',fzc,20*log10((abs(hzc)+1e-7)),'c'); hold on ;
        set(gca,'xlim',[70 1.1*Fs/2],'ylim',[-75 2]); grid on ;
    end
    title('Filterbank before (blue) and after(cyan) calibration for overlap (assumes after IG65 applied)', 'fontsize', 11);
    hold off;
end

end