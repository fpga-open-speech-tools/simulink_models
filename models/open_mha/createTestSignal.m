
cutoffs = [0 250 500 750 1000 2000 4000 12000 24000];
audio_fs = 48e3;
duration = 1;

t = linspace(0,duration,audio_fs*duration);
amplitude = linspace(0,1,audio_fs*duration);

xx = zeros(size(t));

for ii = 1:(length(cutoffs) - 1)
  xx = xx + sin(2*pi*(cutoffs(ii+1) + cutoffs(ii))/2*t);
end

xx = xx / (length(cutoffs) - 1);

xx = xx/max(xx).*amplitude;

audiowrite('../../test_signals/ramp.wav',[xx;xx]',audio_fs)