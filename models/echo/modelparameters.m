
%%% Autogen parameters

mp.testFile = [mp.test_signals_path filesep 'Urban_Light_HedaMusic_Creative_Commons.mp3'];

% TODO: use booleans instead of 0 and 1
mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 5;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;

mp.useAvalonInterface = false;
    
%%% General model parameters

%% Set size of Dual Port Memory
mp.max_delay = mp.Fs*1/2;   % max delay in samples, i.e. mp.Fs = 1 second max delay
mp.dpram_addr_size = ceil(log2(mp.max_delay));


