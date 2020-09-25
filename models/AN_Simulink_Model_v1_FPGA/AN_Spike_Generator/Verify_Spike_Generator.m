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
% Verify_Spike_Generator
% 07/31/2019

%% NOTES:

% The following script is designed provide output plots
% to verify Simulink model functionality. Due to the random nature of the
% Spike Generator, there is not true verification file to refer to. Thus,
% the results are not fully verified, only tested.


%% OUTPUT COMPARISON PLOTS
% *** Changed to include Double and Single Comparison Plots
% *** By Matthew Blunt 03/03/2020

figure()
subplot(2,1,1)
stem(out.sptimedouble);
title('Spike Train Output (sptime) - Simulink Double Precision');
ylabel('Spike Indicator');
xlabel('Sample Number');
subplot(2,1,2)
stem(out.sptime);
title('Spike Train Output (sptime) - Simulink Single Precision');
ylabel('Spike Indicator');
xlabel('Sample Number');

figure()
subplot(2,1,1)
plot(out.trd_vectordouble);
title('Mean Synaptic Redocking Time - Simulink Double Precision');
ylabel('Redocking Time [sec]');
xlabel('Sample Number');
subplot(2,1,2)
plot(out.trd_vector);
title('Mean Synaptic Redocking Time - Simulink Single Precision');
ylabel('Redocking Time [sec]');
xlabel('Sample Number');

figure()
subplot(2,1,1)
plot(out.meanratedouble);
title('Mean of Spike Rate - Simulink Double Precision');
ylabel('Mean Rate [/s]');
xlabel('Sample Number');
subplot(2,1,2)
plot(out.meanrate);
title('Mean of Spike Rate - Simulink Single Precision');
ylabel('Mean Rate [/s]');
xlabel('Sample Number');


%% ERROR CALCULATION
% *** Added to include Double vs. Single Error Calculations
% *** By Matthew Blunt 03/03/2020

% Compares output vectors of Simulink Double and Single Precision Spike
% Time Outputs
% *** Added by Matthew Blunt 03/03/2020
sptimeconversionerror = norm(out.sptimedouble(1:end)-out.sptime(1:end));

% Display in Simulink Diagnostics menu
% *** Added by Matthew Blunt 03/03/2020
disp('Spike Time Conversion Error =');
disp(sptimeconversionerror);

% Compares output vectors of Simulink Double and Single Precision Redocking
% Time Outputs
% *** Added by Matthew Blunt 03/03/2020
trdconversionerror = norm(out.trd_vectordouble(1:end)-out.trd_vector(1:end));

% Display in Simulink Diagnostics menu
% *** Added by Matthew Blunt 03/03/2020
disp('Redocking Time Conversion Error =');
disp(trdconversionerror);

% Compares output vectors of Simulink Double and Single Precision Mean
% Synaptic Rate Outputs
% *** Added by Matthew Blunt 03/03/2020
meanrateconversionerror = norm(out.meanratedouble(1:end)-out.meanrate(1:end));

% Display in Simulink Diagnostics menu
% *** Added by Matthew Blunt 03/03/2020
disp('Mean Spike Rate Conversion Error =');
disp(meanrateconversionerror);

% end of script
