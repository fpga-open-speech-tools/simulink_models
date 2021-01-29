% mp = sm_stop_verify(mp)
%
% Matlab function that verifies the model output 

% Inputs:
%   mp
%
% Outputs:
%   mp

% Copyright 2019 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Audio Logic
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

close all;

subplot(3,1,1)
plot(testSignal.audio(:,1));
title('signal at each sensor')
subplot(3,1,2)
plot(dataOut)
title('beamformed signal')

subplot(3,1,3)
plot(audioread([mp.test_signals_path filesep 'noisySpeech.wav'], [1, testSignal.nSamples]))
title('original audio 1')

% original_audio = [mp.test_signal.left(:) mp.test_signal.right(:)];
% processed_audio = [mp.left_data_out(:) mp.right_data_out(:)];
% soundsc(original_audio, mp.Fs);
% pause(mp.test_signal.duration*1.1);
% soundsc(processed_audio, mp.Fs);
