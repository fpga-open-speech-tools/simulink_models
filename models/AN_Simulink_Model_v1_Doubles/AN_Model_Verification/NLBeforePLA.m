%    NLBeforePLA() - A function created to isolate the Nonlinear
%    Calculation that occures before the PLA in the AN Model C source code 
%    model_IHC_BEZ2018 in order to verify Simulink functionality
% 
%    powerLawIn = NLBeforePLA(ihcout, totalstim, spont, cf)
% 
%    The function takes in the IHC Output signal,
%    which will just be declared for testing purposes, along witht the length 
%    of the signal in number of samples, spontaneous firing rate of 
%    the neuron, and characteristic frequency. Then, the output is the 
%    signal to be fed into the PLA function.
% 
%    Inputs:
%    ihcout = IHC output signal
%    totalstim = length of IHC output signal in number of samples
%    spont = spontaneous firing rate of the neuron
%    cf = characteristic frequency of the neuron
%
%    Outputs:
%    powerLawIn = output signal affected by nonlinear manipulation, to be fed
%    into the PLA function
% 
%  ------------------------------------------------------------------------
% 
%    Copyright 2019 Audio Logic
% 
%    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
%    INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
%    PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
%    FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
%    ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
% 
%    Matthew Blunt
%    Flat Earth Inc
%    985 Technology Blvd
%    Bozeman, MT 59718
%    support@flatearthinc.com
% 
%    Auditory Nerve Simulink Model Code
%    NLBeforePLA.m Function
%    07/09/2019 

% ---------------------------------------------------------------------- %

%    Function created to model the nonlinear calculation found in the C
%    source code model_Synapse_BEZ2018, under the commented heading 
%    "Mapping Function from IHCOUT to input to the PLA"

function powerLawIn = NLBeforePLA(ihcout, totalstim, spont, cf)

% ---------------------------------------%
% NOTE: delaypoint may need to be changed due
%       to sampling rate change from 100 kHz 
%       to 48 kHz
% ---------------------------------------%

    delaypoint = floor(7500/(cf/1e3));

    cfslope = (spont^0.19)*(10^-0.87);
    cfconst = 0.1*(log10(spont))^2 + 0.56*log10(spont) - 0.84;
    cfsat = 10^(cfslope*8965.5/1e3 + cfconst);
    cf_factor = min(cfsat, 10^(cfslope*cf/1e3 + cfconst)) * 2.0;

    multFac = max(2.95*max(1.0,1.5-spont/100), 4.3-0.2*cf/1e3);

    k = 1;
    for indx=1:totalstim
        mappingOut(k) = 10^((0.9*log10(abs(ihcout(indx))*cf_factor))+ multFac);
        if ihcout(indx)<0 
            mappingOut(k) = - mappingOut(k);
        end  
        k=k+1;    
    end
    
    
    % Version 1 - most likely needs editing when functionality is further
    % understood!
    powerLawIn = mappingOut + 3.0*spont;
    
    
% NOTE: Below is the original source code implementation:

%     for k=1:delaypoint
%         powerLawIn(k) = mappingOut(1)+3.0*spont;
%     end
    
%     for k=delaypoint+1:totalstim+delaypoint
%         powerLawIn(k) = mappingOut(k-delaypoint)+3.0*spont;
%     end
    
%     for k=totalstim+1+delaypoint:totalstim+3*delaypoint
%         powerLawIn(k) = powerLawIn(k-1)+3.0*spont;
%     end
        
end

% end of function