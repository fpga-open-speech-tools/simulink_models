
close all

s1 = squeeze(signal_in.Data);
s2 = signal_out;

figure
subplot(2,1,1)
plot(s1)
hold on
plot(s2)
str = ['Input and Output Signals;   FFT size = ' num2str(FFT_size)];
title(str)

%------------------------------------------
% Find latency
%------------------------------------------
threshold = 0.5;
plot([0 length(s2)],[threshold threshold],'g')
idx1 = find(s1 > threshold, 1, 'first')
idx2 = find(s2 > threshold, 1, 'first')
latency = idx2-idx1


%------------------------------------------
% Find amplitude difference
%------------------------------------------
s1_max = max(s1(FFT_size*4:end))
s1_min = min(s1(FFT_size*4:end))
s1_amplitude = s1_max-s1_min

s2_max = max(s2(FFT_size*4 + latency + FFT_size_half:end))
s2_min = min(s2(FFT_size*4 + latency + FFT_size_half:end))
s2_amplitude = s2_max-s2_min

normalization_gain = s1_amplitude/s2_amplitude

subplot(2,1,2)

z = zeros(latency,1);
plot([z; s1])
hold on
plot([s2*normalization_gain; z])
str = ['Latency = ' num2str(latency) ' samples = ' num2str(latency*Ts*1000) ' msec;  Normalization Gain = ' num2str(normalization_gain)]
title(str)


system_clock = Fs*SysRate_Upsample_Factor;
str = ['System clock = ' num2str(system_clock/1000000) ' Mhz']

text(10,-0.5,str)

