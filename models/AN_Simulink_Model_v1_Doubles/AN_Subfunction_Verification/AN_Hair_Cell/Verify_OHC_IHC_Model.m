% Copyright 2019 Flat Earth Inc
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Matthew Blunt
% Flat Earth Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com

% Auditory Nerve Simulink Model Code
% Verify_OHC_IHC_Model
% 07/31/2019

%% NOTES

% The following script is designed to isolate and test the OHC/IHC Model
% functions found in the model_IHC_BEZ2018.c file in order to verify
% Simulink model functionality

%% CREATE MEX WRAPPERS FOR C FUNCTIONS

mex WbGammaTone.c complex.c
mex Boltzman.c complex.c
mex OhcLowPass.c complex.c
mex NLafterohc.c complex.c
mex C1ChirpFilt.c complex.c
mex C2ChirpFilt.c complex.c
mex NLogarithm.c complex.c
mex IhcLowPass.c complex.c

%% RUN FUNCTIONS

% Get middle ear filter output
meout = (Middle_Ear(RxSignal, Fs, tdres))';

% Preallocate memory for each output vector
wbout1 = zeros(length(RxSignal),1);
wbout = zeros(length(RxSignal),1);
ohcnonlinout = zeros(length(RxSignal),1);
ohcout = zeros(length(RxSignal),1);
tmptauc1 = zeros(length(RxSignal),1);
tauc1 = zeros(length(RxSignal),1);
rsigma = zeros(length(RxSignal),1);
c1filterouttmp = zeros(length(RxSignal),1);
c2filterouttmp = zeros(length(RxSignal),1);
c1vihctmp = zeros(length(RxSignal),1);
c2vihctmp = zeros(length(RxSignal),1);
ihcout = zeros(length(RxSignal),1);
grd = zeros(length(RxSignal),1);

% Loop through hearing cell functions
for n = 0:length(RxSignal)-1
    wbout1(n+1,1) = WbGammaTone(meout(n+1,1),tdres,centerfreq,n,tauwb,wbgain,wborder);
    wbout(n+1,1) = ((tauwb/TauWBMax)^wborder)*wbout1(n+1,1)*10e3*(max(1,cf/5e3));
    ohcnonlinout(n+1,1) = Boltzman(wbout(n+1,1), ohcasym, s0, s1, x1);
    ohcout(n+1,1) = OhcLowPass(ohcnonlinout(n+1,1),tdres,Fcohc,n,gainohc,orderohc);
    tmptauc1(n+1,1) = NLafterohc(ohcout(n+1,1), bmTaumin, bmTaumax, ohcasym);
    tauc1(n+1,1)    = cohc*(tmptauc1(n+1,1)-bmTaumin)+bmTaumin;
    rsigma(n+1,1) = 1/tauc1(n+1,1) - 1/bmTaumax;
    tauwb = TauWBMax+(tauc1(n+1,1)-bmTaumax)*(TauWBMax-TauWBMin)/(bmTaumax-bmTaumin);
    [wbgain,grdelay] = gain_groupdelay(tdres,centerfreq,cf,tauwb);
    c1filterouttmp(n+1,1) = C1ChirpFilt(meout(n+1,1),tdres,cf,n,bmTaumax,rsigma(n+1,1));
    c2filterouttmp(n+1,1) = C2ChirpFilt(meout(n+1,1),tdres,cf,n,bmTaumax,1/ratiobm);
    c1vihctmp(n+1,1) = NLogarithm(cihc*c1filterouttmp(n+1,1),C1slope,ihcasym,cf);
    c2vihctmp(n+1,1) = -NLogarithm(c2filterouttmp(n+1,1)*abs(c2filterouttmp(n+1,1))*cf/10*cf/2e3,C2slope,1.0,cf);
    ihcout(n+1,1) = IhcLowPass(c1vihctmp(n+1,1)+c2vihctmp(n+1,1),tdres,Fcihc,n,gainihc,orderihc);
    grd(n+1,1) = grdelay;
end

%% COMPARISON PLOT

figure()
subplot(2,1,1)
plot(ihcout);
title('Inner Hair Cell Relative Membrane Potential (ihcout) - Source Code')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.ihcout(1:end-1))
title('Inner Hair Cell Relative Membrane Potential (ihcout) - Simulink Model')
xlabel('Sample Number');

figure()
subplot(2,1,1)
plot(rsigma);
title('Hair Cell Model rsigma Output - Source Code')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.rsigma(1:end-1))
title('Hair Cell Model rsigma Output - Simulink Model')
xlabel('Sample Number');

figure()
subplot(2,1,1)
plot(tauc1);
title('Hair Cell Model tauc1 Output - Source Code')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.tauc1(1:end-1))
title('Hair Cell Model tauc1 Output - Simulink Model')
xlabel('Sample Number');

%% VECTOR COMPARISON

OHCIHCmodelerror = norm(ihcout(1:end)-out.ihcout(1:end-1));
disp('ihcout Error =');
disp(OHCIHCmodelerror);

rsigmaerror = norm(rsigma(1:end)-out.rsigma(1:end-1));
disp('rsigma Error = ');
disp(rsigmaerror);

tauc1error = norm(tauc1(1:end)-out.tauc1(1:end-1));
disp('tauc1 Error = ');
disp(tauc1error);


