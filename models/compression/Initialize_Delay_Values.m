%Initialize_Delay_Values

% Find maxiumum delay of all bandpass filters
delays = floor(calib_bpfs(1,:)/2);
maxDelay = max(delays);
delayFix = maxDelay-delays;