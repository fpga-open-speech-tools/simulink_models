function vhdl = vgen_generate_VHDL_component(avalon)

%--------------------------------------------
% Get the length of the longest signal name
%--------------------------------------------
name_max_length = 0;
reg_name_max_length = 0;
if avalon.avalon_sink_flag == 1
    for i=1:length(avalon.avalon_sink.signal)
        name = avalon.avalon_sink.signal{i}.name;
        name_length = length(name);
        if name_max_length < name_length
            name_max_length = name_length;
        end
    end
end
if avalon.avalon_source_flag == 1
    for i=1:length(avalon.avalon_source.signal)
        name = avalon.avalon_source.signal{i}.name;
        name_length = length(name);
        if name_max_length < name_length
            name_max_length = name_length;
        end
    end
end
if avalon.avalon_memorymapped_flag == 1
    for i=1:length(avalon.avalon_memorymapped.register)
        name = avalon.avalon_memorymapped.register{i}.name;
        name_length = length(name);
        if name_max_length < name_length
            name_max_length = name_length;
        end
        if reg_name_max_length < name_length
            reg_name_max_length = name_length;
        end
    end
end
if avalon.conduit_input_flag == 1
    for i=1:length(avalon.conduit_input.signal)
        name = avalon.conduit_input.signal{i}.name;
        name_length = length(name);
        if name_max_length < name_length
            name_max_length = name_length;
        end
    end
end
if avalon.conduit_output_flag == 1
    for i=1:length(avalon.conduit_output.signal)
        name = avalon.conduit_output.signal{i}.name;
        name_length = length(name);
        if name_max_length < name_length
            name_max_length = name_length;
        end
    end
end
%name_max_length

%-----------------------------------------------------
% write the component declaration and instantiation
% vhdl1 = component declartion
% vhdl2 = component instantiation
% vhdl3 = register default values
%-----------------------------------------------------
system_clock_period = evalin('base','Ts_system');  % get value from the 'base' workspace variable
vhdl1 = ['COMPONENT ' avalon.entity '_src_' avalon.entity];
vhdl1 = char(vhdl1,[blanks(4) 'PORT( clk' blanks(name_max_length-2) ': IN  std_logic;  -- clk_frequency = ' num2str(1/system_clock_period) ' Hz (period=' num2str(system_clock_period) ')' ]);
vhdl1 = char(vhdl1,[blanks(10) 'clk_enable' blanks(name_max_length-9) ': IN  std_logic;']);
vhdl1 = char(vhdl1,[blanks(10) 'reset' blanks(name_max_length-4) ': IN  std_logic;']);
vhdl2 = ['u_' avalon.entity '_src_' avalon.entity ' : ' avalon.entity '_src_' avalon.entity];
vhdl2 = char(vhdl2,[blanks(4) 'PORT MAP( clk' blanks(name_max_length-2) ' => clk,  -- clk_frequency = ' num2str(1/system_clock_period) ' Hz (period=' num2str(system_clock_period) ')' ]);
vhdl2 = char(vhdl2,[blanks(14) 'clk_enable' blanks(name_max_length-9) ' => ''1'',']);
vhdl2 = char(vhdl2,[blanks(14) 'reset' blanks(name_max_length-4) ' => reset,']);
% inputs
if avalon.avalon_sink_flag == 1
    for i=1:length(avalon.avalon_sink.signal)
        name = avalon.avalon_sink.signal{i}.name;
        name_length = length(name);
        data_type = avalon.avalon_sink.signal{i}.data_type;
        dt = fixdt(data_type);
        Wdt = dt.WordLength;  % get width in bits
        if Wdt == 1
            vhdl1 = char(vhdl1,[blanks(10) name blanks(name_max_length-name_length+1) ': IN  std_logic;  --' data_type]);
        else
            vhdl1 = char(vhdl1,[blanks(10) name blanks(name_max_length-name_length+1) ': IN  std_logic_vector(' num2str(Wdt-1) ' DOWNTO 0);  --' data_type]);
        end
        vhdl2 = char(vhdl2,[blanks(14) name blanks(name_max_length-name_length+1) ' => ' name ',  --' data_type]);
    end
end
if avalon.avalon_memorymapped_flag == 1
    for i=1:length(avalon.avalon_memorymapped.register)
        name = avalon.avalon_memorymapped.register{i}.name;
        name_length = length(name);
        data_type = avalon.avalon_memorymapped.register{i}.data_type;
        dt = fixdt(data_type);
        Wdt = dt.WordLength;  % get width in bits
        if Wdt == 1
            vhdl1 = char(vhdl1,[blanks(10) name blanks(name_max_length-name_length+1) ': IN  std_logic;  --' data_type]);
        else
            vhdl1 = char(vhdl1,[blanks(10) name blanks(name_max_length-name_length+1) ': IN  std_logic_vector(' num2str(Wdt-1) ' DOWNTO 0);  --' data_type]);
        end
        % remove the string prefix Register_Control_
        name2 = name;
        ind = strfind(name2,'Register_Control_');  
        name2(ind(1):ind(1)+16)=[];
        vhdl2 = char(vhdl2,[blanks(14) name blanks(name_max_length-name_length+1) ' => ' name2 ',  --' data_type]);
        % get the register default values
        name2_length = length(name2);
        default_value = avalon.avalon_memorymapped.register{i}.default_value;
        dtv = fi(default_value,dt);
        if i == 1
            vhdl3 = [name2 blanks(reg_name_max_length-name2_length-17) ' <=  "' dtv.bin '";  --' data_type];
        else
            vhdl3 = char(vhdl3,[name2 blanks(reg_name_max_length-name2_length-17) ' <=  "' dtv.bin '";  --' data_type]);
        end
    end
