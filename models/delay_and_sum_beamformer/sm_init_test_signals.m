% mp = sm_init_test_signals(mp)
%
% This function creates and initializes the test signals that are used 
% in the model simulation.
%
% Inputs:
%   mp, which is the model data structure that holds the model parameters
%
% Outputs:
%   mp, the model data structure that now contains the test signals in the 
%   field mp.test_signal, which has the following fields:
%         mp.test_signal.duration  -  length of test signals in seconds
%         mp.test_signal.Nsamples  -  number of samples in test signals
%         mp.test_signal.left      -  signal for left channel
%         mp.test_signal.right     -  signal for right channel
%
% Copyright 2019 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Ross K. Snider
% Flat Earth Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com

function mp = sm_init_test_signals(mp)

signal_option = 1;  % set which test signal to use

switch signal_option
    case 1 % Simple tones        
        mp.test_signal.duration = 5;  % duration of tone in seconds
        Nsamples = round(mp.test_signal.duration*mp.Fs);
        if mp.fastsim_flag == 1 % perform fast simulation by reducing the number of samples
           mp.test_signal.Nsamples = min(Nsamples, mp.fastsim_Nsamples);
        else
           mp.test_signal.Nsamples = mp.fastsim_Nsamples;
        end
        sample_times = [0 1:(mp.test_signal.Nsamples-1)]*mp.Ts;
        mp.test_signal.data  = repmat(cos(2*pi*1000*sample_times), ... 
            mp.arraySize(1)*mp.arraySize(2), 1);
    case 2  % speech 
        [y,Fs] = audioread('SpeechDFT-16-8-mono-5secs.wav');  % speech sample found in the Matlab Audio Toolbox 
        y_resampled = resample(y,mp.Fs,Fs)';  % resample to change the sample rate to SG.Fs
        Nsamples = length(y_resampled);
        if mp.fastsim_flag == 1 % perform fast simulation by reducing the number of samples
           mp.test_signal.Nsamples = min(Nsamples, mp.fastsim_Nsamples);
        else
           mp.test_signal.Nsamples = mp.fastsim_Nsamples;
        end
        mp.test_signal.data  = repmat(y_resampled(1:mp.test_signal.Nsamples), ...
            mp.arraySize(1) * mp.arraySize(2), 1);
        mp.test_signal.Nsamples = length(mp.test_signal.data);
        mp.test_signal.duration = mp.test_signal.Nsamples * mp.Ts;
    case 3 % square wave
        mp.test_signal.duration = 5;  % duration of tone in seconds
        Nsamples = round(mp.test_signal.duration*mp.Fs);
        if mp.fastsim_flag == 1 % perform fast simulation by reducing the number of samples
           mp.test_signal.Nsamples = min(Nsamples, mp.fastsim_Nsamples);
        else
           mp.test_signal.Nsamples = mp.fastsim_Nsamples;
        end
        sample_times = [0 1:(mp.test_signal.Nsamples-1)]*mp.Ts;
        mp.test_signal.data  = repmat(square(2*pi*2000*sample_times), ... 
            mp.arraySize(1)*mp.arraySize(2), 1);
    otherwise
        error('Please choose a viable option for the test signal (see sm_init_test_signals)')
end

%% simulate direction of arrival for each channel
% the doa can be set arbitrarily between +/- 90 for both angles.
% if you want the incoming doa to match the look direction of the array,
% the angles here need to match those in the sm_init_control_signals.
%
% to simulate steering angle quantization errors due to fixed point data
% types, use doubles for simulatedAzimuth and simulatedElevation and use 
% the computeDelaysDoubles function; otherwise, use computeDelaysFixedPoint
% sfix16_8 types for azimuth and elevation
mp.simulatedAzimuth = 34;
mp.simulatedElevation = -55;

delays = computeDelays(mp);

%plot(mp.test_signal.data(1,:)'); hold on;

% delay the signal at each sensor
% fcolshift is from the fileexchange 
% https://www.mathworks.com/matlabcentral/fileexchange/73424-fcolshift-fractional-column-circular-shift
mp.test_signal.data = fcolshift(mp.test_signal.data', double(delays))';

%plot(mp.test_signal.data');
%legend('original', cellstr(['original'; num2str(delays)]))

%% add uncorrelated noise to each channel
% the beamforming algorithm should increase signal-to-noise ratio. 
NOISE_AMPLITUDE = 0.4;
mp.test_signal.data = mp.test_signal.data + NOISE_AMPLITUDE * rand(size(mp.test_signal.data));





