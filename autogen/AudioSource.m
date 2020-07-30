% AudioSource 
% This class represents an audio source for use with Autogen.

% Copyright 2020 Audio Logic
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
        nChannels
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
            
            nSamplesAvalon = this.nSamples * this.nChannels;
            
            data = zeros(nSamplesAvalon, 1);
            valid = ones(nSamplesAvalon, 1);
            error = zeros(nSamplesAvalon, 1);
            channel = zeros(nSamplesAvalon, 1);
            
            for k=1:this.nChannels
                data(k:2:(nSamplesAvalon - 1 + k)) = this.audio(:, k);
                channel(k:2:(nSamplesAvalon - 1 + k))= k - 1;
            end 
            avalonSource = AvalonSource(data, channel, valid, error, 1 / this.sampleRateHz / this.nChannels);

        end
    end
    methods(Static)
        function audioSource = fromFile(filepath, sampleRate, nSamples)
            info = audioinfo(filepath);
            fileFs = info.SampleRate;
            
            if nSamples ~= -1 % perform fast simulation by reducing the number of samples
               simTime = nSamples / sampleRate;
               totalSamples = info.TotalSamples;
               nSourceSamples = min(simTime * fileFs, totalSamples);
               [y,~] = audioread(filepath,[1, nSourceSamples]);

            else
               [y,~] = audioread(filepath);
            end     
            yResampled = resample(y,sampleRate, fileFs);

            audioSource = AudioSource(yResampled, sampleRate);
        end
    end
    methods(Access = private)
        function obj = updateAudioInfo(obj)
            obj.nChannels = size(obj.audio,2);
            obj.nSamples = size(obj.audio,1);
            obj.duration = obj.nSamples /obj.sampleRateHz;
        end
    end
end

