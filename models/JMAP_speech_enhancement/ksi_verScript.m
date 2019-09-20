%% Ksi Init
%% KSI Variables
FFT_size = 64;
nSamp = 6;
Fs = 48000;
Ts = 1/Fs;

t = 0 : Ts : (nSamp - 1)*Ts;
t = t';

framePower    = rand([6, FFT_size]);
noiseVariance = rand([6, FFT_size]);
Xk_prev       = rand([6, FFT_size]);
postSNRa      = min(framePower./noiseVariance,40);

noiseVarianceSim = [t, noiseVariance];
postSNRSim = [t, postSNRa];

Xk_prevSim = [t, Xk_prev];
aa      = 0.98*ones(nSamp, FFT_size);
aaSim      = [t, aa];

beta    = 2*ones(nSamp, FFT_size);
betaSim    = [t, beta];
ksi     = zeros(6, FFT_size);
hw      = zeros(6, FFT_size);

n = 1;
ksiInitSim = aa(n,:)+(1-aa(n,:)).*max(postSNRa(n,:)-1,0);
ksiInitSim = [t(1), ksiInitSim];
ksiMin  = 0.0032;
for n = 1:6
    if n==1 % If first frame, initialize ksi & endSignal
        ksi(n,:) = aa(n,:)+(1-aa(n,:)).*max(postSNRa(n,:)-1,0);
%         ensig = frameMag;
    else
        ksi(n,:) = aa(n,:).*Xk_prev(n,:)./noiseVariance(n,:) + (1-aa(n,:)).*max(postSNRa(n,:)-1,0);     
        % decision-direct estimate of a priori SNR
        ksi(n,:) = max(ksiMin,ksi(n,:));  % limit ksi to -25 dB
    end 
    hw(n,:) =(ksi(n,:)+sqrt(ksi(n,:).^2+(1+ksi(n,:)).*ksi(n,:)./postSNRa(n,:)))./(2.*(beta(n,:)+ksi(n,:)));   

end

