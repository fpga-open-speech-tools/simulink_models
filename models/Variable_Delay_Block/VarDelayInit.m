% VarDelayInit 
clear; 

delayMax = 2^4;
RAM_SIZE = ceil(log2(delayMax));

data = 0:0.25:9.75;
%delay = floor(rand(1,length(data)).*2^4);
delay =0:7;
delay = ones(5,8).*delay;
delay = delay(:);
valid = ones(1,length(data));

Ts = 1/48000;
tt = 0:length(data)-1;
tt = tt.*Ts;

%% Testing upsampling of signals, for valid/counter check
data = upsample(data, 4);
valid = upsample(valid, 4);
delay = [0,0:8];
delay = ones(2,10).*delay;
delay = [delay(:); delay(:); delay(:); delay(:); delay(:); delay(:); delay(:); delay(:)];
Ts = Ts*0.25;
tt = 0:length(data)-1;
tt = tt.*Ts;

dataIn = timeseries(data, tt);
delayIn = timeseries(delay, tt(1:length(delay)));
validIn = timeseries(valid, tt);



stop_time = tt(length(delay));