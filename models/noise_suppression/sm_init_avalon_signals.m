% mp = sm_init_avalon_signals(mp)
%
% Matlab function that puts the test signals into the Avalon Streaming
% interface format that uses the data-channel-valid protocol.
%
% Inputs:
%   mp, which is the model data structure that holds the model parameters
%
% Outputs:
%   mp, the model data structure that now contains the Avalon signals: 
%          mp.Avalon_Source_Data    - The Avalon streaming data bus
%          mp.Avalon_Source_Valid   - The Avalon streaming valid signal
%          mp.Avalon_Source_Channel - The Avalon streaming channel bus
%          mp.Avalon_Source_Error   - The Avalon streaming error bus
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


function mp = sm_init_avalon_signals(mp)

%% create the data-channel-valid signals from the test signals
mp.Nsamples_avalon = mp.test_signal.Nsamples * mp.rate_change;
datavals_data    = zeros(2,mp.Nsamples_avalon);   % preallocate arrays
datavals_valid   = zeros(1,mp.Nsamples_avalon); 
datavals_channel = zeros(1,mp.Nsamples_avalon); 
datavals_error   = zeros(1,mp.Nsamples_avalon); 
dataval_index = 1;
% for sample_index = 1:mp.test_signal.Nsamples
%     ----------------------------
%     left channel
%     ----------------------------
%     datavals_data(sample_index, 1)     = mp.test_signal.left(sample_index); 
%     ----------------------------
%     right channel
%     ----------------------------
%     datavals_data(sample_index, 2)     = mp.test_signal.right(sample_index); 
%     %---------------------------------------------
%     fill in the invalid data slots with zeros
%     ---------------------------------------------
%     for k=1:(mp.rate_change-2)
%         datavals_data(dataval_index)    = 0;  % no data (put in zeros)
%         datavals_valid(dataval_index)   = 0;  % data is not valid in these time bins
%         datavals_channel(dataval_index) = 3;  % channel 3 = no data
%         datavals_error(dataval_index)   = 0;  % no error
%         dataval_index                   = dataval_index + 1;
%     end
% end

%% Convert to time series objects that can be read from "From Workspace" blocks
Ndatavals = length(datavals_data);  % get number of data points
timevals  =  [0 1:(mp.test_signal.Nsamples-1)]'*mp.Ts_system;  % get associated times assuming system clock
mp.Avalon_Source_Data     = timeseries([mp.test_signal.left, mp.test_signal.right],timevals);


