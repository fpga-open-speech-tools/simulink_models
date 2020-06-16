

% Register Fields List
% These fields must exist when control registers are specified.

% Name of control register
field(1).name        = 'name';
field(1).description = 'control signal name';
% Current value of register
field(2).name        = 'value';
field(2).description = 'value control signal will take during simulation';
% minimum value the register will ever see
field(3).name        = 'min';
field(3).description = 'The minimum value the control signal will ever take';
% maximum value the register will ever see
field(4).name        = 'max';
field(4).description = 'The maximum value the control signal will ever take';
% The default (initial) value of the register at powerup
field(5).name        = 'default';
field(5).description = 'default (initial or powerup) value';
% The widget that will be used to control the register
field(6).name        = 'widgetType';
field(6).description = 'display widget for register';
% The widget units that will be shown
field(7).name        = 'widgetDisplayUnits';
field(7).description = 'the units the diplay widget will use';
% data type
field(8).name           = 'dataType';
field(8).description    = 'register data type';
% Widget display style
field(9).name           = 'widgetStyle';
field(9).description    = 'widget display style';
% UI page name
field(10).name          = 'uiPageName';
field(10).description   = 'name of page where this register will show up in the app';
% UI panel name
field(11).name          = 'uiPanelName';
field(11).description   = 'name of panel where this register will show up in the app';

% write and create the new json file
writejson(field,'register_control_fields.json')

