% gain_groupdelay() - A MATLAB function created to recreate the
% gain_groupdelay function implemented in the AN model C source code
%
% [wb_gain, grdelay] = gain_groupdelay(tdres, centerfreq, cf, tau)
%
% The function takes in the binsize, neuron shifted centerfrequency,
% neuron characteristic frequency, and time constant and returns the
% wideband gain and group delay of the control path

% Inputs:
%   tdres = binsize, or sampling period
%   centerfreq = neuron shifted center frequency according to basilar membrane location
%   cf = neuron characteristic frequency
%   tau = time constant parameter
%
% Outputs:
%   wb_gain = wideband filter control path gain
%   grdelay = control path group delay

% ---------------------------------------------------------------------- %

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
% openspeech@flatearthinc.com

% Auditory Nerve Simulink Model Code
% gain_groupdelay MATLAB Function
% 06/27/2019

% ---------------------------------------------------------------------- %

% Function copied from AN model C source code, with a few minor adjustments
% in order for the function to operate in MATLAB

function [wb_gain, grdelay] = gain_groupdelay(tdres, centerfreq, cf, tau)

  tmpcos = cos(2*pi*(centerfreq-cf)*tdres);
  dtmp2 = tau*2.0/tdres;
  c1LP = (dtmp2-1)/(dtmp2+1);
  c2LP = 1.0/(dtmp2+1);
  tmp1 = 1+c1LP*c1LP-2*c1LP*tmpcos;
  tmp2 = 2*c2LP*c2LP*(1+tmpcos);
  
  wb_gain = (tmp1/tmp2)^0.5;
  
  grdelay = floor((0.5-(c1LP^2-c1LP*tmpcos)/(1+c1LP^2-2*c1LP*tmpcos)));

end
