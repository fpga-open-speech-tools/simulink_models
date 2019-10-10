%% filter parameters

% Note: we will just ignore Q values since we are generating 8 FIR
% coefficients with low frequency cut off values
f0 = 10e3;
%Q = 5;
Fs = 48e3;

% Q_exponent = linspace(log10(1/10), log10(10), 10);  % create 10 Qs with log10 spacing between [1/10 10]
% Q_values = 10.^Q_exponent;
% NQ = length(Q_values);

F_exponent = linspace(log2(100), log2(20000), 16); % create 16 Fc with log2 spacing between [100 20000]
F_values = 2.^F_exponent;
F_normalized = F_values/(Fs/2);  % normalize to [0 1] that represents [0 Fs/2]
NF = length(F_values);


fid = fopen('coefficient_code.txt','w');


sline = ['function [b0, b1, b2, b3, b4, b5, b6, b7] = get_coefficients(choice)']; fprintf(fid,'%s\n',sline);
sline = ['switch(choice)']; fprintf(fid,'%s\n',sline);



for i=1:NF
    i
    
    B = fir1(8,F_normalized(i));
    
    display_plot = 0;
    if display_plot == 1
        [h,f] = freqz(B, 1, 1000, Fs);
        plot(f, db(abs(h)));
        a = axis;
        a(3) = -40;
        axis(a)
        pause
    end
    
    sline = [blanks(4) 'case ' num2str(i)]; fprintf(fid,'%s\n',sline);
    for j=1:8
        sline = [blanks(8) 'b' num2str(j-1) ' = fi(' num2str(B(j),'%4.28f') ',0,32,28);']; fprintf(fid,'%s\n',sline);
    end
    
    
    
end
sline = ['end']; fprintf(fid,'%s\n',sline);
fclose(fid);









%-------------------------------------
% Old code
%-------------------------------------
% for i=1:NQ
%     for j=1:NF
%         Q = Q_values(i);
%         f0 = F_values(j);
%         % convert cutoff and resonance values to z-plane transfer function coefficients
%         s_plane_num = (2*pi*f0)^2;
%         s_plane_den = [1, (2*pi*f0)/Q, (2*pi*f0)^2];
%         
%         [z_plane_num, z_plane_den] = bilinear(s_plane_num, s_plane_den, fs)
%         Z = roots(z_plane_num)
%         P = roots(z_plane_den)
%         
%         % get the frequency response
%         [H,f] = freqz(z_plane_num, z_plane_den, 100, fs);
%         
%         
%         % approximate with FIR filter with 8 coefficients
%         f3 = f/(fs/2);
%         f3(end) = 1;
%         B = fir2(8,f3,abs(H))
%         [H2,f2] = freqz(B, 1, 100, fs);
%         
%         
%         % plot
%         hold off;
%         plot(f, db(abs(H))); hold on
%         plot(f2, db(abs(H2)),'r'); hold on
%         title(['Q = ' num2str(Q) '     Fc = ' num2str(f0)])
%         pause
%         
%     end
% end

% 
% plot(f, db(abs(H)));
% 
% %% save the data to csv
% lpf = table(f, db(abs(H)), 'VariableNames', {'frequency', 'magnitude'});
% writetable(lpf)
% 
% lpf_log = table(log(f), db(abs(H)), 'VariableNames', {'frequency', 'magnitude'});
% writetable(lpf_log)