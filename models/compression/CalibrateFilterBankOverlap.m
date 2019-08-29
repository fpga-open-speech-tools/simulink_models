%%%%% In filterbank overlap, we have 2 problems: (1) the filter integrates broader than intended and (2) the summation of the
%%%%% filterbank does not become 0dB. So need to generate 2 corrections: (1) how muh the filter overintegrates compared to
%%%%% expected and (2) how much the recombined filterbank exceeds expected.  This function calculates (1) but only as the 
function [chan_reldB_lvls , chan_reldB_lvls_postig65, BPF_chan_reldB_lvls, BPF_chan_reldB_lvls_postig65, RecombinedBPF_dBpre, RecombinedBPF_dBpost, geo_cfs] = CalibrateFilterBankOverlap(bpfs, fs, nchans, edges, ig65_eqfir);
Npsd = 2.^(nextpower2(fs/6));   % nextpow2 isn't HDL compatible
% % function eh2008_nse = gen_eh2008_speech_noise(durn, fs);
% % %% generate 1-sec calibration noise, with unity RMS input level.
eh2008_nse = gen_eh2008_speech_noise(5.1, fs);
% % %% since normalised signal to unity RMS: channel levels then become RELATIVE,
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   as per calculations in [eandh2008_band_levels]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eh2008_nse = eh2008_nse / sqrt(mean(eh2008_nse.^2));
[Pipn, Fipn] = pwelch(eh2008_nse,hamming(Npsd),Npsd/2,[],fs);
% % figure(1001); semilogx(Fipn, 10*log10(Pipn)); grid on; set(gca,'xlim', [50 11e3],'ylim', [-60 -10]);
psd_scaledB = 10*log10(sum(Pipn));  %% to convert from psd units to unity RMS (as original signal was)
%%function [dBpwrs] = integrate_band_powers(fpwrs, pwrs, band_edges);
[chan_reldB_lvls] = integrate_band_powers(Fipn, Pipn, edges); %% intended band powers, BEFORE application of IG65
chan_reldB_lvls = chan_reldB_lvls - psd_scaledB; %% referenced back to original LTASS noise with unity RMS in time 
%%%% apply insertion prescription
eq_nse = filter(ig65_eqfir, 1, eh2008_nse);
[Peqn, Feqn] = pwelch(eq_nse,hamming(Npsd),Npsd/2,[],fs);
[chan_reldB_lvls_postig65] = integrate_band_powers(Feqn, Peqn, edges);  %% intended band powers, AFTER application of IG65
chan_reldB_lvls_postig65 = chan_reldB_lvls_postig65 - psd_scaledB; %% referenced back to original LTASS noise with unity RMS in time 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

proc_len = length(eq_nse);
BPFop_pre = zeros(1,proc_len);
BPFop_post = zeros(1,proc_len);
%%%% now apply filterbank to EH2008Noise AFTER equalisation, and measure mean channel level
BPF_chan_reldB_lvls  = zeros(1, nchans); % what happens to LTASS noise if filtered BEFORE prescription
BPF_chan_reldB_lvls_postig65 = zeros(1, nchans);% what happens to LTASS noise if filtered AFTER prescription (as normally done)
geo_cfs = zeros(1, nchans);% for return to calling program
%%%%% now perform meat of processing, channel separation and processing before recombination
for ix = 1:nchans %%% run firs,
    bpf_len  = bpfs(1,ix); %% extract filter length and .........
    bpf_chan = bpfs(2:bpf_len+1,ix); %% .......extract filter
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    chan_signal= filter(bpf_chan, 1, eh2008_nse); %% bandpass , then adjust for delay
    dly_shift = floor(bpf_len/2); %%% compensating shift to time-align all filter outputs
    valid_len = proc_len-dly_shift;%% _advance_ filter outputs
    chan_signal(1:valid_len) = chan_signal(1+dly_shift:proc_len); %%% time advance
    BPF_chan_reldB_lvls(ix) = 10*log10(mean(chan_signal(1:valid_len).^2)); %% ACTUAL band powers, BEFORE application of IG65
    BPFop_pre = BPFop_pre + chan_signal; %% recombined filterbank signal, BEFORE application of IG65
    
    chan_signal= filter(bpf_chan, 1, eq_nse); %% bandpass , then adjust for delay
    dly_shift = floor(bpf_len/2); %%% compensating shift to time-align all filter outputs
    valid_len = proc_len-dly_shift;%% _advance_ filter outputs
    chan_signal(1:valid_len) = chan_signal(1+dly_shift:proc_len); %%% time advance
    BPF_chan_reldB_lvls_postig65(ix) = 10*log10(mean(chan_signal(1:valid_len).^2)); %% ACTUAL band powers, AFTER application of IG65
    BPFop_post = BPFop_post + chan_signal; %% recombined filterbank signal, AFTER application of IG65
    geo_cfs(ix) = sqrt( edges(ix)*edges(ix+1) );
end
%%[Pxx,F] = pwelch(X,WINDOW,NOVERLAP,F,Fs)
[Ppre, Fpre]   = pwelch(BPFop_pre,hamming(Npsd),Npsd/2,[],fs);
[RecombinedBPF_dBpre] = integrate_band_powers(Fpre, Ppre, edges); %% recombined filterbank signal,actual band powers, BEFORE application of IG65
RecombinedBPF_dBpre = RecombinedBPF_dBpre - psd_scaledB; %% referenced back to original LTASS noise with unity RMS in time 
dBpre_correct = chan_reldB_lvls - RecombinedBPF_dBpre ; %% NOT USED :
[Ppost, Fpost] = pwelch(BPFop_post,hamming(Npsd),Npsd/2,[],fs);
[RecombinedBPF_dBpost] = integrate_band_powers(Fpost, Ppost, edges);
RecombinedBPF_dBpost = RecombinedBPF_dBpost - psd_scaledB; %% referenced back to original LTASS noise with unity RMS in time 
dBpost_correct = chan_reldB_lvls_postig65 -  RecombinedBPF_dBpost; %% NOT USED : recombined filterbank signal, actual band powers, AFTER application of IG65


