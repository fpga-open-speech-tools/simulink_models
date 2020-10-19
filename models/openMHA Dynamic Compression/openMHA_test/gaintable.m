function [low_gain, high_gain] = gaintable(vy, vy_address_low, vy_address_high)

% Simulates a Dual Rate Dual Port Gain Table by taking in the gain table
% values along with the two calculated addresses that contain the
% appropriate gain values for the band in question.

low_gain = vy(vy_address_low + 1);
high_gain = vy(vy_address_high + 1);