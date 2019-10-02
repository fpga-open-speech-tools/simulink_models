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
% Copyright 2019 Flat Earth Inc
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

signal_option = 3;  % set which test signal to use

switch signal_option
    case 1 % Simple tones
        mp.test_signal.duration = 1;  % duration of tone in seconds
        Nsamples = round(mp.test_signal.duration*mp.Fs);
        if mp.fastsim_flag == 1 % perform fast simulation by reducing the number of samples
           mp.test_signal.Nsamples = min(Nsamples, mp.fastsim_Nsamples);
        else
           mp.test_signal.Nsamples = mp.fastsim_Nsamples;
        end
        sample_times = [0 1:(mp.test_signal.Nsamples-1)]*mp.Ts;
        mp.test_signal.left  = cos(2*pi*2000*sample_times);
        mp.test_signal.right = cos(2*pi*3000*sample_times);
    case 2  % speech
        [y,Fs] = audioread('SpeechDFT-16-8-mono-5secs.wav');  % speech sample found in the Matlab Audio Toolbox
        y_resampled = resample(y,mp.Fs,Fs);  % resample to change the sample rate to SG.Fs
        Nsamples = length(y_resampled);
        if mp.fastsim_flag == 1 % perform fast simulation by reducing the number of samples
           mp.test_signal.Nsamples = min(Nsamples, mp.fastsim_Nsamples);
        else
           mp.test_signal.Nsamples = mp.fastsim_Nsample;
        end
        mp.test_signal.left  = y_resampled(1:mp.test_signal.Nsamples);
        mp.test_signal.right = y_resampled(1:mp.test_signal.Nsamples);
        mp.test_signal.Nsamples = length(mp.test_signal.left);
        mp.test_signal.duration = mp.test_signal.Nsamples * mp.Ts;
    case 3 % user supplied music
        [y,Fs] = audioread([mp.test_signals_path filesep 'Urban_Light_HedaMusic_Creative_Commons.mp3']);
        y_resampled = resample(y,mp.Fs,Fs);  % resample to change the sample rate to SG.Fs
        Nsamples = length(y_resampled);
        if mp.fastsim_flag == 1 % perform fast simulation by reducing the number of samples
           mp.test_signal.Nsamples = min(Nsamples, mp.fastsim_Nsamples);
        else
           mp.test_signal.Nsamples = mp.fastsim_Nsamples;
        end
        mp.test_signal.left  = y_resampled(1:mp.test_signal.Nsamples);
        mp.test_signal.right = y_resampled(1:mp.test_signal.Nsamples);
        mp.test_signal.Nsamples = length(mp.test_signal.left);
        mp.test_signal.duration = mp.test_signal.Nsamples * mp.Ts;
    case 4 % Simple tones
        mp.test_signal.duration = 0.5;  % duration of tone in seconds
        Nsamples = round(mp.test_signal.duration*mp.Fs);
        if mp.fastsim_flag == 1 % perform fast simulation by reducing the number of samples
           mp.test_signal.Nsamples = min(Nsamples, mp.fastsim_Nsamples);
        else
           mp.test_signal.Nsamples = mp.fastsim_Nsamples;
        end
        mp.test_signal.left  = [1 zeros(1, mp.test_signal.Nsamples - 1)];
        mp.test_signal.right = [1 zeros(1, mp.test_signal.Nsamples - 1)];
    otherwise
        error('Please choose a viable option for the test signal (see sm_init_test_signals)')
end
