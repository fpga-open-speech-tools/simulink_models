classdef AvalonSignal
    %AVALONSIGNAL Represents an Avalon Signal used during simulation
    %   Detailed explanation goes here
    
    properties
        data
        valid
        channel
        error
    end
    
    properties (Dependent)
        asStruct
    end
    
    methods
        function obj = AvalonSignal(data, valid, channel, error)
            if nargin == 0
               obj.data = fi(0,1,24,23);
               obj.valid = fi(0,0,2,0);
               obj.channel = fi(0,0,2,0);
               obj.error = fi(0,0,2,0);
               return
            end
                
            obj.data = data;
            obj.valid = valid;
            obj.channel = channel;
            obj.error = error;
        end
        
        function asStruct = get.asStruct(obj)
            asStruct.data = obj.data;
            asStruct.valid = obj.valid;
            asStruct.channel = obj.channel;
            asStruct.error = obj.error;
        end
    end
end

