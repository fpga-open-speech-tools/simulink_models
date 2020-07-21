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


function mp = sm_init_avalon_signals(mp, test_signal)

%% create the data-channel-valid signals from the test signals
mp.Nsamples_avalon = test_signal.Nsamples * mp.rate_change;
datavals_data    = zeros(1,mp.Nsamples_avalon);   % preallocate arrays
datavals_valid   = zeros(1,mp.Nsamples_avalon); 
datavals_channel = zeros(1,mp.Nsamples_avalon); 
datavals_error   = zeros(1,mp.Nsamples_avalon); 
for sample_index = 1:test_signal.Nsamples
    %----------------------------
    % left channel
    %----------------------------
    datavals_data(1)     = test_signal.left(sample_index); 
    datavals_valid(1)    = 1;   % data is valid in this time bin
    datavals_channel(1)  = 0;   % channel 0 = left
    datavals_error(1)    = 0;   % no error
    %----------------------------
    % right channel
    %----------------------------
    datavals_data(2)     = test_signal.right(sample_index); 
    datavals_valid(2)    = 1;  % data is valid in this time bin
    datavals_channel(2)  = 1;  % channel 1 = right
    datavals_error(2)    = 0;  % no error
    %---------------------------------------------
    % fill in the invalid data slots with zeros
    %---------------------------------------------
    for k=3:(mp.rate_change)
        datavals_data(k)    = 0;  % no data (put in zeros)
        datavals_valid(k)   = 0;  % data is not valid in these time bins
        datavals_channel(k) = 0;  % channel is irrelevant because not valid
        datavals_error(k)   = 0;  % no error
    end
end

%% Convert to time series objects that can be read from "From Workspace" blocks
Ndatavals = length(datavals_data);  % get number of data points
timevals  =  [0 1:(Ndatavals-1)]*mp.Ts_system;  % get associated times assuming system clock
mp.Avalon_Source_Data     = timeseries(datavals_data,timevals);
mp.Avalon_Source_Valid    = timeseries(datavals_valid,timevals);
mp.Avalon_Source_Channel  = timeseries(datavals_channel,timevals);
mp.Avalon_Source_Error    = timeseries(datavals_error,timevals);

