%% Load the paths

% run ../../../config/pathSetup.m


%% Autogen parameters

mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\syn_out.wav'];

mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 5;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;

%% ANM Settings
cf = 1000;    % Characteristic frequency of specific neuron
Fs = 48e3;    % Sampling frequency
tdres = 1/Fs; % Binsize in seconds

spont = 100;
nSites = 4;
t_rd_rest = 14.0e-3;
t_rd_jump = 0.4e-3;
t_rd_init = t_rd_rest + 0.02e-3*spont - t_rd_jump;
tau = 60e-3;    

trel = 10e-3;
tabs = 10e-3;

randNums = single(rand(mp.nSamples,1));
elapsed_time = single(tdres * randi(floor(Fs * t_rd_init)));
unitRateInterval = single(-log(rand(1))/tdres);
oneSiteRedock = single(-t_rd_init * log(rand(1)));


%% Simulation parameters
vihc = 0.050;
CF = 1000;
nrep = 10;
dt = tdres; 
noiseType = 1;
implnt = 0;
spont = 50;
