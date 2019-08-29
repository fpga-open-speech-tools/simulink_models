function [ksi, hw] = JMAP_hw_ksi(n, aa, beta, postSNR, Xk_prev, noiseVariance)

ksi_min = 10^(-25/10); 

    if n==1 % If first frame, initialize ksi & endSignal
        ksi = aa+(1-aa)*max(postSNR-1,0);
%         ensig = frameMag;
    else
        ksi = aa*Xk_prev./noiseVariance + (1-aa)*max(postSNR-1,0);     
        % decision-direct estimate of a priori SNR
        ksi = max(ksi_min,ksi);  % limit ksi to -25 dB
    end
    hw = (ksi+sqrt(ksi.^2+(1+ksi).*ksi./postSNR))./(2*(beta+ksi));   
end