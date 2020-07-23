classdef AudioSource
    %AUDIOSOURCE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        audio
        nSamples
        duration
        sampleRateHz
    end
    
    methods
        function obj = AudioSource(audio, nSamples, sampleRateHz)
            obj.audio = audio;
            obj.nSamples = nSamples;
            obj.sampleRateHz = sampleRateHz;
            obj.duration = size(nSamples, 1) /sampleRateHz;
            
        end
        
        function avalonSource = toAvalonSource(this, overSamplingFactor, audiodt)
            arguments
               this AudioSource
               overSamplingFactor 
               audiodt
            end
            nSamplesAvalon = this.nSamples * overSamplingFactor;
            defaultSignal = AvalonSignal(fi(0, audiodt), fi(0,0,2,0), fi(0,0,2,0), fi(0,0,2,0));
            %test = repmat(defaultSignal, this.nSamples, 1);
            %disp(size(test))
            signals = repmat(defaultSignal, nSamplesAvalon, 1);

            valid = fi(1,0,2,0);
            noerror = fi(0,0,2,0);
            fiaudio = fi(this.audio, audiodt);
            fichannel = fi(0:(size(this.audio,1) - 1), 0, 2, 0);

            for sample_idx = 1:this.nSamples
                 offset = overSamplingFactor * (sample_idx - 1);
                 for k=1:size(this.audio,1)
                    signals(k + offset).data     = fiaudio(k, sample_idx); 
                    signals(k + offset).valid    = valid;   
                    signals(k + offset).channel  = fichannel(k);   
                    signals(k + offset).error    = noerror;   % no error
                 end
            end
            avalonSource = AvalonSource(signals);

        end
    end
end

