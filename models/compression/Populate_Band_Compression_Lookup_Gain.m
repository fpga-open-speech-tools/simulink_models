function [G_lookup_out] = Populate_Band_Compression_Lookup_Gain ...
    (Xp_in, X_in_max, min_audible_thresh, max_output, Max_Prescribed_Band_Gain)
%% 
% Populate_Band_Compression_Lookup.m
% Created by E. Bailey Galacci, 6/20/19
%
% This function is designed to populate a lookup table for a single band in
% an applied prescription dynamic compression system. Currently, the design
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
% decreasing audio quality.
%
% Note that all inputs are in real values, not dB or dBA equivalents.
% Another plan for future improvement is to design a function to use a
% reference dBA <-> digital input value to define thresholds of minimum
% audible threshold and maximum output threshold.
%
% Inputs:  
%   Xp_in: The array of possible input volumes after prescription and 
%       bandpass filtering are applied. The same result should be achieved 
%       whether compression is applied before or after prescription FIR.
%       Inputs shoud be linearly spaced, as the FPGA fabric expects
%       linearly spaced data points for Y_out hash function.
%       Bounded from 0 <= Xp_in <= X_in_max
%
%   X_in_max: the maximum digital value the compressor can expect, before
%       applying the prescription. Must be positive for expected operation.
%       Must be >= max(Xp_in) for proper operation.
%
%   min_audible_thresh: the minimum input the user wishes to hear in that
%       frequency band. 
%
%   max_output: the maximum output of the compression system. The  output 
%       value will only reach this when input is at max, i.e. clipping. The
%       purpose is to avoid playing audio at an uncomfortable volume.
%
%   Max_Prescribed_Band_Gain: The maximum gain applied to the input, as a
%       result of both the prescription applied to X_in and the bandpass
%       filter of this band.
%
%
% Outputs:
%   Y_out: The value to send to the output speaker (or prescription FIR
%       filter, depending on order applied). This will be an array with the
%       same length as the input value array, and the same size as the
%       lookup table instantiated in the FPGA fabric.
%       This lookup table will be sent by MATLAB or Linux to the FPGA's
%       dual port RAM corresponding to the desired signal band.
%       Bounded by (min_audible_floor*Prescribed_Band_Gain)<|Y|<max_output

%% Error checking

Xp_in = abs(Xp_in);

% Define the compression threshold to start compression from the floor
% output volume
Comp_Threshold = min_audible_thresh * Max_Prescribed_Band_Gain;

% Define compression ratio to fit the desired ceiling
Comp_Ratio = log(X_in_max/min_audible_thresh) / log( max_output/Comp_Threshold );

% Populate the Y lookup array. Note this is the actual value to output, not
% the gain applied to the input. The gain has an extra factor of 1/Xp_in.
% Y_lookup_out = Xp_in*Gc(abs(Xp_in))

G_lookup_out = (Comp_Threshold./Xp_in).*nthroot(Xp_in./Comp_Threshold , Comp_Ratio);

end