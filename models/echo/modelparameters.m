
%%% Autogen but simulink only
%mp.fastSim = 0;
%mp.simPrompts = 0;
% Test source is class and test file is path to file.
%mp.testSource = "";
%mp.testFile = [mp.test_signals_path filesep 'Urban_Light_HedaMusic_Creative_Commons.mp3'];

mp.testFile = [mp.test_signals_path filesep 'Urban_Light_HedaMusic_Creative_Commons.mp3'];

mp.sim_prompts = 1;
mp.sim_verification = 1;
mp.fastsim_flag = 1;
mp.fastsim_Fs_system_N = 2;
mp.fastsim_Nsamples = 48000 * 20;
    
%%% Not Autogen

%% Set size of Dual Port Memory
mp.max_delay = mp.Fs*1/2;   % max delay in samples, i.e. mp.Fs = 1 second max delay
mp.dpram_addr_size = ceil(log2(mp.max_delay));


