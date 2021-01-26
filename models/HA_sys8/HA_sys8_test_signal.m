function [ signal_in ] = HA_sys8_test_signal(Fs,Ns)
% Ns = number of samples
Ts = 1/Fs; 
%t = Ts*(0:Ns-1);        % time instants

sig_select = 3;  % sinewaves = 1;  impulse = 2;  chirp = 3;


if sig_select == 1
    Nseg = floor(Ns/10);
    tseg = Ts*(0:Nseg-1);
    signal_in = [];
    for i=1:5
        F=3000/(2^(i-1));   % create all the bandpass center frequencies
        for k=1:2
            if k == 1
                sig = cos(2*pi*F*tseg);
            else
                sig = zeros(1,Nseg);
            end
            signal_in = [signal_in sig];
        end
    end
end
%size(t)
%size(Fsig)

if sig_select == 2
    signal_in = zeros(1,Ns);
    signal_in(10) = 1;
end

if sig_select == 3
    t = Ts*(0:Ns-1);
    signal_in = chirp(t,0,max(t),5000);
end

