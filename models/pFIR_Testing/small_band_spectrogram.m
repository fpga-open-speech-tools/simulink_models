% function [freqOut] = small_band_spectrogram(x, win, desiredFreqRange)
%%This function is designed to plot spectrograms of desired frequency
%%ranges and account for the time-frequency tradeoff. 
%
% inputs: 
%           x       - Input audio signal
%           win     - Window size [long windows -> high resolution]
%           timeRes - Time resolution [changes in time -> short windows]
%  desiredFreqRange - [minFreq maxFreq]
% outputs:
%           

% Copyright 2019 Flat Earth Inc
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Justin P Williams
% Flat Earth Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com

%% DELETE ME WHEN DONE
clc; clear; close all;
[x, Fs] = audioread('testchirp.wav');
N = 32;
desiredFreqRange = [80 180];
%% Variable Declaration
freqRes  = Fs/N; 
win      = zeros(freqRes, 1);
win(1:N) = x(1:N);
nOverlap = 2;
numSlides  = (length(x)-1) / freqRes;
%% Spectrogram Frequency Calculation
%%%%%%%%%%%%%% 
% Algo outline
%%%%%%%%%%%%%%
% 1. Take short window of the signal
%    1a. Zero pad the signal up to freqRes
% 2. Slide short window along the signal with timeRes increments
%    2a. Concatenate frequency vector outputs within desired frequency
%    range
% 3. Multiply by 20*log10(freqVect), then send to colormap fcn

%%%%%%%%%%%%
% Begin Algo
%%%%%%%%%%%%
for i = 1:numSlids
    freq = fft(x, win);
    ind  = [(i+N/2) ()];
    win(1:N) = x(ind(1):ind(2));
end

% end