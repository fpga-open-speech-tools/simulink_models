
%%% Autogen parameters

mp.testFile = [mp.test_signals_path filesep 'Urban_Light_HedaMusic_Creative_Commons.mp3'];

% TODO: use booleans instead of 0 and 1
mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 5;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;
    
%%% General model parameters

%% Set size of Dual Port Memory
% mp.max_delay = mp.Fs*1/2;   % max delay in samples, i.e. mp.Fs = 1 second max delay
% mp.dpram_addr_size = ceil(log2(mp.max_delay));

%% Set parameters for the LFO (which is an NCO, in this case)
mp.nco_dither_bits = 4;
mp.nco_max_ms = 10; %ms
mp.nco_max = ceil(mp.nco_max_ms * 1e-3 * mp.Fs);
mp.nco_min_ms = 0.5; %ms
mp.nco_min = ceil(mp.nco_min_ms * 1e-3 * mp.Fs);
mp.nco_offset = ceil((mp.nco_max + mp.nco_min)/2);
mp.nco_amplitude = ceil((mp.nco_max - mp.nco_min)/2);
mp.nco_quantizer_bits = 12;
rate_min =  0.1;
mp.nco_accumulator_bits = ceil(log2(mp.Fs/rate_min));

%% Set parameters for the delay line
mp.delay_max = mp.nco_max;
mp.dpram_addr_size = ceil(log2(mp.delay_max));
