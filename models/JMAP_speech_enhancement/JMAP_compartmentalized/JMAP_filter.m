function [ensig, Xk_prev] = JMAP_filter(N, hw, frameMag, nFFT)
H = zeros(nFFT, 1);
H(1:N) = 1/N;                               % FIR Filter Coefficients
HPF = conv(H,abs(hw));                      % FIR Filter Declaration
ensig = frameMag.*HPF(1:length(frameMag));  % Filtering endSignal
    
Xk_prev = ensig.^2;  % postSNR estimation reused for next frame 

end