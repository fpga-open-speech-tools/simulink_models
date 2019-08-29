X_thresh = 1*10^(0.05*(0-85));
band1x = logspace(1, 5, 1001);

% assuming ig_eq and calib_bpfs are already calculated from
% update_channel_params

[bandpassResponse] = freqz(calib_bpfs(2:end,1), 1, band1x, Fs);
[prescriptResponse] = freqz(ig_eq, 1, band1x, Fs);

bpR = abs(bandpassResponse);
prR = abs(prescriptResponse);

X_in = [X_thresh, X_thresh*10, X_thresh*100, X_thresh*1000, 1]; %, X_thresh*100000];

[bpR(1,:)] = freqz(calib_bpfs(2:end,1), 1, band1x, Fs);
[bpR(2,:)] = freqz(calib_bpfs(2:end,2), 1, band1x, Fs);
[bpR(3,:)] = freqz(calib_bpfs(2:end,3), 1, band1x, Fs);
[bpR(4,:)] = freqz(calib_bpfs(2:end,4), 1, band1x, Fs);
[bpR(5,:)] = freqz(calib_bpfs(2:end,5), 1, band1x, Fs);

xpbpGain(1,:) = abs(bpR(1,:)).*prR;
xpbpGain(2,:) = abs(bpR(2,:)).*prR;
xpbpGain(3,:) = abs(bpR(3,:)).*prR;
xpbpGain(4,:) = abs(bpR(4,:)).*prR;
xpbpGain(5,:) = abs(bpR(5,:)).*prR;

max_gain_prescript(1) = max(xpbpGain(1,:));
max_gain_prescript(2) = max(xpbpGain(2,:));
max_gain_prescript(3) = max(xpbpGain(3,:));
max_gain_prescript(4) = max(xpbpGain(4,:));
max_gain_prescript(5) = max(xpbpGain(5,:));

Xp_True1 = X_in'*abs(bpR(1,:)); % for prescript first: X_in'*xpbpGain(1,:);
Xp_True2 = X_in'*abs(bpR(2,:));
Xp_True3 = X_in'*abs(bpR(3,:));
Xp_True4 = X_in'*abs(bpR(4,:));
Xp_True5 = X_in'*abs(bpR(5,:));

