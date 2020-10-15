
%% Autogen parameters

mp.testFile = [mp.test_signals_path filesep 'beamformer_test.wav'];

% TODO: use booleans instead of 0 and 1
mp.sim_prompts = 0;
mp.sim_verify = 0;
mp.simDuration = .03;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;
    
%% Exponential moving average setup

% % 10 ms window
% mp.windowSize = 10e-3 * mp.Fs;
% 
% % define the exponential moving average weight to be roughly equivalent to
% % a simple moving average of length mp.windowSize
% % https://en.wikipedia.org/wiki/Moving_average#Relationship_between_SMA_and_EMA
% mp.exponentialMovingAverageWeight = fi(2/(mp.windowSize + 1), 0, 32, 31);

mp.speedOfSound = 343;

% TODO: it'd sure be nice to have access to mp.Fs right here, but we don't....
mp.samplingRate = 48e3;
mp.arraySpacing = 25e-3;
mp.arraySize = [4,4];
arraySize = mp.arraySize;
arraySpacing = mp.arraySpacing;
samplingRate = mp.samplingRate;
speedOfSound = mp.speedOfSound;

% TODO: document this equation... this is across the entire array, 
% but delays are relative to the array center, so delays are +/- maxDelay/2
mp.maxDelay = sqrt(((mp.arraySize(1) - 1)*mp.arraySpacing).^2 + ((mp.arraySize(2) - 1)*mp.arraySpacing).^2)*mp.samplingRate/mp.speedOfSound;
% buffer size to accomodate max delay; buffer size is a power of 2

mp.integerDelayAddrSize = ceil(log2(floor(mp.maxDelay))) + 2;
mp.integerDelayBufferSize = 2^mp.integerDelayAddrSize;
mp.upsampleFactor = 16;
upsampleFactor = mp.upsampleFactor;
% number of required bits is two more than that required to represent upsampleFactor
% because we need to be able to represent +/- upsample factor inclusive
mp.fractionalDelayAddrSize = ceil(log2(floor(mp.upsampleFactor))) + 2;
mp.fractionalDelayBufferSize = 2^mp.fractionalDelayAddrSize;

% NOTE: these variables can't be in a matlab structure because the Matlab Coder
% doesn't support that...
delayDataTypeSign = 1;
delayDataTypeWordLength = mp.integerDelayAddrSize + mp.fractionalDelayAddrSize;
delayDataTypeFractionLength = mp.fractionalDelayAddrSize;
mp.delayDataTypeSign = 1;
mp.delayDataTypeWordLength = mp.integerDelayAddrSize + mp.fractionalDelayAddrSize;
mp.delayDataTypeFractionLength = mp.fractionalDelayAddrSize;


%% CIC interpolation
mp.cicInterpolator = dsp.CICInterpolator('InterpolationFactor', mp.upsampleFactor);
mp.cicInterpolatorCompensator = dsp.CICCompensationInterpolator(mp.cicInterpolator, ... 
    'PassbandFrequency', 15e3, 'StopbandFrequency', 23e3, 'SampleRate', samplingRate, ...
    'InterpolationFactor', 1);


%% CIC decimation
mp.cicDecimator = dsp.CICDecimator('DecimationFactor', mp.upsampleFactor);
mp.cicDecimatorCompensator = dsp.CICCompensationDecimator(mp.cicDecimator, ... 
    'PassbandFrequency', 15e3, 'StopbandFrequency', 23e3, 'SampleRate', samplingRate, ...
    'DecimationFactor', 1);