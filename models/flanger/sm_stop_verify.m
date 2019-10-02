% mp = sm_stop_verify(mp)
%
% Matlab function that verifies the model output

% Inputs:
%   mp, which is the model data structure that holds the model parameters
%
% Outputs:
%   mp, the model data structure that now contains the left/right channel
%   data, which is in the following format:
%          mp.left_data_out         - The processed left channel data
%          mp.left_time_out         - time of left channel data
%          mp.right_data_out        - The processed right channel data
%          mp.right_time_out        - time of right channel data
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

function mp = sm_stop_verify(mp)

% figure(1)
% plot(mp.test_signal.left); hold on
% plot(mp.left_data_out)
% title(['Rate = ' num2str(mp.register(2).value) '  Regen = ' num2str(mp.register(3).value)])
% legend('input', 'output')

% original_audio = [mp.test_signal.left(:) mp.test_signal.right(:)];
processed_audio = [mp.left_data_out(:) mp.right_data_out(:)];
% soundsc(original_audio, mp.Fs);
% pause(mp.test_signal.duration*1.1);
soundsc(processed_audio, mp.Fs);
