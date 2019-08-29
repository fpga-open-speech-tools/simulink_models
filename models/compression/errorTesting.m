%% Testing the Simulation with a series of Frequency Sweeps
%clear;
%close all;
X_thresh = 1*10^(0.05*(0-85));

% Amplitudes of 0 dBA ,    20 dBA  ,   40 dBA    ,   60 dBA     ,    80 dBA, 85 dBA
Amplitudes = [X_thresh, X_thresh*10, X_thresh*100, X_thresh*1000, X_thresh*10000, 1]; %, X_thresh*100000];

fMin = 100; %Hz
fMax = 10000; %Hz
Fs = 48000; %Hz
Ts = 1/Fs;
tt = 0:Ts:4;
deltaF = (fMax - fMin)/tt(end);
X_sweep = Amplitudes'*sin(2*pi*(fMin*tt +  0.5*deltaF*tt.*tt)) ;

%% With Simulink Data:
load('SweepSimOutput.mat');
vol = 1;

[PKS1, LOC1] = findpeaks(abs(X_out_Sweep_Sim(vol,:)));
vol = 2;
[PKS2, LOC2] = findpeaks(abs(X_out_Sweep_Sim(vol,:)));
[PKS3, LOC3] = findpeaks(abs(X_out_Sweep_Sim(3,:)));
[PKS4, LOC4] = findpeaks(abs(X_out_Sweep_Sim(4,:)));
[PKS5, LOC5] = findpeaks(abs(X_out_Sweep_Sim(5,:)));
[PKS6, LOC6] = findpeaks(abs(X_out_Sweep_Sim(6,:)));
figure(1)
% semilogx(tt(LOC1), 20*log10(PKS1)+85);
% hold on;
% semilogx(tt(LOC2), 20*log10(PKS2)+85);
% semilogx(tt(LOC3), 20*log10(PKS3)+85);
% semilogx(tt(LOC4), 20*log10(PKS4)+85);
% semilogx(tt(LOC5), 20*log10(PKS5)+85);
% semilogx(tt(LOC6), 20*log10(PKS6)+85);
% axis([60 20000 -20 100]);
freq_in = fMin +  deltaF*tt;
% hold off
% semilogx(freq_in(LOC1), 20*log10(PKS1)+85);
% hold on;
% semilogx(freq_in(LOC2), 20*log10(PKS2)+85);
% semilogx(freq_in(LOC3), 20*log10(PKS3)+85);
% semilogx(freq_in(LOC4), 20*log10(PKS4)+85);
% semilogx(freq_in(LOC5), 20*log10(PKS5)+85);
% semilogx(freq_in(LOC6), 20*log10(PKS6)+85);
axis([60 20000 -20 100]);
[PKS11, LOC11] = findpeaks(PKS1);
[PKS22, LOC22] = findpeaks(PKS2);
[PKS33, LOC33] = findpeaks(PKS3);
[PKS44, LOC44] = findpeaks(PKS4);
[PKS55, LOC55] = findpeaks(PKS5);
[PKS66, LOC66] = findpeaks(PKS6);
hold off
semilogx(freq_in(LOC1(LOC11)), 20*log10(PKS11)+85);
hold on;
semilogx(freq_in(LOC2(LOC22)), 20*log10(PKS22)+85);
semilogx(freq_in(LOC3(LOC33)), 20*log10(PKS33)+85);
semilogx(freq_in(LOC4(LOC44)), 20*log10(PKS44)+85);
semilogx(freq_in(LOC5(LOC55)), 20*log10(PKS55)+85);
semilogx(freq_in(LOC6(LOC66)), 20*log10(PKS66)+85);
axis([60 20000 -20 100]);
title('Frequency Sweep Test: 100 Hz to 10 kHz'); 
ylabel('Simulink Output Volume');
xlabel('Input Frequency');
legend('0 dBA in', '20 dBA in', '40 dBA in', '60 dBA in', '85 dBA in');
axis([60 20000 -20 100]);
legend('0 dBA in', '20 dBA in', '40 dBA in', '60 dBA in', '80 dBA in', '85 dBA in');
%%
% prepare constants
NChans = 5;
[chan_cfs, chan_thrs, t_atts, t_rels] ...
   = InitializeCompressionSettings(NChans);

