%% a function call returning FIR filter to achieve a prescrition gain for an aid:
%% function aperture = prescription_design_function(frqs, gains_dB, fs, diagnostic);
%% frqs : frequency of gain function "gains_dB"
%% fs: sampling frequency
%% diagnostic : whether to plot achieved response in extra window
%% returns (filt_order+1) tap FIR filter

function [aperture, success] = prescription_design_function(frqs, gains_dB, fs, span_msec, diagnostic)

%% small (realistic) time aperture
filt_order = 2*round((span_msec/1000)*(fs/2)); %% even order and small extent in time
if fs/2 < max(frqs) %% ipfile bandwidth not enough to benefit from full simulation
    success = 0;
    pause(3);
    frqs = [0 frqs 1.0001*(frqs(end))]; %% make ready for interp, stop array folding back on itself
else
    success = 1;
    frqs = [0 frqs 1.0001*(fs/2)]; %% make ready for interp, by extending slightly beyond Nyquist
end
gains_dB = [gains_dB(1) gains_dB gains_dB(end)];

spec_size = 1024; %% detail grid on which to calculate & plot  spectrum of all filters
f = (fs/spec_size)*(0:spec_size-1);
f = f/2;  %% implicitly will double fftsize when mirrored
f(1) = 1e-3; %%% prevent log(0)

dBprescription = 0*f;  %% allocate space
dBprescription = interp1(frqs, gains_dB, f, 'linear');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if diagnostic
    figure(99); hold off; %% use a weird figure number to plot diagnostic 
    gmax = max(gains_dB)+2; gmin = min(gains_dB)-2; %% limits for plotting
    plot(f,dBprescription,'--b','linewidth',1.5); set(gca,'xlim',[80 fs/2],'xscale','log','ylim',[gmin gmax]); grid on; hold on; 
end

prescription = 10.^(.05*dBprescription); %% linear gain
NP = spec_size;
HfPrescr = [prescription abs(prescription(NP)) conj(prescription(NP:-1:2))];
HfPrescr = HfPrescr.*exp(1i*(0:2*spec_size-1)*pi); %%%%% equivalent to shift in time domain 
Prescr_t = real(ifft(HfPrescr));

%% now window out relevant length that we will use.............
span = (spec_size+1-filt_order/2):(spec_size+1+filt_order/2);
wdw = kaiser(filt_order+1, 5);  %% only gentle rolling off of tails with beta of kaiser fn
%% and pick it out
wdw_Prescr_t = Prescr_t(span).*wdw'; %%%%% window to reduce edge effects
[Prescr_resp, wn] = freqz(wdw_Prescr_t,1,spec_size,fs);
dB_resp = 20*log10(abs(Prescr_resp));
if diagnostic
    plot(wn, dB_resp, '-g', 'linewidth', 1.5); hold on; %% assuming here that we are still at figure(99).
    set(gca, 'fontsize', 12);
    title('IG65 target (dash-blue), achieved (solid-green) : (change via [span-msec] variable)', 'fontsize', 12);
    ylabel('Insertion gain (IG65, dB)', 'fontsize', 12); xlabel('Frequency (Hz)', 'fontsize', 12);
end
aperture = wdw_Prescr_t;  %% return variable
