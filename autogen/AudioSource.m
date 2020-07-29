% AudioSource 
%
% This class represents an audio source for use with Autogen.
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
classdef AudioSource
    %AudioSource Represents an audio source for use with Autogen
    properties
        audio
        sampleRateHz
    end
    
    properties(SetAccess = private)
        nSamples
        nChannel
        duration
    end
    
    methods
        function obj = AudioSource(audio, sampleRateHz)
        %AudioSource Initializes AudioSource with m x n audio input and
        % sample rate in hz, where m is the the number of samples and n is
        % the number of channels.
        
            obj.sampleRateHz = sampleRateHz;
            obj.audio = audio;
        end
        
        function obj = set.audio(obj, audio)
           obj.audio = audio;
           obj = obj.updateAudioInfo;
        end
        
        function avalonSource = toAvalonSource(this)
            % Convert this AudioSource to an AvalonSource
            % The AvalonSource will oversample the AudioSource by a rate
            % matching the number of channels in the AudioSource
            arguments
               this AudioSource
            end
            
            nSamplesAvalon = this.nSamples * this.nChannel;
            
            data = zeros(nSamplesAvalon, 1);
            valid = ones(nSamplesAvalon, 1);
            error = zeros(nSamplesAvalon, 1);
            channel = zeros(nSamplesAvalon, 1);
            
            for k=1:this.nChannel
                data(k:2:(nSamplesAvalon - 1 + k)) = this.audio(:, k);
                channel(k:2:(nSamplesAvalon - 1 + k))= k - 1;
            end 
            avalonSource = AvalonSource(data, channel, valid, error);

        end
    end
    
    methods(Access = private)
        function obj = updateAudioInfo(obj)
            obj.nChannel = size(obj.audio,2);
            obj.nSamples = size(obj.audio,1);
            obj.duration = obj.nSamples /obj.sampleRateHz;
        end
    end
end

