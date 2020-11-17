% C2Coefficients() - A MATLAB function created to calculate the C2
% coefficients for the C2 filter, as done in the C2ChirpFilt function in
% the model_IHC_BEZ2018 C source code
%
% [C2coeffs,norm_gain] = C2Coefficients( tdres, cf, taumax, fcohc )
%
% The function takes in the the binsize, neuron characteristic
% frequency, maximum time constant, and filter specific parameter given as
% fcohc, equal to 1/ratiobm in the source code. The function then outputs
% the C2 coefficients as well as the normalizing gain for the filter.
%
% Inputs:
%   tdres = binsize, or sampling period
%   cf = characteristic frequency of neuron
%   taumax = maximum time constant value
%   fcohc = filter specific parameter
%
% Outputs:
%   C2coeffs = C2 filter coefficients
%   norm_gain = C2 filter normalizing gain, applied after the final stage

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
% C2Coefficients MATLAB Function
% 06/27/2019

% ---------------------------------------------------------------------- %

function [C2coeffs,norm_gain] = C2Coefficients(tdres, cf, taumax, fcohc)
    TWOPI = 6.28318530717959;
    % Setup locations of poles and zeros
    sigma0 = 1/taumax;
	ipw    = 1.01*cf*TWOPI-50;
    ipb    = 0.2343*TWOPI*cf-1104;
	rpa    = 10^(log10(cf)*0.9 + 0.55)+ 2000;
	pzero  = 10^(log10(cf)*0.7+1.6)+500;
    
    order_of_pole    = 10;             
    half_order_pole  = order_of_pole/2;
    order_of_zero    = half_order_pole;
    
    fs_bilinear = TWOPI*cf/tan(TWOPI*cf*tdres/2);
    rzero       = -pzero;
	CF          = TWOPI*cf;
    
    p = zeros(11,1);
    p(1) = -sigma0 + 1i*ipw;
    p(5) = p(1) -rpa - 1i*ipb;
    p(3) = (p(1) + p(5))/2;
    p(2) = conj(p(1));
    p(4) = conj(p(3));
    p(6) = conj(p(5));
    p(7) = p(1);
    p(8) = p(2);
    p(9) = p(5);
    p(10) = p(6);
    
    % Calculate initial phase
    C2initphase = 0.0;
    for i = 1:half_order_pole
        pimg = imag(p(2*i-1));
        preal = real(p(2*i-1));
        C2initphase = C2initphase + atan(CF/(-rzero))-atan((CF-pimg)/(-preal))-atan((CF+pimg)/(-preal));
    end
    
    % Normalize the gain
    C2gain_norm = 1.0;
    for i = 1:order_of_pole
        C2gain_norm = C2gain_norm*((CF-imag(p(i)))^2 + (real(p(i)))^2);
    end
    
    norm_gain = (sqrt(C2gain_norm))/((sqrt(CF^2+rzero^2))^order_of_zero);
    
    % Adjust locations of poles and zeros
    %p = zeros(11,1);
    p(1) = -sigma0*fcohc + 1i*ipw;
    p(5) = p(1) -rpa - 1i*ipb;
    p(3) = (real(p(1)) + real(p(5)))/2 + 1i*((imag(p(1)) + imag(p(5)))/2);
    p(2) = conj(p(1));
    p(4) = conj(p(3));
    p(6) = conj(p(5));
    p(7) = p(1);
    p(8) = p(2);
    p(9) = p(5);
    p(10) = p(6);
    
    % Calculate phase & zero locations
    phase = 0.0;
    for i = 1:half_order_pole      
           preal = real(p(2*i-1));
		   pimg  = imag(p(2*i-1));
	       phase = phase - atan((CF-pimg)/(-preal))-atan((CF+pimg)/(-preal));
    end
    
    rzero = -CF/tan((C2initphase-phase)/order_of_zero);	
    
    % Declar empty coefficient array
    C2coeffs = zeros(5,6);
    
    % Calculate biquad filter coefficients
    for i = 1:half_order_pole
        preal = real(p(2*i-1));
        pimg = imag(p(2*i-1));
        
        temp  = (fs_bilinear-preal)^2+ pimg^2;
        
        C2coeffs(i,1) = (fs_bilinear-rzero)/temp;
        C2coeffs(i,2) = -(2*rzero)/temp;
        C2coeffs(i,3) = (-(fs_bilinear+rzero))/temp;
        C2coeffs(i,4) = 1;
        C2coeffs(i,5) = (2*(fs_bilinear*fs_bilinear-preal*preal-pimg*pimg))/temp;
        C2coeffs(i,6) = (-((fs_bilinear+preal)*(fs_bilinear+preal)+pimg*pimg))/temp;
    end
    
end