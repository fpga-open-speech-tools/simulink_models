hdl_data_input = testSignal.audio(:,1);
data_input     = testSignal.audio(:,1) .* 1e5;
syn_out        = PowerLaw(data_input, length(data_input), randNums, Fs);

pla_inhdl = hdlcosim_dataplane;

% Data Plane Inputs
clk_enable              = fi(1,0,1,0);
avalon_sink_valid       = fi(1,0,1,0);
avalon_sink_channel     = fi(1,0,1,0);
avalon_sink_error       = fi(1,0,2,0);
register_control_enable = fi(1,0,1,0);

clock_cycles = length(data_input) * 1024;
j = 1;
for i = 1:clock_cycles
    if(mod(i,1024) == 1)
        avalon_sink_data = fi(hdl_data_input(j),1,32,28);
        hdl_data_in(j) = avalon_sink_data;
        random_num     = randNums(j);
        j = j + 1;
    end
    [ce_out, avalon_source_valid, avalon_source_data, avalon_source_channel, avalon_source_error] = step(pla_inhdl, clk_enable, avalon_sink_valid, avalon_sink_data, avalon_sink_channel, avalon_sink_error, register_control_enable, random_num);
    if(mod(i,1024) == 1)
        hdl_data_out(j) = avalon_source_data;
    end
end

figure
subplot(2,1,1)
plot(data_input)
hold on
plot(hdl_data_in .* 1e5,'--')
title('Audio Input')
legend('Input', 'HDL Data In .* 1e5')

subplot(2,1,2)
plot(pla_nl_out)
hold on
plot(hdl_data_out,'--')
legend('C Source Code', 'HDL')
title('HDL Output vs Simulation')