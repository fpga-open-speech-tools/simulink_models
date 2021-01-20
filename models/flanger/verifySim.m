% verifySim
%
% Matlab scripts that verifies the model output 

% Global variables used:
%   mp, which is the model data structure that holds the model parameters
%   testSignal, the original audio before simulation

% Copyright 2019 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Ross K. Snider
% Audio Logic
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

%% Verify that the test data got encoded, passed through the model, and
% decoded correctly.  The input (modified by gain) and output values should be identical.

figure(1)
subplot(2,1,1)
plot(testSignal.audio(:,1)); hold on
plot(data_out(:,1))
title(['Rate = ' num2str(mp.register{2}.value) ' Enable = ' num2str(mp.register{1}.value) ' Regen = ' num2str(mp.register{3}.value)])

subplot(2,1,2)
plot(testSignal.audio(:,2)); hold on
plot(data_out(:,2))
title(['Rate = ' num2str(mp.register{2}.value) ' Enable = ' num2str(mp.register{1}.value) ' Regen = ' num2str(mp.register{3}.value)])

% original_audio = [mp.test_signal.left(:) mp.test_signal.right(:)];
% processed_audio = [mp.left_data_out(:) mp.right_data_out(:)];
% soundsc(original_audio, mp.Fs);
% pause(mp.test_signal.duration*1.1);
% soundsc(processed_audio, mp.Fs);
