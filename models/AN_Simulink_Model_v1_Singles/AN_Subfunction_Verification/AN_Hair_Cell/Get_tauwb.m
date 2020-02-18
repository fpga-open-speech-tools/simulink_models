% Get_tauwb() - A MATLAB function created to recreate the Get_tauwb
% function implemented in the AN model C source code
%
% [taumax, taumin] = Get_tauwb(cf, species)
%
% The function takes in the neuron characteristic frequency, and species 
% and returns a maximum time constant value and a time constant 
% minimum value

% Inputs:
%   cf = neuron characteristic frequency
%   species = species number, specified as 1 for cat, 2 or 3 for human
%
% Outputs:
%   taumax = time constant maximum value
%   taumin = time constant minimum value

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
% Get_tauwb MATLAB Function
% 06/27/2019

% ---------------------------------------------------------------------- %

% Function copied from AN model C source code, with a few minor adjustments
% in order for the function to operate in MATLAB

function [taumax taumin] = Get_tauwb(cf, species)
    
    order = 3; % constant in source code

    % Calculate gain for cat (species = 1)
    if species==1 
        gain = 52.0/2.0*(tanh(2.2*log10(cf/0.6e3)+0.15)+1.0); 
    end
    % Calculate gain for human (species = 2 or 3)
    if species>1
        gain = 52.0/2.0*(tanh(2.2*log10(cf/0.6e3)+0.15)+1.0);
    end
     
    % Set min and max gains
    if gain>60.0
        gain = 60.0;  
    end
    if gain<15.0
        gain = 15.0;
    end
    
    % ratio of TauMin/TauMax according to the gain, order
    ratio = 10^(-gain/(20.0*order));
    
    if species==1 % cat Q10 values 
        Q10 = 10^(0.4708*log10(cf/1e3)+0.4664);
    end
    
    if species==2 % human Q10 values from Shera et al. (PNAS 2002) %
        Q10 = ((cf/1000)^0.3)*12.7*0.505+0.2085;
    end
    
    if species==3 % human Q10 values from Glasberg & Moore (Hear. Res. 1990) %
        Q10 = cf/24.7/(4.37*(cf/1000)+1)*0.505+0.2085;
    end
    
    bw = cf/Q10;
    taumax = 2.0/(2*pi*bw);
    taumin = taumax*ratio;
    
end
