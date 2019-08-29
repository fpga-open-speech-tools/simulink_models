%% simple function to integrate band powers from predefined psd.
function [dBpwrs] = integrate_band_powers(fpwrs, psd_pwrs, band_edges);
nbands = length(band_edges)-1; dBpwrs = zeros(1,nbands)-200; %% initialise with impossibly small amount
for ix = 1:nbands
    flower = band_edges(ix); fupper = band_edges(ix+1);
    band_pwr = sum(psd_pwrs((fpwrs>=flower) & (fpwrs<fupper)));
    dBpwrs(ix) = 10*log10(band_pwr);
end

    
