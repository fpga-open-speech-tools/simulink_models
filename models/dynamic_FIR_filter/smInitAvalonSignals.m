% mp = smInitAvalonSignals(mp)
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


function mp = smInitAvalonSignals(mp)

%% create the data-channel-valid signals from the test signals
mp.avalonSamples = mp.testSignal.nSamples * mp.rateChange;
avalonSourceData    = zeros(1,mp.avalonSamples);   % preallocate arrays
avalonSourceValid   = zeros(1,mp.avalonSamples); 
avalonSourceChannel = zeros(1,mp.avalonSamples); 
avalonSourceError   = zeros(1,mp.avalonSamples); 
avalonIndex = 1;
for sampleIndex = 1:mp.testSignal.nSamples
    %----------------------------
    % left channel
    %----------------------------
    avalonSourceData(avalonIndex)     = mp.testSignal.left(sampleIndex); 
    avalonSourceValid(avalonIndex)    = 1;   % data is valid in this time bin
    avalonSourceChannel(avalonIndex)  = 0;   % channel 0 = left
    avalonSourceError(avalonIndex)    = 0;   % no error
    avalonIndex                    = avalonIndex + 1;
    
    %---------------------------------------------
    % fill in the invalid data slots with ZOH
    %---------------------------------------------
    for k=1:(mp.rateChange/2-1)
        avalonSourceData(avalonIndex)    = mp.testSignal.left(sampleIndex);  % ZOH data
        avalonSourceValid(avalonIndex)   = 0;  % data is not valid in these time bins
        avalonSourceChannel(avalonIndex) = 0;  % channel 0 = left
        avalonSourceError(avalonIndex)   = 0;  % no error
        avalonIndex                   = avalonIndex + 1;
    end
    
    %----------------------------
    % right channel
    %----------------------------
    avalonSourceData(avalonIndex)     = mp.testSignal.right(sampleIndex); 
    avalonSourceValid(avalonIndex)    = 1;  % data is valid in this time bin
    avalonSourceChannel(avalonIndex)  = 1;  % channel 1 = right
    avalonSourceError(avalonIndex)    = 0;  % no error
    avalonIndex                    = avalonIndex + 1;
    
    %---------------------------------------------
    % fill in the invalid data slots with ZOH
    %---------------------------------------------
    for k=1:(mp.rateChange/2-1)
        avalonSourceData(avalonIndex)    = mp.testSignal.right(sampleIndex);  % ZOH data
        avalonSourceValid(avalonIndex)   = 0;  % data is not valid in these time bins
        avalonSourceChannel(avalonIndex) = 1;  % channel 1 = right
        avalonSourceError(avalonIndex)   = 0;  % no error
        avalonIndex                   = avalonIndex + 1;
    end
end

%% Convert to time series objects that can be read from "From Workspace" blocks
nDataPoints = length(avalonSourceData);  % get number of data points
timeVals  =  [0:(nDataPoints-1)]*mp.systemTs;  % get associated times assuming system clock
mp.Avalon_Source_Data     = timeseries(avalonSourceData,timeVals);
mp.Avalon_Source_Valid    = timeseries(avalonSourceValid,timeVals);
mp.Avalon_Source_Channel  = timeseries(avalonSourceChannel,timeVals);
mp.Avalon_Source_Error    = timeseries(avalonSourceError,timeVals);

