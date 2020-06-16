function mp = sm_init_control_signals(mp)
% mp = sm_init_control_signals(mp)
%
% Matlab function that creates and initializes the control signals. 
% The min/max values the control signals are expected to take need to be 
% defined.
%
% Inputs:
%   mp, which is the model data structure that holds the model parameters
%
% Outputs:
%   mp, the model data structure that now contains the registers in the 
%   field mp.register(i), indexed by i, which has the following fields:
%         mp.register(i).name       -  The register name
%         mp.register(i).value      -  The value the control register is currently set to
%         mp.register(i).min        -  The minimum value the control signal will ever take
%         mp.register(i).max        -  The maximum value the control signal will ever take
%         mp.register(i).timeseries - The timeseries data format that is needed for the from workspace block
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
%
% Note: to display the widget types available, run the function
% \simulink_models\config\widget_list_display.m
%


%% Create bypass control signal
ri = 1;   % register index
mp.register(ri).name       = 'Enable';  % control signal name
mp.register(ri).value      = 1;         % value control signal will take during simulation
mp.register(ri).min        = 0;         % The minimum value the control signal will ever take
mp.register(ri).max        = 1;         % The maximum value the control signal will ever take
mp.register(ri).default    = 1;         % default (initial) value
mp.register(ri).dataType = fixdt('boolean');
mp.register(ri).widgetType          = 'toggle';
mp.register(ri).widgetDisplayUnits = '';
mp.register(ri).widgetStyle = 'enable';
mp.register(ri).uiPageName = 'main';
mp.register(ri).uiPanelName = 'bitcrusher';

%% Create bit control signal
ri = ri + 1;  % register index
mp.register(ri).name       = 'Bits';   % control signal name
mp.register(ri).value      = 8;        % value control signal will take during simulation
mp.register(ri).min        =  0;       % The minimum value the control signal will ever take
mp.register(ri).max        = 32;       % The maximum value the control signal will ever take
mp.register(ri).default    = 32;       % default (initial) value
mp.register(ri).dataType = fixdt(0, log2(mp.W_bits) + 1, 0);
mp.register(ri).widgetType          = 'slider';
mp.register(ri).widgetDisplayUnits = 'bits';
mp.register(ri).widgetStyle = 'default';
mp.register(ri).uiPageName = 'main';
mp.register(ri).uiPanelName = 'bitcrusher';

%% Create wet_dry_mix signal
ri = ri + 1;  % register index
mp.register(ri).name       = 'Wet_Dry_Mix';   % control signal name   Note:  wet_gain=wet_dry_mix; dry_gain=1-wet_dry_mix
mp.register(ri).value      = 1;             % value control signal will take during simulation
mp.register(ri).min        = 0;               % The minimum value the control signal will ever take
mp.register(ri).max        = 1;               % The maximum value the control signal will ever take
mp.register(ri).default    = 0.5;             % default (initial) value
mp.register(ri).dataType = fixdt(0, 8, 7);
mp.register(ri).widgetType          = 'slider';
mp.register(ri).widgetDisplayUnits = '';
mp.register(ri).widgetStyle = 'default';
mp.register(ri).uiPageName = 'main';
mp.register(ri).uiPanelName = 'bitcrusher';

% Any other register control signals should be created in a similar manner


%% convert to time series data
for i=1:length(mp.register)
    mp.register(i).timeseries = timeseries(mp.register(i).value,0);  % timeseries(datavals,timevals);  % A timeseries data format is needed for the from workspace block     
end

%% Check if the control signals have valid entries
sm_check_control_signals(mp)

