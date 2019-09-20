function [X_out_RxFI , max_gain_prescript, freq_in] = fixedPointTesting(calib_bpfs, X_sweep, recombGain, ig_eq, delayFix, max_gain_prescript)
%%
%#codegen

%% Testing the Simulation with a series of Frequency Sweeps
%clear;
%close all;


NChans = 5;
% convert numbers to fixed points
W = 32;
F = 28;
Fs = 48000;
X_thresh = 1*10^(0.05*(0-85));
X_high = 1;

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
ig_eqFI = fi(ig_eq, 1, 2*W, W, Fm);
delayFixFI = fi(delayFix, 1, W, 0, Fm);


fMin = 100; %Hz
fMax = 10000; %Hz

Ts = 1/Fs;
tt = 0:Ts:4;

deltaF = (fMax - fMin)/tt(end);
freq_in = fMin +  deltaF*tt;
spec_size = 1024;
% [presz, ~] = freqz(double(ig_eqFI),1,spec_size,Fs);
% chfir_len = calib_bpfs(1,:);



spec_size = 1024;
hold off;

%% predeclarations
G_ideal = zeros(length(tt), 5);
Comp_Ratio = zeros(6,5);
X_out_Rx = zeros(6, length(tt));
bpz = zeros(1,spec_size);
%%
X_out = zeros(6,length(tt));



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
max_gain_prescriptFI = fi(max_gain_prescript, 1, W, F, Fm);

spec_size = 1024;
hold off;
for vol = 1:6
    
    for ix = 1:NChans
%         [bpz, ~] = freqz(calib_bpfs(2:chfir_len(ix)+1, ix), 1,spec_size, Fs);
%         total_response = abs(presz).*abs(bpz);
%         max_gain_prescript(ix) = max(total_response);
        %[bpR, ~] = freqz(calib_bpfs(2:chfir_len+1, ix), 1, freq_in, Fs);
        
        % identify input going into compression
        X_Chan_temp = filter(calib_bpfsFI(2:650,ix)', 1, X_sweepFI(vol,:));
        X_Chan = fi(X_Chan_temp(1:length(tt)), 1, W, F, Fm);
%        X_Chan = Amplitudes(vol).*abs(bpR);

        % apply correction gain
        X_Chan = X_Chan.*recombGainFI(ix);
        
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
            (double(X_Chan_in), X_high, X_thresh, X_high, double(max_gain_prescriptFI(ix)) );
        
        % If G_ideal(:,ix) is a NaN, make it 1 instead
        nanFinder = find(G_ideal(:,ix) == NaN);
        G_ideal(nanFinder,ix) = 1;%Gain_Table(1, ix);
        
        % make G_ideal a fi
        G_idealFI = fi(G_ideal, 1, W, F, Fm);
        % apply compression gain
        X_Chan_out = X_Chan.*G_idealFI(:,ix)';
        
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
X_out_RxFI = fi(X_out_Rx, 1, W, F, Fm);

end