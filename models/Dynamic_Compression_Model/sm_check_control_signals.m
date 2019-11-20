function sm_check_control_signals(mp)



%% Check if all the register fields have been included by the user
if mp.sim_prompts == 1
    disp(' ')
    disp('Checking if the control register fields have been setup correctly in sm_init_control_signals.m')
end

registers = mp.register;
Nsr = length(registers);

rf = readjson(['register_control_fields.json']);
Nrf = length(rf);

%% check for field names
for i=1:Nsr
    supplied_fields = fieldnames(registers(i));
    Nsf = length(supplied_fields);
    found_flags = zeros(1,Nrf);
    for j=1:Nrf
        for k=1:Nsf
            if strcmp(rf(j).name,supplied_fields(k)) 
                found_flags(j) = 1;
                break;
            end
        end
    end
    for j=1:Nrf
        if found_flags(j) == 0
            disp(['Register control is missing field ' rf(j).name ' for register ' registers(i).name])
        end
    end
end

%% check for empty fields
error_flag = zeros(1,Nsr);
for i=1:Nsr
    supplied_fields = fieldnames(registers(i));
    Nsf = length(supplied_fields);
    for j=1:Nsf
        a = registers(i).(supplied_fields{j});
        if isempty(a)
            if error_flag(i) == 0
                disp(['The following fields are missing for control register ' num2str(i) ': ' mp.register(i).name])
            end
            error_flag(i) = 1;
            disp(['    ' supplied_fields{j}])
        end
    end
end
if error_flag == 1
    error('Register fields are missing.  Please add them in sm_init_control_signals.m')
end


%% Check if the widget name is correct
wl = readjson([mp.config_path '/widget_list.json']);
Nw = length(wl);

error_flag = 0;
for i=1:Nsr
    found_flag = 0;
    for j=1:Nw
        if strcmp(registers(i).widget_type, wl(j).name) == 1
            found_flag = 1;
            break
        end           
    end
    if found_flag == 0
        error_flag = 1;
        disp(['There is no widget called  ***' registers(i).widget_type '*** associated with register ' num2str(i) ': '  mp.register(i).name])
        disp(['Please specify a known widget.  Avaliable widget names are:'])
        for j=1:Nw
            disp(['     '  wl(j).name])
        end
    end
end
if error_flag == 1
    error('Widget names are wrong.  Please correct in sm_init_control_signals.m')
end

    




