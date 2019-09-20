

wl = readjson('widget_list.json');

names = fieldnames(wl);
for i=1:length(wl)
    disp(['------------------------'])
    disp(['Widget ' num2str(i)])
    for j=1:length(names)
        disp(['   ' names{j} ' = ' wl(i).(names{j})])
    end
end





