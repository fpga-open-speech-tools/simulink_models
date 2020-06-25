% PostSNR Simulink Model Initialization Fcn
%
%
% This function is called to declare variables and their required memory
% allocation for the Simulink Posteriori SNR Verification Model.

% Copyright 2019 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Justin P Williams
% Flat Earth Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com

% Variable Declaration
FFT_size = 64;
nSamp = 6;
Fs = 48000;
Ts = 1/Fs;

t = 0 : Ts : (nSamp - 1)*Ts;
t = t';

noiseVariance = rand([6, FFT_size]);
framePower    = rand([6, FFT_size]);
noiseVarianceSim = [t, noiseVariance];
framePowerSim    = [t, framePower];
postSNRa = min(framePower./noiseVariance,40);

figure(1);
subplot(211);
stem(noiseVariance(1,:)); xlabel('Samples'); title('Initial Noise Variance Input -- Frame 1');
subplot(212);
stem(framePower(1,:));    xlabel('Samples'); title('Initial Frame Power Input -- Frame 1');
print('postSNR_Inputs', '-djpeg');
% THERE IS NO BLOCK DELAY FOR POSTSNR REEE







