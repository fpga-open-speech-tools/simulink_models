%% Compares outputs of the model to that of the Definitive Algorithm
% Justin Williams
% Audio Logic

%% Extract data from model outputs
ensigLength = get(ensig_Out_Work);
ensigLength = ensigLength.Length;
ensigFrame  = getdatasamples(ensig_Out_Work, 1:ensigLength);
clear('ensig_Out_Work');

countLength = get(countWork);
countLength = countLength.Length;
countFrame  = getdatasamples(countWork, 1:countLength);
clear('countWork');

frameMagLength = get(frameMagWork);
frameMagLength = frameMagLength.Length;
magFrame       = getdatasamples(frameMagWork, 1:frameMagLength);
clear('frameMagWork');

frameLength = get(frameWork);
frameLength = frameLength.Length;
mFrame      = getdatasamples(frameWork, 1:frameLength);
clear('frameWork');

hwL = get(hwWork);
hwL = hwL.Length;
hwFrame = getdatasamples(hwWork, 1:hwL);
clear('hwWork');

ksiL = get(ksiWork);
ksiL = ksiL.Length;
ksiFrame = getdatasamples(ksiWork, ksiL);
clear('ksiWork');

N_L = get(N_Work);
N_L = N_L.Length;
NFrame = getdatasamples(N_Work, 1:N_L);
clear('N_Work');

noisePowL = get(noisePowWork);
noisePowL = noisePowL.Length;
noisePowFrame = getdatasamples(noisePowWork, 1:noisePowL);
clear('noisePowWork');

noiseVarL = get(noiseVarWork);
noiseVarL = noiseVarL.Length;
noiseVarFrame = getdatasamples(noiseVarWork, 1:noiseVarL);
clear('noiseVarWork');

postSNRL = get(postSNRWork);
postSNRL = postSNRL.Length;
postSNRFrame = getdatasamples(postSNRWork, 1:postSNRL);
clear('postSNRFrame');

sigModL = get(sigModOutWork);
sigModL = sigModL.Length;
sigModFrame = getdatasamples(sigModOutWork, 1:sigModL);
clear('sigModOutWork');

XkprevL = get(XkPrevWork);
XkprevL = XkprevL.Length;
XkprevFrame = getdatasamples(XkPrevWork, 1:XkprevL);
clear('XkPrevWork');
%% Plot Certain Frames Together For Comparison
% Constants 
%         1 2 3  4  5  6   7
frmInd = [2 4 8 16 32 64 128];
for n = 500:500:XkprevL
    figure;
    plot(1:FFT_size, real(sigModFrame(n,:)));
    title('
    
end









