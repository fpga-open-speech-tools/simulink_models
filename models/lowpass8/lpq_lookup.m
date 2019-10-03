%% filter parameters
f0 = 10e3;
Q = 5;
fs = 48e3;

%% convert cutoff and resonance values to z-plane transfer function coefficients
s_plane_num = (2*pi*f0)^2;
s_plane_den = [1, (2*pi*f0)/Q, (2*pi*f0)^2];

[z_plane_num, z_plane_den] = bilinear(s_plane_num, s_plane_den, fs);

%% get the frequency response
[H,f] = freqz(z_plane_num, z_plane_den, 100, fs);
plot(f, db(abs(H)));

%% save the data to csv
lpf = table(f, db(abs(H)), 'VariableNames', {'frequency', 'magnitude'});
writetable(lpf)

lpf_log = table(log(f), db(abs(H)), 'VariableNames', {'frequency', 'magnitude'});
writetable(lpf_log)