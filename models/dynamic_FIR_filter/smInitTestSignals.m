% mp = smInitTestSignals(mp)
%
% This function creates and initializes the test signals that are used 
% in the model simulation.
%
% Inputs:
%   mp, which is the model data structure that holds the model parameters
%
% Outputs:
%   mp, the model data structure that now contains the test signals in the 
%   field mp.testSignal, which has the following fields:
%         mp.testSignal.duration  -  length of test signals in seconds
%         mp.testSignal.nSamples  -  number of samples in test signals
%         mp.testSignal.left      -  signal for left channel
%         mp.testSignal.right     -  signal for right channel
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
% Justin P. Williams
% Flat Earth Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com

function mp = smInitTestSignals(mp)

signalOption = 1;  % set which test signal to use
switch signalOption
    case 1 % Justin Supplied Speech Signal
%         [y, Fs] = audioread([mp.testSignalsPath filesep '1kto2k_chirp.wav']);
        [y, Fs] = audioread('1kto2k_chirp.wav'); %y(ceil(length(y)/2):end) for high freq section
        yResampled = resample(y,mp.sampleFs,Fs);  % resample to change the sample rate to SG.Fs
        nSamples = length(yResampled);
        if mp.fastSimFlag == 1 % perform fast simulation, clock rate is slower so more samples can be afforded
           mp.testSignal.nSamples = max(nSamples, mp.fastSimSamples);
        else
           mp.testSignal.nSamples = mp.fastSimSamples;
        end
        mp.testSignal.left  = yResampled(1:mp.testSignal.nSamples);
        mp.testSignal.right = yResampled(1:mp.testSignal.nSamples);
        mp.testSignal.duration = mp.testSignal.nSamples * mp.sampleTs;
    otherwise
        error('Please choose a viable option for the test signal (see smInitTestSignals)')
end
