

% Widget List
% Add new widgets and then run to create a new json file


windex = 1;
%--------------
% INPUTS
%--------------
wl(windex).name        = 'dial';
wl(windex).io_type     = 'input';
wl(windex).description = 'radial slider on a numeric range';
windex = windex + 1;
%--------------
wl(windex).name        = 'slider';
wl(windex).io_type     = 'input';
wl(windex).description = 'vertical slider  on a numeric range';
windex = windex + 1;
%--------------
wl(windex).name        = 'toggle';
wl(windex).io_type     = 'input';
wl(windex).description = 'a switch, binary on/off';
windex = windex + 1;
%--------------
wl(windex).name        = 'button';
wl(windex).io_type     = 'input';
wl(windex).description = 'button that sends a single value';
windex = windex + 1;
%--------------
wl(windex).name        = 'panel';
wl(windex).io_type     = 'input';
wl(windex).description = 'container that holds an arbitrary number of elements in a layoutStyle (Horizontal, Vertical, Grid).';
windex = windex + 1;


%--------------
% OUTPUTS
%--------------
wl(windex).name        = 'monitor';
wl(windex).io_type     = 'output';
wl(windex).description = 'for 2d graphing.  Plots x,y ...';
windex = windex + 1;
%--------------
wl(windex).name        = 'level';
wl(windex).io_type     = 'output';
wl(windex).description = 'for 1d graphing.  Plots a single value (ie, output level monitoring)';
windex = windex + 1;
%--------------
wl(windex).name        = 'state';
wl(windex).io_type     = 'output';
wl(windex).description = 'displays a binary state (on, off), e.g. LED';
windex = windex + 1;
%--------------
wl(windex).name        = 'text';
wl(windex).io_type     = 'output';
wl(windex).description = 'displays text output.';
windex = windex + 1;

writejson(wl,'widget_list.json')


disp('The following widget list was created')
widget_list_display



