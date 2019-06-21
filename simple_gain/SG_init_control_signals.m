% model_params = SG_init_control_signals(model_params)
%
% Matlab function that creates and initializes the control signals. 
% The min/max values the control signals are expected to take need to be 
% defined.
%
% Inputs:
%   model_params, which is the model data structure that holds the model parameters
%
% Outputs:
%   model_params, the model data structure that now contains the registers in the 
%   field model_params.register(i), indexed by i, which has the following fields:
%         model_params.register(i).name       -  The register name
%         model_params.register(i).value      -  The value the control register is currently set to
%         model_params.register(i).min        -  The minimum value the control signal will ever take
%         model_params.register(i).max        -  The maximum value the control signal will ever take
%         model_params.register(i).timeseries - The timeseries data format that is needed for the from workspace block
%
% Copyright 2019 Flat Earth Inc
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Ross K. Snider
% Flat Earth Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com



function model_params = SG_init_control_signals(model_params)

%% Create left gain control signal
model_params.register(1).name       = 'Left_Gain';  % control signal name
model_params.register(1).value      = 1.0;          % value control signal will take during simulation
model_params.register(1).min        =   0;          % The minimum value the control signal will ever take
model_params.register(1).max        = 1.0;          % The maximum value the control signal will ever take
model_params.register(1).timeseries = timeseries(model_params.register(1).value,0);  % timeseries(datavals,timevals);  % A timeseries data format is needed for the from workspace block     

%% Create right gain control signal
model_params.register(2).name       = 'Right_Gain';  % control signal name
model_params.register(2).value      = 1.0;          % value control signal will take during simulation
model_params.register(2).min        =   0;          % The minimum value the control signal will ever take
model_params.register(2).max        = 1.0;          % The maximum value the control signal will ever take
model_params.register(2).timeseries = timeseries(model_params.register(2).value,0);  % timeseries(datavals,timevals);  % A timeseries data format is needed for the from workspace block     

% Any other register control signals should be created in a similar manner


