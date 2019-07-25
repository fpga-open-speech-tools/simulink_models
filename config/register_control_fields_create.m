

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
field(6).name        = 'widget_type';
field(6).description = 'display widget for register';
% The widget units that will be shown
field(7).name        = 'widget_display_units';
field(7).description = 'the units the diplay widget will use';

% write and create the new json file
writejson(field,'register_control_fields.json')

