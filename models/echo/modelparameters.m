%% Autogen parameters
mp.testFile = [mp.test_signals_path filesep 'Urban_Light_HedaMusic_Creative_Commons.mp3'];
mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 0.5;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;
mp.useAvalonInterface = false;

%% Dual Port Memory Parameters
mp.max_delay          = mp.Fs*1/2;                % Max Delay in samples, i.e. mp.Fs = 1 second max delay
delay_dpram_addr_size = ceil(log2(mp.max_delay)); % Size of the Dual Port RAM need for the max delay length

%% Define the register settings
echoDuration = mp.register{2}.timeseries.Data;
decayGain = mp.register{3}.timeseries.Data;
decayType = mp.register{3}.dataType;
wetDryRatio  = mp.register{4}.timeseries.Data;
wetDryRatioType = mp.register{4}.dataType;
