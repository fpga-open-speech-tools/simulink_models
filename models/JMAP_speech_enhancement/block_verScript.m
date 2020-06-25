% PostSNR Simulink Model Initialization Fcn
%
%
% This function is called to declare variables and their required memory
% allocation for the Simulink Posteriori SNR Verification Model.

% Copyright 2019 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Justin P Williams
% Audio Logic
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

% Variable Declaration
FFT_size = 64;
nSamp = 6;
Fs = 48000;
Ts = 1/Fs;

t = 0 : Ts : (nSamp - 1)*Ts;
t = t';

%% Post SNR Variables
noiseVariance = rand([6, FFT_size]);
framePower    = rand([6, FFT_size]);
noiseVarianceSim = [t, noiseVariance];
framePowerSim    = [t, framePower];
postSNRa = min(framePower./noiseVariance,40);

% figure(1);
% subplot(211);
% stem(noiseVariance(1,:)); xlabel('Samples'); title('Initial Noise Variance Input -- Frame 1');
% subplot(212);
% stem(framePower(1,:));    xlabel('Samples'); title('Initial Frame Power Input -- Frame 1');
% print('postSNR_Inputs', '-djpeg');
% THERE IS NO BLOCK DELAY FOR POSTSNR REEE

%% KSI Variables
postSNRSim = [t, postSNRa];

Xk_prev = rand([6, FFT_size]);
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

% Check Results:
% figure();
% subplot(211);
% stem(ksi(1,:)); xlabel('Samples'); title('ksi -- Frame 1');
% subplot(212);
% stem(hw(1,:));  xlabel('Samples'); title('hw -- Frame 1');

% RESULTS CHECK OUT 

%% VAD Verification
ksiSim = [t, ksi];
count  = 0;
countSim  = [t(1), count];
FFT_sizeInv = [t(1), 1/FFT_size];
noisePower    = 1/2*ones(nSamp, FFT_size);
noisePowerSim = [t, noisePower];
eta = 0.15;
vad_decision = zeros(nSamp, 1);
log_sigma_k = zeros(nSamp, FFT_size);
% Check Results
for n = 1:nSamp
    log_sigma_k(n,:) = postSNRa(n,:).* ksi(n,:)./ (1 + ksi(n,:))- log(1+ ksi(n,:));     
    vad_decision(n) = sum( log_sigma_k(n,:))/FFT_size;    
    if (vad_decision < 1) % noise on
        noisePower(n,:) = noisePower(n,:) + noiseVariance(n,:);
        count = count+1;
    end
    noiseVariance(n,:) = noisePower(n,:)./count;
end

% VAD Decision Block WOOOOORRRKKKKSSS

%% FIR Coefficient Calculations Verification

%% Stop Function Test
% frameMag = rand([nSamp, FFT_size]);
% frameMagSim = [t, frameMag];
% 
% ensig    = rand([nSamp, FFT_size]);
% ensigSim = [t, ensig];

% Check Results
% N_all = zeros(nSamp, 1);
% PR_all = zeros(nSamp, 1);
% PRT_all = zeros(nSamp, 1);
% for n = 1:nSamp
%  PR = sum(abs(ensig(n,:).^2))/(sum(abs(frameMag(n,:).^2))+eps);
%     
%     if(PR>=1)
%         PRT = 1;
%     else
%         PRT = PR;
%     end
%     
%     if(PRT == 1)
%         N=1;
%     else
%         N = 2*round((1-PRT/0.4))+1;
%     end
%     N_all(n) = N;
%     PR_all(n) = PR;
%     PRT_all(n) = PRT;
% end

% IT WOOOOOORRRRRRKKKKKKKKSSSSS

%% FIR Filter Calculations
N = [1,1,2,3,3,3];
NSim = [t, N'];
hw = rand([nSamp, FFT_size]);
hwSim = [t, hw];

frame = rand([nSamp, FFT_size]);
frameMag = frame.^2;
frameSim = [t, frame];
frameMagSim = [t, frameMag];

% Check Results:
Xk_prev = zeros(nSamp, FFT_size);
ensig = zeros(nSamp, FFT_size);
sigOutSc = zeros(nSamp, FFT_size);
HPF_all = zeros(nSamp, FFT_size);
leng1 = FFT_size;
leng2 = FFT_size + 1;
leng3 = FFT_size + 2;
bk_all = zeros(nSamp, 3);
for n = 1:nSamp
    if N(n) == 1
        bk = [1, 0, 0];
        HPF = firfilt(bk, abs(hw(n, 1: FFT_size)));
    elseif N(n) == 2
        bk = [0.5, 0.5, 0];
        HPF = firfilt(bk, abs(hw(n,:)));
%         HPF(65) = [];
    elseif N(n) == 3
        bk = [1/3, 1/3, 1/3];
        HPF = firfilt(bk, abs(hw(n,:)));
    end
    HPF(65:66) = [];
    HPF_all(n,:) = HPF;

    ensig(n,:) = frameMag(n,:).*HPF; 

    Xk_prev(n,:) = ensig(n,:).^2;  % postSNR estimation reused for next frame 
    sigOutSc(n,:) = ensig(n,:) .* exp(i*angle(frame(n,:)));
end


