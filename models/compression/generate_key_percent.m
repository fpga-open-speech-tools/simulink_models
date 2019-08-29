%%% to track a certain percentage of frames in order to get measure of rms, comments deactivated for ais-sim software
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% wavlevel.m to measure the rms of a 16 kHz monaural wav file and return mean and stddev
%%%%%%%%%% adaptively sets threshold after looking at histogram of whole recording
function [key, used_thr_dB] = generate_key_percent(sig, thr_dB, winlen);
%% NB threshold is in dB, if it has length==2, then second value is percentage of frames to track,
%% although it overrules threshold, threshold still gives an idea as to how fa rdown the histogram should be generated

if winlen ~= floor(winlen) %%% whoops on fractional indexing: 7-March 2002
    winlen = floor(winlen);
    %%    fprintf(1,'\nGenerate_key_percent:\tWindow length must be integer: now %d',winlen);
end

siglen = length(sig);
%% new Dec 2003. Possibly track percentage of frames rather than fixed threshold
if length(thr_dB) > 1,  track_percent = 1; percent2track = thr_dB(2); fprintf(1,'\nGenerate_key_percent:\ttracking %.1f percentage of frames ', percent2track);
else,                   track_percent = 0; fprintf(1,'\nGenerate_key_percent:\ttracking fixed threshold');
end
expected = thr_dB(1); %%%% expected threshold
non_zero = 10.^((expected-30)/10);  %% put floor into histogram distribution, a fair way below that to be used for threshold

nframes = 0;
totframes = floor(siglen/winlen);
every_dB = zeros(1,totframes);

for ix = 1:winlen:(winlen*totframes)
    nframes = nframes + 1;
    this_sum = sum( sig(ix:(ix+winlen-1)) .^2 ); %%%%% sum of squares
    every_dB(nframes) = 10*log10(non_zero + this_sum/winlen);
end %%%% of ix loop
every_dB = every_dB(1:nframes);  %%%% from now on save only those analysed
[nbins, lvls] = hist(every_dB(1:nframes),140);  %%%%% Dec 2003, was 100 to give about a 0.5 dB quantising of levels

if track_percent %%% new 1-Dec-2003
    inactive_bins = (100-percent2track)*nframes/100; %% MINIMUM number of bins to use
    nlvls = length(lvls);
    inactive_ix = 0; ixcnt = 0;
    for ix = 1:nlvls
        inactive_ix = inactive_ix + nbins(ix);
        if inactive_ix > inactive_bins, break; else, ixcnt = ixcnt+1; end;
    end
    if ix == nlvls, error('\nGenerate_key_percent:\tErrrrr, no levels to count');
    elseif ix == 1 %%fprintf(1,'\nGenerate_key_percent:\tCounted every bin.........');
    end
    expected = lvls(max(1,ixcnt)); %% set new threshold conservatively to include more bins than desired (rather than fewer)
end
used_thr_dB = expected; %% for feeding back to calling program

%%%%% histogram should produce a two-peaked curve: thresh should be set somewhere in valley
%%%%% between the two peaks, actually set threshold a bit above that, as it heads for main peak
frame_index = find(every_dB >= expected);
valid_frames = length(frame_index);
key = zeros(1,valid_frames*winlen);
%%%%% convert frame numbers into indices for sig   
for ix = 1:valid_frames
    meas_span = 1+((frame_index(ix)-1)*winlen):(frame_index(ix))*winlen;
    key_span  = 1+((ix-1)*winlen):ix*winlen;
    if min(key_span) < 1
        error('key_span: Trapped erroneous indexing %d:%d: consult MAS',1+((ix-1)*winlen),ix*winlen);
    end
    key(key_span) = meas_span;
end
