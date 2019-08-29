function [noisePow_out, count_out, noiseVariance_out] = JMAP_vad(postSNR, ksi, nFFT, eta, noise_pow, noiseVariance, count)

log_sigma_k = postSNR.* ksi./ (1+ ksi)- log(1+ ksi); 
vad_decision = sum( log_sigma_k)/nFFT;

% In case vad_decision > eta, need to use input variables for
% noiseVariance_out
count_out = count;
noisePow_out = noise_pow;
if (vad_decision < eta) % noise on
    noisePow_out = noise_pow + noiseVariance;
    count_out = count+1;
end
noiseVariance_out = noisePow_out./count_out;
end