
%% Autogen parameters

mp.testFile = [mp.test_signals_path filesep 'noisySpeech.wav'];
mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 15;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;

nAddresses = 512;
n_shift = 16;

input_data = 1:nAddresses;

% Set the addresses for the DPR
dprDataIn = (1:nAddresses)-1;

% Shift the addresses into the correct location
dprDataIn = bitshift(dprDataIn, n_shift);

% Add the coefficients to the variables
dprDataIn = dprDataIn + input_data;