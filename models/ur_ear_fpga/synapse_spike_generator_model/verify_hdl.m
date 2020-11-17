data_input = testSignal.audio(:,1);
totalstim  = length(data_input);
pla_nl_out = NLBeforePLA(data_input, totalstim, spont, cf);
syn_out    = PowerLaw(pla_nl_out, totalstim, randNums, Fs);

synapse_inhdl = hdlcosim_dataplane;

% Data Plane Inputs
clk_enable              = fi(1,0,1,0);
avalon_sink_valid       = fi(1,0,1,0);
avalon_sink_channel     = fi(1,0,1,0);
avalon_sink_error       = fi(1,0,2,0);
register_control_enable = fi(1,0,1,0);

clock_cycles = totalstim * 1024;
j = 1;
for i = 1:clock_cycles
    if(mod(i,1024) == 1)
        avalon_sink_data = fi(data_input(j),1,32,28);
        hdl_data_in(j)   = avalon_sink_data;
        random_num       = randNums(j);
        j = j + 1;
    end
    [ce_out, avalon_source_valid, avalon_source_data, avalon_source_channel, avalon_source_error] = step(synapse_inhdl, clk_enable, avalon_sink_valid, avalon_sink_data, avalon_sink_channel, avalon_sink_error, register_control_enable, random_num);
    if(mod(i,1024) == 1)
        synapse_out(j) = avalon_source_data;
    end
end

figure
subplot(2,1,1)
plot(data_input)
hold on
plot(hdl_data_in,'--')
title('Audio Input - Inner Hair Cell Result')
legend('Input', 'HDL Data In')

subplot(2,1,2)
plot(syn_out)
hold on
plot(synapse_out,'--')
legend('C Source Code', 'HDL')
title('Synapse Model: HDL Output vs Simulation')