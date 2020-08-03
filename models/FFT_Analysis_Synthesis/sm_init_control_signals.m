function mp = sm_init_control_signals(mp)
% Note:  The register fields that need to be defined are listed in file: \simulink_models\config\register_control_fields.json
%        The data type of the register is taken by the data type passed out of the register control port.
%        The Widget types that can be chosen are listed in file: \simulink_models\config\widget_list.json

%% Create left passthrough control signal
mp.register(1).name                 = 'Left_Passthrough';  % control signal name (string)
mp.register(1).value                = 0;           % value control signal will take during simulation
mp.register(1).min                  = 0;          % The minimum value the control signal will ever take
mp.register(1).max                  = 1.0;          % The maximum value the control signal will ever take
mp.register(1).default              = 0;            % default value (initial value at powerup)
mp.register(1).widget_type          = 'toggle';  % Note: Widget types are listed in file: \simulink_models\config\widget_list.json
mp.register(1).widget_display_units = 'On/Off';

%% Create left filter select control signal
mp.register(2).name             = 'Left_Filter_Select';  % control signal name
mp.register(2).widget_type      = 'drop_down_menu';
mp.register(2).choices.display  = char('Low Pass Filter', 'Band Pass Filter', 'High Pass Filter', 'All Pass Filter');          % value control signal will take during simulation
mp.register(2).choices.values   = [0 1 2 3];
mp.register(2).choices.default  = 2;          % index (starting with 1) into mp.register(2).choices.values array
mp.register(2).value            = 2;           % value control signal will take during simulation

%% Create right passthrough control signal
mp.register(3) = mp.register(1);   % same as left except for name
mp.register(3).name                 = 'Right_Passthrough';  % control signal name (string)

%% Create right filter select control signal
mp.register(4) = mp.register(2);   % same as left except for name
mp.register(4).name                 = 'Right_Filter_Select';  % control signal name (string)


%% Any other register control signals should be created in a similar manner

%% convert to time series data
for i=1:length(mp.register)
    mp.register(i).timeseries = timeseries(mp.register(i).value,0);  % timeseries(datavals,timevals);  % A timeseries data format is needed for the from workspace block     
end

%%