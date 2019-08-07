% SpikeGenerator() - A MATLAB function created to replicate the spike
% generator function implemented in the C source code
%
% [sptime, spCount, trd_vector] = SpikeGenerator(synout, randNums, tdres, t_rd_rest, t_rd_init, tau, t_rd_jump, nSites, tabs, trel, spont, elapsed_time, unitRateInterval, oneSiteRedock, Tref)
%
% The function takes in the synapse output signal, a randum number
% generator signal, and a variety of timing parameters and outputs the
% spike times, total spike count, and redocking time vector.
%
% Inputs:
%   synout = synapse output signal
%   randNums = randomly generator number vector
%   tdres = 1/Fs
%   t_rd_rest = resting (minimum) redocking period
%   t_rd_init = initial redocking period
%   tau = time constant related to decay of redocking period
%   t_rd_jump = increase in redocking period after redocking event occurs
%   nSites = number of synaptic redocking sites
%   tabs = absolute refractory period
%   trel = relative refractory period
%   spont = spontaneous firing rate of neuron
%   elapsed_time = initial value for time counter, set as input for testing
%   unitRateInterval = inital value for spike threshold, set as input for
%                      testing
%   oneSiteRedock = initial value of redocking time, set as input for
%                   testing
%   Tref = initial value of refractory period, set as input for testing
%
%
% Outputs:
%   sptime = vector of spike times, where 1 indicates a spike during that
%            sample period
%   spCount = total number of spikes
%   trd_vector = vector containing redocking period values at each sampling
%                period

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
% SpikeGenerator MATLAB Function
% 07/23/2019

% ---------------------------------------------------------------------- %

% Function copied from AN model C source code, with a few minor adjustments
% in order for the function to operate in a sample based manner in MATLAB

function [sptime, spCount, trd_vector] = SpikeGenerator(synout, randNums, tdres, t_rd_rest, t_rd_init, tau, t_rd_jump, nSites, tabs, trel, spont, elapsed_time, unitRateInterval, oneSiteRedock, Tref)

    % Initializing parameters
    Xsum = 0;
    spCount = 0;
    previous_redocking_period = t_rd_init;
    current_redocking_period = previous_redocking_period;
    t_rd_decay = 1;
    previous_release_times = 0;
    current_refractory_period = 0;

    for k = 1:length(synout)
        
        oneSiteRedock_rounded = floor(oneSiteRedock/tdres);
        elapsed_time_rounded = floor(elapsed_time/tdres);
        if oneSiteRedock_rounded == elapsed_time_rounded
            current_redocking_period = previous_redocking_period + t_rd_jump;
            previous_redocking_period = current_redocking_period;
            t_rd_decay = 0;
        end
        
        elapsed_time = elapsed_time + tdres;
        
        if oneSiteRedock >= elapsed_time
            Xsum = Xsum + synout(k)/nSites;
        end
        
        sptime(k) = 0;
        
        if Xsum >= unitRateInterval
            oneSiteRedock = -current_redocking_period*log(randNums(k));
            current_release_times = previous_release_times + elapsed_time;
            elapsed_time = 0;
            
            %if current_release_times >= current_refractory_period
                %sptime(spCount + 1) = current_release_times;
                sptime(k) = 1;
                spCount = spCount + 1;
                trel_k = min(trel*100/synout(k), trel);
                Tref = tabs - trel_k*log(randNums(k));
                current_refractory_period = current_release_times + Tref;
            %end
            
            previous_release_times = current_release_times;
            Xsum = 0;
            unitRateInterval = -log(randNums(k))/tdres;
            
        end
     
        if t_rd_decay == 1
            current_redocking_period = previous_redocking_period - (tdres/tau)*(previous_redocking_period - t_rd_rest);
            previous_redocking_period = current_redocking_period;
        else
            t_rd_decay = 1;
        end
        
        trd_vector(k) = current_redocking_period;
        
        k = k+1;
        
    end
    
end
