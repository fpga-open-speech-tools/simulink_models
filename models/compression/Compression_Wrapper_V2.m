function [G_out, max_gain_prescript, X_in, Comp_Ratio] = Compression_Wrapper_V2(fs, X_low_thresh_dB, X_high, bpf_coeff, prescript_FIR_coeff, ref_dB, X_ref, M_bits)
%% ig_eq, calib_bpfs
% Compression_Wrapper.m
% Created by E. Bailey Galacci, 6/21/19
%
% This function is designed to set up and populate a lookup table for a
% single band, and replicated NChan times within an applied prescription
% dynamic compression system. 
% Currently, the design
% applies a prescription gain FIR filter before band compression, however
% testing will be done in the reverse order to see if this affects the
% output. 
% This function is wrapped by another function to prepare its inputs from a
% known prescription and reference dBA of the signal. For example, 
% max_output should be tied to a value representing ~80-85 dBA.
%
% Applying prescription aware compression BEFORE a prescription gain FIR 
% may help to avoid potential clipping of the audio from the prescription 
% gain, but could also cause more rounding error on low volume sound, 
% decreasing audio quality. This could be avoided by calculating
% Compression Gain using the prescribed input signal, then applying the
% Compression Gain to the raw input signal followed by another copy of the
% prescription FIR, but this would increase delay and may not fully deal
% with clipping.
%
% Note that all inputs are in real values, not dB or dBA equivalents.
% Another plan for future improvement is to design a function to use a
% reference dBA <-> digital input value to define thresholds of minimum
% audible threshold and maximum output threshold.
%
% Inputs:  
%   fs: sampling rate of the audio
%   
%   X_low_thresh_dB: lowest desired perceptible sound level by the user
%
%   X_high: the maximum digital value the compressor can expect, before
%       applying the prescription. Must be positive for expected operation.
%       Must be >= max(Xp_in) for proper operation.
%
%   bpf_coeff: bandpass filter coefficients applied to this band. used to
%       identify the maximum possible gain of this band in tandem with
%       prescript_FIR_coeff
%
%   prescript_FIR_coeff: the FIR filter b coefficients used in the
%       prescription gain function. used to identify the maximum possible
%       gain of this band in tandem with bpf_coeff
%
%   dB_ref/x_ref: these are used to identify the relative power of a
%       specific value from the codec, and to determine the max output
%       healthy for the human ear in short time audio (~85 dBA), as well as
%       the value corresponding to the X_low_thresh dBA.
%
%  
% Outputs:
%   G_out: The gain to apply to the post-prescription input signal. This 
%       will be an array with the same size as the
%       lookup table instantiated in the FPGA fabric.
%       This lookup table will be sent by MATLAB or Linux to the FPGA's
%       dual port RAM corresponding to the desired signal band.
%       Bounded by (min_audible_floor*Prescribed_Band_Gain)<|Y|<max_output
    
% Identify the maximum possible gain of this band, before compression
spec_size = 1024;
[presz, ~] = freqz(prescript_FIR_coeff,1,spec_size,fs);

chfir_len = bpf_coeff(1);
[bpz, ~] = freqz(bpf_coeff(2:chfir_len+1), 1,spec_size, fs);

total_response = abs(presz).*abs(bpz);
max_gain_prescript = max(total_response);
%max_gain_prescript = 10;

% Identify treshold low input level to map from
X_thresh = X_ref*10^(0.05*(X_low_thresh_dB-ref_dB));

% Identify high output level to map to
safe_lv_dB = 85; %dB
safe_max = X_ref*10^(0.05*(safe_lv_dB-ref_dB));

% Define a 64 point log2 spaced range of inputs, from 2^-15 to almost 2, 
% this effectively covers an input bound from -85dBA to 1.
X_in = zeros(1, 2^(M_bits+4));
addr = 1;
for NShifts = 15:-1:0
    for M = 0:2^M_bits - 1
        X_in(addr) = 2^(-NShifts) + M*2^(-NShifts-M_bits);
        addr = addr+1;
    end
end
% Find wherever X_Chan is less than threshold, we want this to have
% a gain of 1, instead of amplification. Treating it as X_thresh
% accomplishes this
X_low = (X_in <= X_thresh);
X_in(X_low) = X_thresh;
[G_out, Comp_Ratio] = Populate_Band_Compression_Lookup_Gain_V2 ...
    (X_in, X_high, X_thresh, safe_max, max_gain_prescript);

end