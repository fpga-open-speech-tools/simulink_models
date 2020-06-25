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
% Verify_Synapse
% 07/24/2019

%% NOTES:

% The following script is designed provide output plots
% to verify Simulink model functionality. Due to the random nature of the
% Spike Generator, there is not true verification file to refer to. Thus,
% the results are not fully verified, only tested.

%% OUTPUT PLOTS

figure()
plot(out.synout(1:end-1))
title('Power Law Adaptation Approximation Output - Simulink Model')
xlabel('Sample Number');

figure()
subplot(3,1,1)
stem(out.sptime);
title('Spike Train Output (sptime) - Simulink Model');
ylabel('Spike Indicator');
xlabel('Sample Number');
subplot(3,1,3)
plot(out.trd_vector);
title('Mean Synaptic Redocking Time');
ylabel('Redocking Time [sec]');
xlabel('Sample Number');
subplot(3,1,2)
plot(out.meanrate);
title('Mean of Spike Rate');
ylabel('Mean Rate [/s]');
xlabel('Sample Number');

% end of script
