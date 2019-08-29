function hdlblkmask_streaming_number_of_samples_cb(blk)

%   Copyright 2018 The MathWorks, Inc.

%check if Number of Samples is a positive integer for the Streaming modes
%and throw error
opMode = get_param(blk,'opMode');
          
num_samples = get_param(blk,'num_samples');

if(strcmp(opMode, 'Streaming - using Number of Samples'))
    if(str2double(num_samples)<=0)
        error(message('hdlcoder:validate:MultiplyAccumulateNumberOfSamples'));
    end
end

end
