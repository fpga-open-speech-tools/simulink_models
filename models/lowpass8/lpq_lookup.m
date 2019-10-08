%% filter parameters
f0 = 10e3;
Q = 5;
fs = 48e3;

Q_exponent = linspace(log10(1/10), log10(10), 10);  % create 10 Qs with log10 spacing between [1/10 10]
Q_values = 10.^Q_exponent;
NQ = length(Q_values);

F_exponent = linspace(log2(1000), log2(20000), 10); % create 10 Fc with log2 spacing between [1000 20000]
F_values = 2.^F_exponent;
NF = length(F_values);

for i=1:NQ
    for j=1:NF
        Q = Q_values(i);
        f0 = F_values(j);
        % convert cutoff and resonance values to z-plane transfer function coefficients
        s_plane_num = (2*pi*f0)^2;
        s_plane_den = [1, (2*pi*f0)/Q, (2*pi*f0)^2];
        
        [z_plane_num, z_plane_den] = bilinear(s_plane_num, s_plane_den, fs)
        Z = roots(z_plane_num)
        P = roots(z_plane_den)
        
        % get the frequency response
        [H,f] = freqz(z_plane_num, z_plane_den, 100, fs);
        
        
        % approximate with FIR filter with 8 coefficients
        f3 = f/(fs/2);
        f3(end) = 1;
        B = fir2(8,f3,abs(H))
        [H2,f2] = freqz(B, 1, 100, fs);
        
        
        % plot
        hold off;
        plot(f, db(abs(H))); hold on
        plot(f2, db(abs(H2)),'r'); hold on
        title(['Q = ' num2str(Q) '     Fc = ' num2str(f0)])
        pause
        
    end
end



% 
% plot(f, db(abs(H)));
% 
% %% save the data to csv
% lpf = table(f, db(abs(H)), 'VariableNames', {'frequency', 'magnitude'});
% writetable(lpf)
% 
% lpf_log = table(log(f), db(abs(H)), 'VariableNames', {'frequency', 'magnitude'});
% writetable(lpf_log)