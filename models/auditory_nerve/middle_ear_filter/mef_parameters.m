%% DECLARING PARAMETERS
% characteristic frequency of the neuron (must be between 125 Hz and 20000 Hz)
cf = 1000; 
% sampling rate
Fs = 48e3;

% histogram binsize in seconds, defined as 1/sampling rate
tdres = 1/Fs;

% number of repititions for the peri-stimulus time histogram
% (must always be 1 for Simulink Model)
nrep = 1; 

% outer hair cell impairment constant ( from 0 to 1 )
cohc = 1; 

% inner hair cell impairment constant ( from 0 to 1 )
cihc = 1;

% species associated with model ( 1 for cat, 2 or 3 for human )
species = 2;

% Absolute refractory period
tabs   = 0.6e-3; 

% Baseline mean relative refractory period
trel   = 0.6e-3; 


%% Middle Ear Filter
feature('SetPrecision', 24);
% Prewarping frequency of 1kHz
fp = 1e3;
C  = 2*pi*fp/tan(2*pi/2*fp*tdres);
% 1st Second Order IIR Coefficients
m11=1/(C^2+5.9761e+003*C+2.5255e+007); 
m12=-2*C^2+2*2.5255e+007;
m13= C^2-5.9761e+003*C+2.5255e+007;
m14=C^2+5.6665e+003*C; 
m15=-2*C^2;
m16=C^2-5.6665e+003*C;
% 2nd Second Order IIR Coefficients
m21=1/(C^2+6.4255e+003*C+1.3975e+008); 
m22=-2*C^2+2*1.3975e+008;
m23=C^2-6.4255e+003*C+1.3975e+008;
m24=C^2+5.8934e+003*C+1.7926e+008; 
m25=-2*C^2+2*1.7926e+008;	
m26=C^2-5.8934e+003*C+1.7926e+008;
% 3rd Second Order IIR Coefficients
m31=1/(C^2+2.4891e+004*C+1.2700e+009); 
m32=-2*C^2+2*1.2700e+009;
m33=C^2-2.4891e+004*C+1.2700e+009;
m34=(3.1137e+003*C+6.9768e+008);    
m35=2*6.9768e+008;				
m36=-3.1137e+003*C+6.9768e+008; 
megainmax = 2;
% Organized Middle Ear Filter Coefficients Matrix
MEcoeffs = [m14*m11 m15*m11 m16*m11 1 m12*m11 m13*m11; m24*m21 m25*m21 m26*m21 1 m22*m21 m23*m21; m34*m31 m35*m31 m36*m31 1 m32*m31 m33*m31];
% Simplified Scaling Factor for ME Filter
MEscale = 1/megainmax;