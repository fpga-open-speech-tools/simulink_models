load rsigma.mat
TWOPI = 6.28318530717959;
%% Autogen parameters
mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\mef_result.wav'];

mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 5;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;
mp.nSamples = length(double(squeeze(rsigma_sim_in.Data)));

%% ANM Settings
cf = 1000;    % Characteristic frequency of specific neuron
Fs = 48e3;    % Sampling frequency
tdres = 1/Fs; % Binsize in seconds
nrep = 100;   % Number of repititions for peri-stimulus time histogram

% Impairment constants
cohc = 1; 
cihc = 1; 
%% C1 Chirp Filter Parameters
% rsigma = .5;    % Pole shifting constant (set as constant for testing)
taumax = 0.003; % Max time constant (given as bmTaumax in C source code, set to 0.003 for testing, the value of bmTaumax for cf = 1000)

% Line Numbers from model_IHC_BEZ2018.c
sigma0 = 1/taumax;                          % Line 464
ipw    = 1.01 * cf * (2*pi) - 50;           % Line 465
ipb    = 0.2343 * (2*pi) * cf - 1104;       % Line 466
rpa    = 10^(log10(cf)*0.9 + 0.55)+ 2000;   % Line 467
pzero  = 10^(log10(cf)*0.7+1.6)+500;        % Line 468
order_of_pole    = 10;                      % Line 472
half_order_pole  = order_of_pole/2;         % Line 473
order_of_zero    = half_order_pole;         % Line 474

fs_bilinear = TWOPI*cf/tan(TWOPI*cf*tdres/2); % Line 476
rzero       = -pzero;                         % Line 477
CF          = TWOPI*cf;                       % Line 478
phase_init  = 0;                              % Line 538

C1initphase = 0.0;
for i = 1:half_order_pole
    C1initphase = C1initphase + atan(CF/(-rzero))-atan((CF-pimag(2*i-1))/(-preal(2*i-1)))-atan((CF+pimag(2*i-1))/(-preal(2*i-1)));
end  

% Normalize the gain
C1gain_norm = 1.0;
for i = 1:order_of_pole
        C1gain_norm = C1gain_norm*((CF-pimag(i))^2 + (preal(i))^2);
end

norm_gainc1 = (sqrt(C1gain_norm))/((sqrt(CF^2+rzero^2))^order_of_zero);