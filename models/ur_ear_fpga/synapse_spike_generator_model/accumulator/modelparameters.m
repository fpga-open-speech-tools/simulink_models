
%% Autogen parameters
Fs = 48e3;
mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\nl_pla_filter.wav'];
mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 5;
mp.nSamples = Fs * mp.simDuration;

%% ANM Settings

integrationTime = 40e-3*Fs;
threshold       = 0.950;

% TODO: Investigate why the simulation is not using the values set by the following functions
% When this is debugged the if statement won't be needed.
if exist('spcountRedock1','var') 
  spcountRedock1_prev = spcountRedock1;
  spcountRedock2_prev = spcountRedock2;
  spcountRedock3_prev = spcountRedock3;
  spcountRedock4_prev = spcountRedock4;
end

spcountRedock1 = rand(mp.nSamples,1);
spcountRedock2 = rand(mp.nSamples,1);
spcountRedock3 = rand(mp.nSamples,1);
spcountRedock4 = rand(mp.nSamples,1);

% Create an array of 1s and 0s based on an arbitrary threshold value
spcountRedock1 = spcountRedock1 > threshold;
spcountRedock2 = spcountRedock2 > threshold;
spcountRedock3 = spcountRedock3 > threshold;
spcountRedock4 = spcountRedock4 > threshold;

simStop = mp.nSamples/Fs;