Band = 1; Vol = 1;
[G_out_band1(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True1(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
Vol = 2;
[G_out_band1(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True1(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
Vol = 3;
[G_out_band1(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True1(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
Vol = 4;
[G_out_band1(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True1(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
Vol = 5;
[G_out_band1(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True1(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
% Vol = 6;
% [G_out_band1(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True1(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));

Band = 2;
Vol = 1;
[G_out_band2(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True2(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
Vol = 2;
[G_out_band2(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True2(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
Vol = 3;
[G_out_band2(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True2(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
Vol = 4;
[G_out_band2(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True2(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
Vol = 5;
[G_out_band2(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True2(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
% Vol = 6;
% [G_out_band2(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True2(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));

 Band = 3;
Vol = 1;
[G_out_band3(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True3(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
Vol = 2;
[G_out_band3(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True3(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
Vol = 3;
[G_out_band3(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True3(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
Vol = 4;
[G_out_band3(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True3(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
Vol = 5;
[G_out_band3(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True3(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
% Vol = 6;
% [G_out_band3(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True3(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));

Band = 4;
Vol = 1;
[G_out_band4(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True4(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
Vol = 2;
[G_out_band4(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True4(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
Vol = 3;
[G_out_band4(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True4(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
Vol = 4;
[G_out_band4(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True4(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
Vol = 5;
[G_out_band4(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True4(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
% Vol = 6;
% [G_out_band4(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True4(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));

Band = 5;
Vol = 1;
[G_out_band5(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True5(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
Vol = 2;
[G_out_band5(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True5(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
Vol = 3;
[G_out_band5(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True5(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
Vol = 4;
[G_out_band5(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True5(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
Vol = 5;
[G_out_band5(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True5(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));
% Vol = 6;
% [G_out_band5(Vol,:)] = Populate_Band_Compression_Lookup_Gain_V2(Xp_True5(Vol,:),X_in(end),X_thresh, 1, max_gain_prescript(Band));

% Recombining Gain
recombGain = 10.^(0.05.*Calib_recomb_dBpost);
G_out_band1 = G_out_band1.*recombGain(1).*prR;
G_out_band2 = G_out_band2.*recombGain(2).*prR;
G_out_band3 = G_out_band3.*recombGain(3).*prR;
G_out_band4 = G_out_band4.*recombGain(4).*prR;
G_out_band5 = G_out_band5.*recombGain(5).*prR;

figure(18);
hold off;
semilogx(band1x, 20*log10(prR));
hold on;

Vol = 1;
y_out(Vol,:)  = Xp_True1(Vol,:).*G_out_band1(Vol,:)  + Xp_True2(Vol,:).*G_out_band2(Vol,:)  + Xp_True3(Vol,:).*G_out_band3(Vol,:)  + Xp_True4(Vol,:).*G_out_band4(Vol,:) +  Xp_True5(Vol,:).*G_out_band5(Vol,:);
semilogx(band1x, 20*log10(y_out(Vol,:)) + 85);

Vol = 2;
y_out(Vol,:)  = Xp_True1(Vol,:).*G_out_band1(Vol,:)  + Xp_True2(Vol,:).*G_out_band2(Vol,:)  + Xp_True3(Vol,:).*G_out_band3(Vol,:)  + Xp_True4(Vol,:).*G_out_band4(Vol,:) +  Xp_True5(Vol,:).*G_out_band5(Vol,:);
semilogx(band1x, 20*log10(y_out(Vol,:)) + 85);

Vol = 3;
y_out(Vol,:)  = Xp_True1(Vol,:).*G_out_band1(Vol,:)  + Xp_True2(Vol,:).*G_out_band2(Vol,:)  + Xp_True3(Vol,:).*G_out_band3(Vol,:)  + Xp_True4(Vol,:).*G_out_band4(Vol,:) +  Xp_True5(Vol,:).*G_out_band5(Vol,:);
semilogx(band1x, 20*log10(y_out(Vol,:)) + 85);

Vol = 4;
y_out(Vol,:)  = Xp_True1(Vol,:).*G_out_band1(Vol,:)  + Xp_True2(Vol,:).*G_out_band2(Vol,:)  + Xp_True3(Vol,:).*G_out_band3(Vol,:)  + Xp_True4(Vol,:).*G_out_band4(Vol,:) +  Xp_True5(Vol,:).*G_out_band5(Vol,:);
semilogx(band1x, 20*log10(y_out(Vol,:)) + 85);

Vol = 5;
y_out(Vol,:)  = Xp_True1(Vol,:).*G_out_band1(Vol,:)  + Xp_True2(Vol,:).*G_out_band2(Vol,:)  + Xp_True3(Vol,:).*G_out_band3(Vol,:)  + Xp_True4(Vol,:).*G_out_band4(Vol,:) +  Xp_True5(Vol,:).*G_out_band5(Vol,:);
semilogx(band1x, 20*log10(y_out(Vol,:)) + 85);
% 
% Vol = 6;
% y_out(Vol,:)  = Xp_True1(Vol,:).*G_out_band1(Vol,:)  + Xp_True2(Vol,:).*G_out_band2(Vol,:)  + Xp_True3(Vol,:).*G_out_band3(Vol,:)  + Xp_True4(Vol,:).*G_out_band4(Vol,:) +  Xp_True5(Vol,:).*G_out_band5(Vol,:);
% semilogx(band1x, 20*log10(y_out(Vol,:)) + 85);

axis([60 20000 -20 100]);
title('Output as a function of Input Frequency and Volume (0, 20, 40, 60, 85 dBA)');
xlabel('Frequency (Hz)'); ylabel('Output Volume (dBA)');
semilogx(band1x, 85*ones(1,length(band1x)), 'k--');
legend('Prescription Gain', '0 dBA in', '20 dBA in', '40 dBA in', '60 dBA in', '85 dBA in', '85 dBA ceiling'); %'100 dBA test', '85 dBA ceiling');

figure(19);
hold off;
semilogx(band1x, xpbpGain(1,:));
hold on;
semilogx(band1x, xpbpGain(2,:));
semilogx(band1x, xpbpGain(3,:));
semilogx(band1x, xpbpGain(4,:));
semilogx(band1x, xpbpGain(5,:));

%% Plot Ideal, Floor, and Interpolated Gains in Lookup Table
min_thresh_dB = 0;
Fs = 48000;
X_high = 1; % Maximum input
ref_dB = 85; X_ref = 1; % Define a reference point in X and its dBA value

% Make some values for an "ideal" lookup table with 10001 log10 spaced
% points
X_in_Ideal = logspace(-6, 0, 10001);
for ix = 1:NChans
    [G_lookup_out(ix,:), Comp_Ratio(ix)] = Populate_Band_Compression_Lookup_Gain_V2 ...
        (X_in_Ideal, X_high, X_thresh, X_high, max_gain_prescript(ix) );
end

% Get values for lookup table
X_in_Sim = zeros(1, 64);
addr = 1;
for NShifts = 15:-1:0
    for M = 0:3
        X_in_Sim(addr) = 2^(-NShifts) + M*2^(-2-NShifts);
        addr = addr+1;
    end
end
for ix = 1:NChans
   [Gain_Table(:,ix), Comp_Ratio_Sim(ix)] ...
     = Populate_Band_Compression_Lookup_Gain_V2 ...
    (X_in_Sim, X_high, X_thresh, X_high, max_gain_prescript(ix));
end
% Find lookup addresses for each point in X_in_Ideal
for it = 1:length(X_in_Ideal)
    x_addr(it) = 64;
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
for ix = 1:NChans
    y_low(ix,:)  = Gain_Table(x_addr,ix)';
    y_high(ix,:) = Gain_Table(x_addr+1,ix)';
    slope(ix,:)  = ( y_high(ix,:)-y_low(ix,:) ) ./ (x_high - x_low);
    Gain_Interpolated(:,ix) = slope(ix,:).*(X_in_Ideal-x_low)+y_low(ix,:);
    % percent error: obt-exp / exp
    errorFloor(ix,:) = (G_lookup_out(ix,:)-y_low(ix,:))./G_lookup_out(ix,:);
    errorInter(ix,:) = (G_lookup_out(ix,:)-Gain_Interpolated(:,ix)')./G_lookup_out(ix,:);
    maxFloorErr(ix) = 100*max(abs(errorFloor(ix, 2870:9839)));
    maxInterErr(ix) = 100*max(abs(errorInter(ix, 2870:9839)));
end


maxFloorErrTot = max(maxFloorErr);
maxInterErrTot = max(maxInterErr);


% plot ideal gain table as a function of volume for each band
% plot lookup gain table for each band
% plot linearly interpolated gain values for each band

% % band 1
% for ix = 1:NChans
ix = 1;
	figure(22);
    subplot(2,1,1); plot(X_in_Ideal, G_lookup_out(ix,:));
    hold on;
    %plot(X_in_Ideal, errorFloor(1,:));
    plot(X_in_Ideal, Gain_Interpolated(:,ix));
    axis([X_thresh 1 0 1.1]);
    title(sprintf('Band %d, Gp = 2.05', ix)); xlabel('X input'); ylabel('Compression Gain Applied')
    legend('Ideal Values', 'LogScale Lookup - Interpolation');
    hold off;

    subplot(2,1,2); loglog(X_in_Ideal, G_lookup_out(ix,:));
    hold on;
    %loglog(X_in_Ideal, y_low(1,:));
    loglog(X_in_Ideal, Gain_Interpolated(:,ix));
    axis([X_thresh 1 0.4 1.1]);
    title(sprintf('Max error above threshold: %0.2f%%', maxInterErr(ix)));
    xlabel('X input'); ylabel('Compression Gain Applied');
    legend('Ideal Values', 'LogScale Lookup - Interpolation');
    hold off;
% 
%     figure(ix*2)
%     subplot(2,1,1);
%     hold off;
%     plot(X_in_Ideal, G_lookup_out(ix,:));
%     hold on;
%     %plot(X_in_Ideal, errorFloor(1,:));
%     plot(X_in_Ideal, Gain_Interpolated(:,ix));
%     plot(X_in_Ideal, errorInter(ix,:));
%     axis([X_thresh 1 0 1.1]);
%     title('Band 1, Gp = 2.05'); xlabel('X input'); ylabel('Compression Gain Applied')
%     legend('Ideal Values', 'LogScale Lookup - Interpolation', 'Error');
%     hold off;
% 
%     subplot(2,1,2); 
%     hold off;
%     loglog(X_in_Ideal, G_lookup_out(ix,:));
%     hold on;
%     %loglog(X_in_Ideal, y_low(1,:));
%     loglog(X_in_Ideal, Gain_Interpolated(:,ix));
%     axis([X_thresh 1 0.01 1.1]);
%     title(sprintf('Max error above threshold: %0.2f%%', maxInterErr(ix)));
%     xlabel('X input'); ylabel('Compression Gain Applied')
%     legend('Ideal Values', 'LogScale Lookup - Interpolation');
%     hold off;
% 
% end

figure(11)
hold off;
for ix = 1:5
    loglog(X_in_Ideal, G_lookup_out(ix,:));
    hold on;
    loglog(X_in_Ideal, Gain_Interpolated(:,ix)); 
    loglog(X_in_Sim, Gain_Table(:,ix), '.');
end
hold off;
title('Error of All Channels'); 
axis([X_thresh 1 0.01 1.1]);
xlabel('Xinput'); ylabel('Compression Gain Applied');