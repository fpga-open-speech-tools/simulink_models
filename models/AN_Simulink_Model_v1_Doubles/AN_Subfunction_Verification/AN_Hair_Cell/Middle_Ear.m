% Middle_Ear() - A MATLAB function created to recreate the 6th order IIR
% filter implemented in the AN model C source code
%
% meout = Middle_Ear(stimulus, Fs, tdres)
%
% The filter takes in the sound pressure stimulus, sampling rate, and
% the binsize and returns the filtered signal.
%
% Inputs:
%   stimulus = sound pressure stimulus vector
%   Fs = sampling rate
%   tdres = binsize, or sampling period
%
% Outputs:
%   meout = filtered signal output waveform

% ---------------------------------------------------------------------- %

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
% Middle_Ear MATLAB Function
% 06/26/2019

% ---------------------------------------------------------------------- %

% Function copied from AN model C source code, with a few minor adjustments
% in order for the function to operate in MATLAB

function meout = Middle_Ear(stimulus, Fs, tdres)
double megainmax;

% NOTE: edited from original function to match signal length
totalstim = length(stimulus);

 
 mey1= zeros(1,totalstim);
 mey2= zeros(1,totalstim);
 mey3= zeros(1,totalstim);
 meout= zeros(1,totalstim);
 %px= zeros(1,totalstim);
 B = zeros(totalstim,1);
 
 
px=stimulus;
TWOPI= 6.28318530717959;
fp = 1000; % /* prewarping frequency 1 kHz */
C  = TWOPI*fp/tan(TWOPI/2*fp*tdres);

m11=1/(C^2+5.9761e+003*C+2.5255e+007);

m12=-2*C^2+2*2.5255e+007;

m13= C^2-5.9761e+003*C+2.5255e+007;

m14=C^2+5.6665e+003*C; 

m15=-2*C^2;

m16=C^2-5.6665e+003*C;
         
m21=1/(C^2+6.4255e+003*C+1.3975e+008);

m22=-2*C^2+2*1.3975e+008;

m23=C^2-6.4255e+003*C+1.3975e+008;

m24=C^2+5.8934e+003*C+1.7926e+008; 

m25=-2*C^2+2*1.7926e+008;	

m26=C^2-5.8934e+003*C+1.7926e+008;
 
m31=1/(C^2+2.4891e+004*C+1.2700e+009);

m32=-2*C^2+2*1.2700e+009;

m33=C^2-2.4891e+004*C+1.2700e+009;

m34=(3.1137e+003*C+6.9768e+008);    

m35=2*6.9768e+008;				

m36=-3.1137e+003*C+6.9768e+008;
         
megainmax=2;

for n=1:length(px)
        
        if (n==1)  %/* Start of the middle-ear filtering section  */
		
	    	mey1(1)  = m11*px(1);
            mey1(1) = m11*m14*px(1);
            mey2(1)  = mey1(1)*m24*m21;
            mey3(1)  = mey2(1)*m34*m31;
            meout(1) = mey3(1)/megainmax ;
        
            
        elseif (n==2)
		
            mey1(2)  = m11*(-m12*mey1(1) + px(2) - px(1));
            %if (species>1) 
            mey1(2) = m11*(-m12*mey1(1)+m14*px(2)+m15*px(1));
			mey2(2)  = m21*(-m22*mey2(1) + m24*mey1(2) + m25*mey1(1));
            mey3(2)  = m31*(-m32*mey3(1) + m34*mey2(2) + m35*mey2(1));
            meout(2) = mey3(2)/megainmax;
		
	    else 
		
            mey1(n)  = m11*(-m12*mey1(n-1)  + px(n)  - px(n-1));
            %if (species>1) 
            mey1(n)= m11*(-m12*mey1(n-1)-m13*mey1(n-2)+m14*px(n)+m15*px(n-1)+m16*px(n-2));
            mey2(n)  = m21*(-m22*mey2(n-1) - m23*mey2(n-2) + m24*mey1(n) + m25*mey1(n-1) + m26*mey1(n-2));
            mey3(n)  = m31*(-m32*mey3(n-1) - m33*mey3(n-2) + m34*mey2(n) + m35*mey2(n-1) + m36*mey2(n-2));
            meout(n) = mey3(n)/megainmax;
		 	%/* End of the middle-ear filtering section */   
            
        end
end

end
