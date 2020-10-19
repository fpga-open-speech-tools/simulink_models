
close all

s1 = squeeze(signal_in.Data);
s2 = signal_out;

figure
subplot(3,1,1)
plot(s1)

subplot(3,1,2)
plot(s2)

str = ['Input and Output Signals;   FFT size = ' num2str(FFT_size)];
title(str)


%------------------------------------------
% Find latency
%------------------------------------------
switch filter_select
    case 1
        threshold = latency_threshold1;
    case 2
        threshold = latency_threshold2;
    case 3
        threshold = latency_threshold3;
    case 4
        threshold = latency_threshold4;
    otherwise
end
idx1 = find(s1 > threshold, 1, 'first');
[m,idx2]=max(s2(1:FFT_size*2));
latency = idx2-idx1


subplot(3,1,3)
z = zeros(latency,1);
plot([z; s1])
hold on
plot([s2; z])
str = ['Latency = ' num2str(latency) ' samples = ' num2str(latency*Ts*1000) ' msec']
title(str)

%------------------------------------------
% Find frequency response
%------------------------------------------
s3 = abs(s2);
figure
plot(s2)
hold on
a = axis;
gain = [];
freqs = [];
Ns3 = length(s3);
for i=1:length(freq_list)
    center_point = FFT_size*1.5 + i*FFT_size + latency;
    %center_point = FFT_size*1.5 + i*FFT_size;
    p1 = center_point - FFT_size/4;
    p2 = center_point + FFT_size/4;
    if p2 < Ns3
        g = max(s3(p1:p2));
        gain =[gain g];
        freqs=[freqs freq_list(i)];
        plot([center_point center_point],[a(3) a(4)],'g')
        plot([p1 p1],[a(3) a(4)],'r')
        plot([p2 p2],[a(3) a(4)],'r')
    end
end


figure
g2 = gain/max(gain);
g3 = 20*log10(g2);
plot(freqs,g3)
hold on
plot(freqs,g3,'.')
a = axis

switch filter_select
    case 1
        
    case 2
        plot([band_pass_cutoff_low band_pass_cutoff_low],[a(3) a(4)],'r')
        plot([band_pass_cutoff_high band_pass_cutoff_high],[a(3) a(4)],'r')
        plot([a(1) a(2)],[-3 -3],'r')
        
        f1 = band_pass_index_low * Fs / FFT_size;  
        f2 = band_pass_index_high * Fs / FFT_size;  
        plot([f1 f1],[a(3) a(4)],'g')
        plot([f2 f2],[a(3) a(4)],'g')

    case 3
        
    case 4
        % do nothing
    otherwise
end