insrt_frqs = [125, 250, 500, 1000, 2000, 3000, 4000, 6000, 8000, 10000 ]; %% decimal values
insrt_gns = [0 3 5 10 15 20 25 30 30 30]; %% prescribed dB for 65 dB input
%insrt_gns = 5*ones(1,length(insrt_frqs));  %no prescription
n_insrts = length(insrt_gns);
dBA65 = 0.1;
UPPER_FREQ_LIM = min(11e3, 0.90*Fs/2);
[ig_eq, calib_bpfs, dig_chan_lvl_0dBgain, dig_chan_dBthrs, Calib_recomb_dBpost] ...
    = update_channel_params(Fs, NChans, chan_cfs, chan_thrs, insrt_frqs, insrt_gns, ...
    dBA65, UPPER_FREQ_LIM, 6, 1, 1, 1) ;  %% calculates channel edge frequencies, generates expected band levels for LTASS SWN to calibrate compressors & filterbank

recombGain = 10.^(0.05.*Calib_recomb_dBpost);

X_high = 1;

spec_size = 1024;
[presz, ~] = freqz(ig_eq,1,spec_size,Fs);

% prepare  delay constants
Initialize_Delay_Values;    
% model the compression wrapper for each vol and band, without the table
% size limitation
%%
X_out = zeros(6,length(tt));
[presz, ~] = freqz(ig_eq,1,spec_size,Fs);
[prR, ~] = freqz(ig_eq, 1, freq_in, Fs);
chfir_len = calib_bpfs(1,:);



% convert numbers to fixed points
W = 32;
F = 28;

Fm = fimath('RoundingMethod','Floor',...
    'OverflowAction','Wrap',...
    'ProductMode','SpecifyPrecision',...
    'ProductWordLength',W,...
    'ProductFractionLength',F,...
    'SumMode','SpecifyPrecision',...
    'SumWordLength',W,...
    'SumFractionLength',F);


calib_bpfsFI = fi(calib_bpfs, 1, W, F, Fm);
X_sweepFI = fi(X_sweep, 1, W, F, Fm);
recombGainFI = fi(recombGain, 1, W, F, Fm);

spec_size = 1024;
hold off;
for vol = 1:6
    
    for ix = 1:NChans
