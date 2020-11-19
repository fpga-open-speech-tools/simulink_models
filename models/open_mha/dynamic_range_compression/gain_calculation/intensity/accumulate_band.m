function level_in = accumulate_band(bin_intensity, accumulator_reset, bin_num, num_bins)

% Accumulates the bin intensities until a new frequency band is detected.
% Takes in the current frequency bin intensity, an accumulator reset
% control signal, bin number and number of frequency bins. If the 
% accumulator_reset is true, the sum is reset starting with the current 
% frequency bin intensity. Unless a DC or Nyquist bin is detected, a
% logical shift left is executed to apply a gain of two to the current
% bin_intensity, which accounts for negative frequencies.

persistent total;

if isempty(total)
    total = 0;
end

if bin_num == 1 || bin_num == num_bins
    dc_nyquist = true;
else
    dc_nyquist = false;
end

if accumulator_reset == true && dc_nyquist == true
    total = bin_intensity;
    level_in = total;
elseif accumulator_reset == true && dc_nyquist == false
    total = bitsll(bin_intensity,fi(1));
    level_in = total;
elseif accumulator_reset == false && dc_nyquist == true
    total = total + bin_intensity;
    level_in = total;
elseif accumulator_reset == false && dc_nyquist == false
    total = total + bitsll(bin_intensity,fi(1));
    level_in = total;
else
    total = inf;
    error('Incorrect Logic in accumulate_band function!');
end

