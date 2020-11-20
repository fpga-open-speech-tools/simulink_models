% modelparameters.m  
%
% Copyright 2020 AudioLogic, Inc
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Connor Dack
% AudioLogic, Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

%% Autogen parameters
mp.testFile = [mp.test_signals_path filesep 'acoustic.wav'];

mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 15;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;
mp.useAvalonInterface = true;

mp.W_bits = 24;
mp.F_bits = 23;

%% Open MHA DRC Filter Coefficients
c2_random_in  = rand(1,1);
c1_random_in  = rand(1,1);
buf_random_in = rand(1,1);