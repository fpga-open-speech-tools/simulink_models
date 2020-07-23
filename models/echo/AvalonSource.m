classdef AvalonSource
    %AVALONSOURCE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        signals (:, 1) AvalonSignal
    end
    methods
        function obj = AvalonSource(signals)
            arguments
               signals (:,1) AvalonSignal
            end
            %AVALONSOURCE Construct an instance of this class
            %   Detailed explanation goes here
            obj.signals = signals;
        end
        function obj = astimeseries(this, timeSample)
           nSamples = size(this.signals, 1);
           timeVals  =  [0 1:(nSamples-1)]*timeSample;  % get associated times assuming system clock
           mp.data = this.signals.data;
           return
          % obj.data = timeseries(, timeVals); 
           obj.channel = timeseries(transpose([this.signals.channel]), timeVals); 
           obj.valid = timeseries([this.signals.valid], timeVals); 
           obj.error = timeseries([this.signals.error], timeVals); 
        end
    end
        
end