%         [bpz, ~] = freqz(calib_bpfs(2:chfir_len(ix)+1, ix), 1,spec_size, Fs);
%         total_response = abs(presz).*abs(bpz);
%         max_gain_prescript(ix) = max(total_response);
        %[bpR, ~] = freqz(calib_bpfs(2:chfir_len+1, ix), 1, freq_in, Fs);
        
        % identify input going into compression
        X_Chan_temp = filter(calib_bpfs(2:650,ix)', 1, X_sweep(vol,:));
        X_Chan = X_Chan_temp(1:length(tt));
%        X_Chan = Amplitudes(vol).*abs(bpR);

        % apply correction gain
        X_Chan = X_Chan.*recombGain(ix);
        
        % deal with delay by padding startup, and clearing the excess
        X_Chan(1:length(tt)) = [zeros(1,delayFix(ix)+3) X_Chan(1:(length(tt)-(delayFix(ix)+3)))];
        
        %X_Chan = X_Chan(1:length(tt));
        
        %Find wherever X_Chan is less than threshold, we want this to have
        %a gain of 1, instead of amplification
        X_Chan_low = find(abs(X_Chan) <= X_thresh);
        X_Chan_in = X_Chan;
        X_Chan_in(X_Chan_low) = X_thresh;
        
        % calculate the gain applied before envelope
        [G_ideal(:,ix), Comp_Ratio(vol,ix)] = Populate_Band_Compression_Lookup_Gain_V2 ...
            (X_Chan_in, X_high, X_thresh, X_high, max_gain_prescript(ix) );
        
        % If G_ideal(:,ix) is a NaN, make it 1 instead
        nanFinder = find(G_ideal(:,ix) == NaN);
        G_ideal(nanFinder,ix) = 1;%Gain_Table(1, ix);
        
        % apply compression gain
        X_Chan_out = X_Chan.*G_ideal(:,ix)';
        
        % sum the channel to this volume's output
        X_out(vol,:) = X_out(vol,:) + X_Chan_out;
        %figure(6*vol+ix);
        %plot(tt, G_ideal(:,ix));
        %title(sprintf('Vol %d Chan %d Compression Gain', vol, ix));
    end
    % X_out(:,1) = 0; % get rid of some NaN's 
    % put this volume through the Rx FIR
    %X_out_Rx_temp = X_out(vol,:).*abs(prR);
    X_out_Rx_temp = filter(ig_eq, 1, X_out(vol,:));
    X_out_Rx(vol,:) = X_out_Rx_temp(1:length(tt));
    
    % apply clipping
    tooHigh = find(X_out_Rx(vol,:) > 1);
    tooLow = find(X_out_Rx(vol,:) < -1);
    X_out_Rx(vol,tooHigh) = 1;
    X_out_Rx(vol,tooLow) = -1;
    
    %figure(6*vol+ix);
    %plot(freq_in, X_out_Rx(vol,:));
    %hold on;
    %title(sprintf('Matlab, Volume %d', vol));
    
    %figure(6*vol+ix+1);
    %plot(freq_in, X_out_Sweep_Sim(vol,:));
    %title(sprintf('Sim, Volume %d', vol));
    
end
%%
figure(2);
hold off
semilogx(freq_in(LOC1(LOC11)), 20*log10(abs(double(X_out_RxF(1, LOC1(LOC11)))) )+85);
hold on;
semilogx(freq_in(LOC2(LOC22)), 20*log10(abs(double(X_out_RxF(2, LOC2(LOC22)))) )+85);
semilogx(freq_in(LOC3(LOC33)), 20*log10(abs(double(X_out_RxF(3, LOC3(LOC33)))) )+85);
semilogx(freq_in(LOC4(LOC44)), 20*log10(abs(double(X_out_RxF(4, LOC4(LOC44)))) )+85);
semilogx(freq_in(LOC5(LOC55)), 20*log10(abs(double(X_out_RxF(5, LOC5(LOC55)))) )+85);
semilogx(freq_in(LOC6(LOC66)), 20*log10(abs(double(X_out_RxF(6, LOC6(LOC66)))) )+85);
axis([60 20000 -20 100]);

title('Expected Frequency Response: 100 Hz to 10 kHz'); 
ylabel('Expected Output Volume');
xlabel('Input Frequency');
legend('0 dBA in', '20 dBA in', '40 dBA in', '60 dBA in', '80 dBA in', '85 dBA in');

%% Find RMS of Frequency Response Error
errResponse1 = (abs(double(X_out_RxF(1, LOC1(LOC11))))-PKS11)./PKS11;
errResponse2 = (abs(double(X_out_RxF(2, LOC2(LOC22))))-PKS22)./PKS22;
errResponse3 = (abs(double(X_out_RxF(3, LOC3(LOC33))))-PKS33)./PKS33;
errResponse4 = (abs(double(X_out_RxF(4, LOC4(LOC44))))-PKS44)./PKS44;
errResponse5 = (abs(double(X_out_RxF(5, LOC5(LOC55))))-PKS55)./PKS55;
errResponse6 = (abs(double(X_out_RxF(6, LOC6(LOC66))))-PKS66)./PKS66;
errRMS1 = rms(errResponse1(25:end)); %ignore startup response of simulink
errRMS2 = rms(errResponse2(25:end));
errRMS3 = rms(errResponse3(25:end));
errRMS4 = rms(errResponse4(25:end));
errRMS5 = rms(errResponse5(25:end));
errRMS6 = rms(errResponse6(25:end));
figure(4);
hold off
%semilogx(freq_in(LOC1(LOC11)), 20*log10(abs(errResponse1)));
%hold on;
%semilogx(freq_in(LOC2(LOC22)), 20*log10(abs(errResponse2)));
%semilogx(freq_in(LOC3(LOC33)), 20*log10(abs(errResponse3)));
%semilogx(freq_in(LOC4(LOC44)), 20*log10(abs(errResponse4)));
%semilogx(freq_in(LOC5(LOC55)), 20*log10(abs(errResponse5)));
semilogx(freq_in(LOC6(LOC66)), 20*log10(abs(errResponse6)));
title('Error of Response'); 
ylabel('dB Error');
xlabel('Input Frequency');
%axis([250 10000 -1 1]);
%axis([250 10000 -1 1]);
legend('0 dBA in', '20 dBA in', '40 dBA in', '60 dBA in', '80 dBA in', '85 dBA in');

%% Comparing results to powers of 2
power2Table = 2.^(-1:-1:-64);
errorPow2Table = ones(1,length(PKS66));
for ix = 25:length(PKS66)-1
    while(errResponse6(ix) < power2Table(errorPow2Table(ix) ) && errorPow2Table(ix) < 64)
        errorPow2Table(ix) = errorPow2Table(ix)+1;
    end
end
figure(2);
semilogx(freq_in(LOC6(LOC66(25:11731))), errorPow2Table(25:end), '*');
xlabel('Frequency (Hz)'); ylabel('Fractional Bit Precision');
%axis([10 100000 0 32]);
title('Fractional Bit Precision of Frequency Sweep Test');


%% Finding out error as a function of table size, given a compression ratio of band 5 == 1.5527 (max error)
%clear;
NChans = 5;
max_gain_prescript = [2.049911158344894,3.612302813380825,6.040251457390358,16.771362985970380,32.576937607356640];
X_thresh = 1*10^(0.05*(0-85));
min_thresh_dB = 0;
Fs = 48000;
X_high = 1; % Maximum input
ref_dB = 85; X_ref = 1; % Define a reference point in X and its dBA value

% Make some values for an "ideal" lookup table with a lot of log10 spaced
% points
X_in_Ideal = logspace(-6, 0, 100001);
tooLow = find(X_in_Ideal < X_thresh);
X_in_Ideal(tooLow) = [];
tooHigh = find(X_in_Ideal>= X_high);
X_in_Ideal(tooHigh) = [];
X_in_Ideal(end) = [];   % get rid of last point to avoid indexing errors
for ix = NChans %1:NChans
    [G_lookup_out, Comp_Ratio(ix)] = Populate_Band_Compression_Lookup_Gain_V2 ...
        (X_in_Ideal, X_high, X_thresh, X_high, max_gain_prescript(ix) );
end

for MBits = 4
    % Get values for lookup table
    X_in_Sim = zeros(1, 16*2^MBits);
    X_Sim_Length(MBits+1) = length(X_in_Sim);
    addr = 1;
    for NShifts = 15:-1:0
        for M = 0:2^(MBits)-1
            X_in_Sim(addr) = 2^(-NShifts) + M*2^(-MBits-NShifts);
            addr = addr+1;
        end
    end
    for ix = NChans%1:NChans
       [Gain_Table_M, Comp_Ratio_Sim(ix)] ...
         = Populate_Band_Compression_Lookup_Gain_V2 ...
        (X_in_Sim, X_high, X_thresh, X_high, max_gain_prescript(ix));
    end
    % Find lookup addresses for each point in X_in_Ideal
    for it = 1:length(X_in_Ideal)
        x_addr(it) = X_Sim_Length(MBits+1);
        X_Shift = X_in_Ideal(it);
        while(X_Shift < X_in_Sim(x_addr(it)) && x_addr(it) ~= 1)
            x_addr(it) = x_addr(it) - 1;
        end
        if(x_addr(it)==0)
            x_addr(it) = 1;
        end
    end
    % Get values for linear interpolation of X_in_Ideal
    % x_low(it) = X_in_Sim(x_addr(it)); x_high(it) = x_low(it)+1
    x_low  = X_in_Sim(x_addr);
    x_high = X_in_Sim(x_addr+1);
    for ix = NChans %1:NChans
        y_low_M  = Gain_Table_M(x_addr);
        y_high_M = Gain_Table_M(x_addr+1);
        slope    = ( y_high_M-y_low_M ) ./ (x_high - x_low);
        Gain_Interpolated = slope.*(X_in_Ideal-x_low)+y_low_M;
        % percent error: obt-exp / exp
        %errorFloor = (G_lookup_out-y_low_M)./G_lookup_out;
        errorInter = (G_lookup_out-Gain_Interpolated)./G_lookup_out;
        %maxFloorErr(MBits+1) = 100*max(abs(errorFloor));
        maxInterErr(MBits+1) = max(abs(errorInter));
    end



end
    %maxFloorErrTot = max(maxFloorErr);
    maxInterErrTot = max(maxInterErr);
    
figure(1);

loglog(X_Sim_Length, maxInterErr, '*');

%% Comparing results to powers of 2
power2Table = 2.^(-1:-1:-32);
errorPow2Table = ones(1,MBits+1);
for ix = 1:MBits+1
    while(maxInterErr(ix) < power2Table(errorPow2Table(ix) ) )
        errorPow2Table(ix) = errorPow2Table(ix)+1;
    end
end
figure(2);
semilogx(X_Sim_Length, errorPow2Table, '*');
xlabel('Lookup Table Length (In Powers of 2), per Channel'); ylabel('Fractional Bit Precision');
axis([10 100000 0 32]);
title('Fractional Bit Precision as a Function of Table Size, Fixed Compression Ratio of 1.553');

%% Now to find error as a function of compression ratio. Of course, this is truly
% a function of max_gain_prescript, which determines the compression ratio,
% and likely will never be above 60 or below 0.
clear; 
prescript_gain_test = 10.^(0:0.1:2);
X_thresh = 1*10^(0.05*(0-85));
min_thresh_dB = 0;
Fs = 48000;
X_high = 1; % Maximum input
ref_dB = 85; X_ref = 1; % Define a reference point in X and its dBA value

% Make some values for an "ideal" lookup table with a lot of log10 spaced
% points
X_in_Ideal = logspace(-6, 0, 100001);
tooLow = find(X_in_Ideal < X_thresh);
X_in_Ideal(tooLow) = [];
tooHigh = find(X_in_Ideal>= X_high);
X_in_Ideal(tooHigh) = [];
X_in_Ideal(end) = [];   % get rid of last point to avoid indexing errors
for ix = 1:length(prescript_gain_test) %1:NChans
    [G_lookup_out(ix,:), Comp_Ratio(ix)] = Populate_Band_Compression_Lookup_Gain_V2 ...
        (X_in_Ideal, X_high, X_thresh, X_high, prescript_gain_test(ix) );
end

MBits = 5;
% Get values for lookup table, assume size 
X_in_Sim = zeros(1, 16*2^MBits);
X_Sim_Length = length(X_in_Sim);
addr = 1;
for NShifts = 15:-1:0
    for M = 0:2^(MBits)-1
        X_in_Sim(addr) = 2^(-NShifts) + M*2^(-MBits-NShifts);
        addr = addr+1;
    end
end
for ix = 1:length(prescript_gain_test)%1:NChans
    %populate this Rx-gain's table
    [Gain_Table_M(ix,:), Comp_Ratio_Sim(ix)] ...
     = Populate_Band_Compression_Lookup_Gain_V2 ...
    (X_in_Sim, X_high, X_thresh, X_high, prescript_gain_test(ix));

    % Find lookup addresses for each point in X_in_Ideal
    for it = 1:length(X_in_Ideal)
        x_addr(it) = X_Sim_Length;
        X_Shift = X_in_Ideal(it);
        while(X_Shift < X_in_Sim(x_addr(it)) && x_addr(it) ~= 1)
            x_addr(it) = x_addr(it) - 1;
        end
        if(x_addr(it)==0)
            x_addr(it) = 1;
        end
    end
    % Get values for linear interpolation of X_in_Ideal
    % x_low(it) = X_in_Sim(x_addr(it)); x_high(it) = x_low(it)+1
    x_low  = X_in_Sim(x_addr);
    x_high = X_in_Sim(x_addr+1);
    y_low_M  = Gain_Table_M(ix, x_addr);
    y_high_M = Gain_Table_M(ix, x_addr+1);
    slope    = ( y_high_M-y_low_M ) ./ (x_high - x_low);
    Gain_Interpolated = slope.*(X_in_Ideal-x_low)+y_low_M;
    % percent error: obt-exp / exp
    %errorFloor = (G_lookup_out-y_low_M)./G_lookup_out;
    errorInter = (G_lookup_out(ix,:)-Gain_Interpolated)./G_lookup_out(ix,:);
    %maxFloorErr(MBits+1) = 100*max(abs(errorFloor));
    rxErr(ix) = max(abs(errorInter));
   

end

%maxFloorErrTot = max(maxFloorErr);
rxErrMax = max(rxErr);

figure(3);

plot(prescript_gain_test, rxErr);

%% Comparing results to powers of 2
power2Table = 2.^(-1:-1:-64);
errorPow2Table = ones(1,length(prescript_gain_test));
for ix = 1:length(prescript_gain_test)
    while(rxErr(ix) < power2Table(errorPow2Table(ix) ) )
        errorPow2Table(ix) = errorPow2Table(ix)+1;
    end
end
figure(4);
plot(20*log10(prescript_gain_test), errorPow2Table, '*');
xlabel('Prescription Gain (dB)'); ylabel('Fractional Bit Precision of Table');
%axis([ 0 32]);
title('Fractional Bit Precision as a Function of Band Prescription Gain, Fixed Table Size 512');

figure(5);
semilogx(Comp_Ratio_Sim, errorPow2Table, 'r*');
xlabel('Compression Ratio'); ylabel('Fractional Bit Precision of Table');
%axis([ 0 32]);
title('Fractional Bit Precision as a Function of Compression Ratio, Fixed Table Size 512');

