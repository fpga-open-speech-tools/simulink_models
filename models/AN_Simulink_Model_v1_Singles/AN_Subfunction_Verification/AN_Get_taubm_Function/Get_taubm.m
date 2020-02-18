% Get_taubm() - A MATLAB function created to recreate the Get_taubm
% function implemented in the AN model C source code
%
% [bmTaumax, bmTaumin, ratio] = Get_taubm(cf, species, taumax)
%
% The function takes in the neuron characteristic frequency, species 
% number, and maximum time constant value and returns a new maximum time 
% constant value, a time constant minimum value, and a ratio parameter.

% Inputs:
%   cf = neuron characteristic frequency
%   species = species number, specified as 1 for cat, 2 or 3 for human
%   taumax = maximum time constant value
%
% Outputs:
%   bmTaumax = new time constant maximum value
%   bmTaumin = time constant minimum value
%   ratio = ratio of upper to lower time constant bounds

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
% Get_taubm MATLAB Function
% 06/27/2019

% ---------------------------------------------------------------------- %

% Function copied from AN model C source code, with a few minor adjustments
% in order for the function to operate in MATLAB

function [bmTaumax, bmTaumin, ratio] = Get_taubm(cf, species, taumax)

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
    
    bwfactor = 0.7; % constants in source code
    factor   = 2.5;
    
    % ratio of TauMin/TauMax according to the gain, factor
    ratio = 10^(-gain/(20.0*factor));
    
    % bmTaumax and bmTaumin calculations
    bmTaumax = taumax/bwfactor;
    bmTaumin = bmTaumax*ratio;    
    
end
