% Copyright 2019 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Matthew Blunt
% Audio Logic
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com

% Auditory Nerve Simulink Model Code
% AN_StopFcn_Callback
% 08/02/2019

%% NOTES

% The following script is designed to take the output data from the
% Auditory Nerve Simulink model and display various plots. 
% In addition, if the user wishes to compare the model with source code
% functions for verification purposes, they can set the verification flag
% to 'true' in the 'AN_InitFcn_Callback' script, which will cause the 
% functions to be compiled and called within this script after the 
% Simulink simulation is complete.



%% CREATE MEX WRAPPERS FOR C FUNCTIONS

if verificationflag == true % only execute verification is flag is true

% The following creates mex wrappers for all C functions used, allowing for
% the functions to be called via MATLAB

% Change directories in order to access C files
cd AN_Model_Verification

% Get mex wrapper for all C files
mex WbGammaTone.c complex.c
mex Boltzman.c complex.c
mex OhcLowPass.c complex.c
mex NLafterohc.c complex.c
mex C1ChirpFilt.c complex.c
mex C2ChirpFilt.c complex.c
mex NLogarithm.c complex.c
mex IhcLowPass.c complex.c

% Go back to original folder (AN_Simulink_Model_v1_Doubles)
cd ..

end % end of verification flag conditional statement


%% CALL MODEL FUNCTIONS

if verificationflag == true % only execute verification is flag is true

% Get middle ear filter output
meout = (Middle_Ear(RxSignal,Fs,tdres))';

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

% Call synapse functions
powerLawIn = NLBeforePLA(ihcout, totalstim, spont, cf);
synout = PowerLaw(powerLawIn, totalstim, noise, Fs);

end % end of verification flag conditional statement


%% COMPARISON PLOTS

if verificationflag == true % only execute verification is flag is true
    
% The following plots show various results from the Simulink Model,
% including comparisons to the source code results.

figure('units','normalized','outerposition',[0.5 2/3 0.5 1/3])
subplot(2,1,1)
plot(meout);
title('Middle Ear Filter Pressure Output (meout) - Source Code')
ylabel('Pressure [Pa]');
xlabel('Sample Number');
subplot(2,1,2)
plot(out.meout(1:end-1))
title('Middle Ear Filter Pressure Output (meout) - Simulink Model')
ylabel('Pressure [Pa]');
xlabel('Sample Number');

figure('units','normalized','outerposition',[0.5 1/3 0.5 1/3])
subplot(2,1,1)
plot(ihcout);
title('Inner Hair Cell Relative Membrane Potential (ihcout) - Source Code')
ylabel('Relative Potential [V]');
xlabel('Sample Number');
subplot(2,1,2)
plot(out.ihcout(1:end-1))
title('Inner Hair Cell Relative Membrane Potential (ihcout) - Simulink Model')
ylabel('Relative Potential [V]');
xlabel('Sample Number');

figure('units','normalized','outerposition',[0.5 0 0.5 1/3])
subplot(2,1,1)
plot(synout);
title('Mean Synaptic Release Rate (synout) - Source Code');
ylabel('Release Rate [/s]');
xlabel('Sample Number');
subplot(2,1,2)
plot(out.synout(1:end-1));
title('Mean Synaptic Release Rate (synout) - Simulink Model');
ylabel('Release Rate [/s]');
xlabel('Sample Number');

end % end of verification flag conditional statement


%% SIMULINK OUTPUT PLOTS

if verificationflag == true % only execute verification is flag is true

    figure('units','normalized','outerposition',[0 0 0.5 1])

    subplot(3,1,1)
    stem(out.sptime(1:end-1));
    title('Spike Train Output (sptime) - Simulink Model');
    ylabel('Spike Indicator');
    xlabel('Sample Number');

    subplot(3,1,2)
    plot(out.trd_vector(1:end-1));
    title('Mean Synaptic Redocking Time - Simulink Model');
    ylabel('Redocking Time [sec]');
    xlabel('Sample Number');

    subplot(3,1,3)
    plot(out.meanrate(1:end-1));
    title('Mean of Spike Rate - Simulink Model');
    ylabel('Mean Rate [/s]');
    xlabel('Sample Number');
    
else
    
    figure('units','normalized','outerposition',[0 0 1 1])
    
    subplot(3,2,1)
    plot(out.meout(1:end-1))
    title('Middle Ear Filter Pressure Output (meout) - Simulink Model')
    ylabel('Pressure [Pa]');
    xlabel('Sample Number');

    subplot(3,2,3)
    plot(out.ihcout(1:end-1))
    title('Inner Hair Cell Relative Membrane Potential (ihcout) - Simulink Model')
    ylabel('Relative Potential [V]');
    xlabel('Sample Number');

    subplot(3,2,5)
    plot(out.synout(1:end-1));
    title('Mean Synaptic Release Rate (synout) - Simulink Model');
    ylabel('Release Rate [/s]');
    xlabel('Sample Number');

    subplot(3,2,2)
    stem(out.sptime(1:end-1));
    title('Spike Train Output (sptime) - Simulink Model');
    ylabel('Spike Indicator');
    xlabel('Sample Number');

    subplot(3,2,4)
    plot(out.trd_vector(1:end-1));
    title('Mean Synaptic Redocking Time - Simulink Model');
    ylabel('Redocking Time [sec]');
    xlabel('Sample Number');

    subplot(3,2,6)
    plot(out.meanrate(1:end-1));
    title('Mean of Spike Rate - Simulink Model');
    ylabel('Mean Rate [/s]');
    xlabel('Sample Number');

end


%% VECTOR COMPARISON

if verificationflag == true % only execute verification is flag is true

% Finds the Euclidean norm error for each output vector

midearerror = norm(meout(1:end)-out.meout(1:end-1));
disp('Middle Ear Error = ');
disp(midearerror);

OHCIHCmodelerror = norm(ihcout(1:end)-out.ihcout(1:end-1));
disp('Hair Cell Model Error =');
disp(OHCIHCmodelerror);

synouterror = norm(synout(1:end) - out.synout(1:end-1));
disp('Synapse Error =');
disp(synouterror);

end % end of verification flag conditional statement


% End of AN_StopFcn_Callback
