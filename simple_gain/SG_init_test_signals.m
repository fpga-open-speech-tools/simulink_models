% model_params = SG_init_test_signals(model_params)
%
% This function creates and initializes the test signals that are used 
% in the model simulation.
%
% Inputs:
%   model_params, which is the model data structure that holds the model parameters
%
% Outputs:
%   model_params, the model data structure that now contains the test signals in the 
%   field model_params.test_signal, which has the following fields:
%         model_params.test_signal.duration  -  length of test signals in seconds
%         model_params.test_signal.Nsamples  -  number of samples in test signals
%         model_params.test_signal.left      -  signal for left channel
%         model_params.test_signal.right     -  signal for right channel
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

function model_params = SG_init_test_signals(model_params)

signal_option = 3;  % set which test signal to use

switch signal_option
    case 1 % Simple tones        
        model_params.test_signal.duration = 1;  % duration of tone in seconds
        model_params.test_signal.Nsamples = round(model_params.test_signal.duration*model_params.Fs);
        sample_times = [0 1:(model_params.Nsamples-1)]*model_params.Ts;
        model_params.test_signal.left  = cos(2*pi*2000*sample_times);
        model_params.test_signal.right = cos(2*pi*3000*sample_times);
    case 2  % speech 
        [y,Fs] = audioread('SpeechDFT-16-8-mono-5secs.wav');  % speech sample found in the Matlab Audio Toolbox 
        y_resampled = resample(y,model_params.Fs,Fs);  % resample to change the sample rate to SG.Fs
        %Nsamples = length(y_resampled);
        Nsamples = 24000;  % reduce the number of samples to reduce simulation time
        model_params.test_signal.left  = y_resampled(1:Nsamples);
        model_params.test_signal.right = y_resampled(1:Nsamples);
        model_params.test_signal.Nsamples = length(model_params.test_signal.left);
        model_params.test_signal.duration = model_params.test_signal.Nsamples * model_params.Ts;
    case 3 % user supplied music
        [y,Fs] = audioread([model_params.test_signals_path '\' 'Urban_Light_HedaMusic_Creative_Commons.mp3']); 
        y_resampled = resample(y,model_params.Fs,Fs);  % resample to change the sample rate to SG.Fs
        %Nsamples = length(y_resampled);
        Nsamples = 24000;  % reduce the number of samples to reduce simulation time
        model_params.test_signal.left  = y_resampled(1:Nsamples);
        model_params.test_signal.right = y_resampled(1:Nsamples);
        model_params.test_signal.Nsamples = length(model_params.test_signal.left);
        model_params.test_signal.duration = model_params.test_signal.Nsamples * model_params.Ts;
    otherwise
        disp('Please choose a viable option for the test signal')
end
