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

function mp = sm_stop_verify(mp)

%% Verify that the test data got encoded, passed through the model, and
% % decoded correctly.  The input (modified by gain) and output values should be identical.
% 
% mp.left_error_max  = max(abs(mp.test_signal.left*mp.register(1).value-mp.left_data_out));
% mp.right_error_max = max(abs(mp.test_signal.left*mp.register(2).value-mp.right_data_out));
% mp.precision = 2^(-mp.F_bits);
% % display popup message
%     str1 = [' Max Left Error = ' num2str(mp.left_error_max) '\n Max Right Error = ' num2str(mp.right_error_max)];
%     str1 = [str1 ' Max Left Error = ' num2str(mp.left_error_max) '\n Max Right Error = ' num2str(mp.right_error_max)];
% if (mp.left_error_max <= mp.precision) & (mp.right_error_max <= mp.precision)
%     str1 = [str1 '\n Error is within exceptable range \n Least significant bit precision (F_bits = ' num2str(mp.F_bits) ') is ' num2str(2^(-mp.F_bits))];
%     helpdlg(sprintf(str1),'Verification Message: Passed')
% else
%     str1 = [str1 '\n Error is **NOT** within exceptable range \n Least significant bit precision (F_bits = ' num2str(mp.F_bits) ') is ' num2str(2^(-mp.F_bits))];
%     helpdlg(sprintf(str1),'Verification Message: Failed')
% end
