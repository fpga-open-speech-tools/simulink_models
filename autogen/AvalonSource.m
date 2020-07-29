% AvalonSource
%
% This class represents an Avalon streaming source during simulation
%
% Copyright 2019 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Dylan Wickham
% Audio Logic
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com
classdef AvalonSource
    %AVALONSOURCE This class represents an Avalon data source
    %   
    
    properties
        data (:, 1) 
        channel (:, 1)
        valid (:, 1)
        error (:, 1)
        nSamples
    end
    methods
        function obj = AvalonSource(data, channel, valid, error)
            arguments
               data (:, 1) 
               channel (:, 1)
               valid (:, 1)
               error (:, 1)
            end
            %AVALONSOURCE Construct an instance of this class
            obj.data = data;
            obj.channel = channel;
            obj.valid = valid;
            obj.error = error;
            obj.nSamples = size(data, 1);
        end
        function obj = astimeseries(this, timeSample)
            % astimeseries returns a struct with AvalonSource's properties
            % as timeseries fields
           
           timeVals  =  [0 1:(this.nSamples-1)]*timeSample;  % get associated times assuming system clock
           obj.data = timeseries(this.data, timeVals); 
           obj.channel = timeseries(this.channel, timeVals); 
           obj.valid = timeseries(this.valid, timeVals); 
           obj.error = timeseries(this.error, timeVals); 
        end
    end
        
end

