%% Compares outputs of the model to that of the Definitive Algorithm
% Justin Williams
% Audio Logic

%% Extract data from model outputs
ensigLength = get(ensig_Out_Work);
ensigLength = ensigLength.Length;
ensigFrame  = getdatasamples(ensig_Out_Work, 1:ensigLength);
% clear('ensig_Out_Work');

countLength = get(countWork);
countLength = countLength.Length;
countFrame  = getdatasamples(countWork, 1:countLength);
% clear('countWork');

frameMagLength = get(frameMagWork);
frameMagLength = frameMagLength.Length;
magFrame       = getdatasamples(frameMagWork, 1:frameMagLength);
% clear('frameMagWork');

frameLength = get(frameWork);
frameLength = frameLength.Length;
mFrame      = getdatasamples(frameWork, 1:frameLength);
% clear('frameWork');

hwL = get(hwWork);
hwL = hwL.Length;
hwFrame = getdatasamples(hwWork, 1:hwL);
% clear('hwWork');

ksiL = get(ksiWork);
ksiL = ksiL.Length;
ksiFrame = getdatasamples(ksiWork, 1:ksiL);
% clear('ksiWork');

N_L = get(N_Work);
N_L = N_L.Length;
NFrame = getdatasamples(N_Work, 1:N_L);
% clear('N_Work');

noisePowL = get(noisePowWork);
noisePowL = noisePowL.Length;
noisePowFrame = getdatasamples(noisePowWork, 1:noisePowL);
% clear('noisePowWork');

noiseVarL = get(noiseVarWork);
noiseVarL = noiseVarL.Length;
noiseVarFrame = getdatasamples(noiseVarWork, 1:noiseVarL);
% clear('noiseVarWork');

postSNRL = get(postSNRWork);
postSNRL = postSNRL.Length;
postSNRFrame = getdatasamples(postSNRWork, 1:postSNRL);
% clear('postSNRFrame');

sigModL = get(sigModOutWork);
sigModL = sigModL.Length;
sigModFrame = getdatasamples(sigModOutWork, 1:sigModL);
% clear('sigModOutWork');

XkprevL = get(XkPrevWork);
XkprevL = XkprevL.Length;
XkprevFrame = getdatasamples(XkPrevWork, 1:XkprevL);
% clear('XkPrevWork');
%% Plot Certain Frames Together For Comparison
% Constants 
%         1 2 3  4  5  6   7
frmInd = [2 4 8 16 32 64 128];
for n = 500:500:XkprevL
    figure('units','normalized','outerposition',[0 0 1 1]);
%     subplot(6,2,1);
    plot(1:FFT_size, real(sigModFrame(n,:)), 'k', 1:FFT_size, sigOutExport(n,:), 'r');
    title([num2str(n), 'th Frame processed signal output']);
    xlabel('FFT Data Points');
    ylabel('Magnitude'); legend('sound out - Simulink', 'sound out - JMAP Script');
    print([num2str(n), 'th Frame - Signal Outprocessed'], '-djpeg');
    
%     subplot(6,2,2);
%     plot(1:FFT_size, real(ensigFrame(n,:)));
%     title([num2str(n), 'th Frame ensig signal output']);
%     xlabel('FFT Data Points');
%     ylabel('Magnitude');
%     
% %     subplot(6,2,3);
%     plot(1, countFrame(n));
%     title([num2str(n), 'th Frame count signal output']);
%     xlabel('FFT Data Points');
%     ylabel('Magnitude');
%     
% %     subplot(6,2,4);
%     plot(1:FFT_size, real(mFrame(n,:)));
%     title([num2str(n), 'th Frame FFT Frame Input signal Input']);
%     xlabel('FFT Data Points');
%     ylabel('Magnitude');
%     
% %     subplot(6,2,5);
%     plot(1:FFT_size, real(magFrame(n,:)));
%     title([num2str(n), 'th Frame Magnitude of FFT Frame Input']);
%     xlabel('FFT Data Points');
%     ylabel('Magnitude');
%     
% %     subplot(6,2,6);
%     plot(1:FFT_size, real(hwFrame(n,:)));
%     title([num2str(n), 'th hw Frame Input']);
%     xlabel('FFT Data Points');
%     ylabel('Magnitude');
%     
% %     subplot(6,2,7);
%     plot(1:FFT_size, real(ksiFrame(n,:)));
%     title([num2str(n), 'th ksi Frame Input']);
%     xlabel('FFT Data Points');
%     ylabel('Magnitude');
%     
% %     subplot(6,2,8);
%     plot(1, real(NFrame(n)));
%     title([num2str(n), 'th Frame - FIR Coefficient']);
%     xlabel('FFT Data Points');
%     ylabel('Magnitude');
%     
% %     subplot(6,2,9);
%     plot(1:FFT_size, real(noisePowFrame(n,:)));
%     title([num2str(n), 'th Noise Power Frame Input']);
%     xlabel('FFT Data Points');
%     ylabel('Magnitude');
%     
% %     subplot(6,2,10);
%     plot(1:FFT_size, real(noiseVarFrame(n,:)));
%     title([num2str(n), 'th Noise Variance Frame Input']);
%     xlabel('FFT Data Points');
%     ylabel('Magnitude');
%     
% %     subplot(6,2,11);
%     plot(1:FFT_size, real(postSNRFrame(n,:)));
%     title([num2str(n), 'th Frame - Posteriori SNR of Frame Input']);
%     xlabel('FFT Data Points');
%     ylabel('Magnitude');
%     
% %     subplot(6,2,12);
%     plot(1:FFT_size, real(XkprevFrame(n,:)));
%     title([num2str(n), 'th - Frame Noise Estimation for Next Frame Input']);
%     xlabel('FFT Data Points');
%     ylabel('Magnitude');
%     
%     print([num2str(n), ' Frame Plots - From Model'], '-djpeg');
    close all;
    
end









