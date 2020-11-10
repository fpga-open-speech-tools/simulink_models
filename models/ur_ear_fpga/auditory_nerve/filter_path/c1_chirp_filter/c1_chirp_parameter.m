%--Calculate the constant parameters for the C1 filter, including initial pole/zero locations, shifting constants, and gain constants
function [norm_gainc1] = c1_chirp_parameter(preal, pimag, pzero, order_of_pole, order_of_zero, CF)
    rzero = -pzero;
    % Normalize the gain
    C1gain_norm = 1.0;
    for i = 1:order_of_pole
            C1gain_norm = C1gain_norm*((CF-pimag(i))^2 + (preal(i))^2);
    end

    norm_gainc1 = (sqrt(C1gain_norm))/((sqrt(CF^2+rzero^2))^order_of_zero);