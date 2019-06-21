% model_params = SG_stop_verify(model_params)
%
% Matlab function that verifies the model output 

% Inputs:
%   model_params, which is the model data structure that holds the model parameters
%
% Outputs:
%   model_params, the model data structure that now contains the left/right channel
%   data, which is in the following format:
%          model_params.left_data_out         - The processed left channel data
%          model_params.left_time_out         - time of left channel data
%          model_params.right_data_out        - The processed right channel data
%          model_params.right_time_out        - time of right channel data
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

function model_params = SG_stop_verify(model_params)

%% Verify that the test data got encoded, passed through the model, and
% decoded correctly.  The input (modified by gain) and output values should be identical.

model_params.left_error_max  = max(abs(model_params.test_signal.left*model_params.register(1).value-model_params.left_data_out));
model_params.right_error_max = max(abs(model_params.test_signal.left*model_params.register(2).value-model_params.right_data_out));
model_params.precision = 2^(-model_params.F_bits);
% display popup message
if (model_params.left_error_max <= model_params.precision) && (model_params.right_error_max <= model_params.precision)
    helpdlg(sprintf([' Max Left Error = ' num2str(model_params.left_error_max) '\n Max Right Error = ' num2str(model_params.right_error_max) '\n Error is within exceptable range \n Least significant bit precision (F_bits = ' num2str(model_params.F_bits) ') is ' num2str(2^(-model_params.F_bits))]))
else
    helpdlg(sprintf([' Max Left Error = ' num2str(model_params.left_error_max) '\n Max Right Error = ' num2str(model_params.right_error_max) '\n Error is NOT within exceptable range \n Least significant bit precision (F_bits = ' num2str(model_params.F_bits) ') is ' num2str(2^(-model_params.F_bits))]))
end