end
if avalon.conduit_input_flag == 1
    for i=1:length(avalon.conduit_input.signal)
        name = avalon.conduit_input.signal{i}.name;
        name_length = length(name);
        data_type = avalon.conduit_input.signal{i}.data_type;
        dt = fixdt(data_type);
        Wdt = dt.WordLength;  % get width in bits
        if Wdt == 1
            vhdl1 = char(vhdl1,[blanks(10) name blanks(name_max_length-name_length+1) ': IN  std_logic;  --' data_type]);
        else
            vhdl1 = char(vhdl1,[blanks(10) name blanks(name_max_length-name_length+1) ': IN  std_logic_vector(' num2str(Wdt-1) ' DOWNTO 0);  --' data_type]);
        end
        name2 = name;
        ind = strfind(name2,'Export_');  % remove the string prefix
        name2(ind(1):ind(1)+6)=[];
        vhdl2 = char(vhdl2,[blanks(14) name blanks(name_max_length-name_length+1) ' => ' name2 ',  --' data_type]);
    end
end
% outputs
vhdl1 = char(vhdl1,[blanks(10) 'ce_out' blanks(name_max_length-5) ': OUT std_logic;']);
if avalon.avalon_source_flag == 1
    for i=1:length(avalon.avalon_source.signal)
        name = avalon.avalon_source.signal{i}.name;
        name_length = length(name);
        data_type = avalon.avalon_source.signal{i}.data_type;
        dt = fixdt(data_type);
        Wdt = dt.WordLength;  % get width in bits
        if Wdt == 1
            vhdl1 = char(vhdl1,[blanks(10) name blanks(name_max_length-name_length+1) ': OUT std_logic;  --' data_type]);
        else
            vhdl1 = char(vhdl1,[blanks(10) name blanks(name_max_length-name_length+1) ': OUT std_logic_vector(' num2str(Wdt-1) ' DOWNTO 0);  --' data_type]);
        end
        vhdl2 = char(vhdl2,[blanks(14) name blanks(name_max_length-name_length+1) ' => ' name ',  --' data_type]);
    end
end
if avalon.conduit_output_flag == 1  
    for i=1:length(avalon.conduit_output.signal)
        name = avalon.conduit_output.signal{i}.name;
        name_length = length(name);
        data_type = avalon.conduit_output.signal{i}.data_type;
        dt = fixdt(data_type);
        Wdt = dt.WordLength;  % get width in bits
        if Wdt == 1
            vhdl1 = char(vhdl1,[blanks(10) name blanks(name_max_length-name_length+1) ': OUT std_logic;  --' data_type]);
        else
            vhdl1 = char(vhdl1,[blanks(10) name blanks(name_max_length-name_length+1) ': OUT std_logic_vector(' num2str(Wdt-1) ' DOWNTO 0);  --' data_type]);
        end
        name2 = name;
        ind = strfind(name2,'Export_');  % remove the string prefix
        name2(ind(1):ind(1)+6)=[];
        vhdl2 = char(vhdl2,[blanks(14) name blanks(name_max_length-name_length+1) ' => ' name2 ',  --' data_type]);
    end
end
%--------------------------------------------------
% Get rid of the ending semicolon on the last line
%--------------------------------------------------
[Nr,Nc]=size(vhdl1);
last_line = vhdl1(Nr,:);
ind = strfind(last_line,';');
last_line(ind(1)) = [];
vhdl1(Nr,:) = [];
vhdl1 = char(vhdl1,last_line);
% finish component declaration
vhdl1 = char(vhdl1,[blanks(4) ');']);
vhdl1 = char(vhdl1,'END COMPONENT;');
%--------------------------------------------------
% Get rid of the ending comma on the last line
%--------------------------------------------------
[Nr,Nc]=size(vhdl2);
last_line = vhdl2(Nr,:);
ind = strfind(last_line,',');
last_line(ind(1)) = [];
vhdl2(Nr,:) = [];
vhdl2 = char(vhdl2,last_line);
vhdl2 = char(vhdl2,[blanks(4) ');']);


vhdl.component_declaration   = vhdl1;
vhdl.component_instantiation = vhdl2;
vhdl.register_defaults       = vhdl3;
vhdl.system_clock_frequency  = num2str(1/system_clock_period);
%vhdl1
%vhdl2
%vhdl3




























