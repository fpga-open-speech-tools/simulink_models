classdef Hardware
    %HARDWARE Represents target hardware attributes
    
    properties
        deviceFamily
        device
    end
    enumeration
        AudioMini('Cyclone V', '5CSEBA6U23I7')
        AudioBlade('Arria 10', '10AS066H2F34I1HG')
    end
    methods
        function obj = Hardware(deviceFamily, device)
            %HARDWARE Construct an instance of this enumeration
            obj.deviceFamily = deviceFamily;
            obj.device = device;
        end
    end
end

