data_input  = testSignal.audio(:,1);

totalstim = length(data_input);

[sptime_sim, spCount_sim, trd_vector_sim] = SpikeGenerator(data_input(i), randNums, tdres, t_rd_rest, t_rd_init, tau, t_rd_jump, nSites, tabs, trel, elapsed_time, unitRateInterval, oneSiteRedock);

spike_generator_inhdl = hdlcosim_dataplane;

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
        avalon_sink_data = fi(data_input(j),1,32,28);
        hdl_data_in(j) = avalon_sink_data;
        j = j + 1;
    end
    [ce_out, avalon_source_valid, avalon_source_data, avalon_source_channel, avalon_source_error] = step(spike_generator_inhdl, clk_enable, avalon_sink_valid, avalon_sink_data, avalon_sink_channel, avalon_sink_error, register_control_enable);
    if(mod(i,1024) == 1)
        spike_out(j) = avalon_source_data;
    end
end

figure
subplot(2,2,1)
plot(data_input)
hold on
plot(hdl_data_in,'--')
title('Audio Input')
legend('Input', 'HDL Data In')

subplot(2,2,2)
plot(sptime_sim)
hold on
plot(spike_out,'--')
legend('C Source Code', 'HDL')
title('HDL Output vs Simulation')

subplot(2,2,3)
plot(spCount_sim)
hold on
plot(spike_out,'--')
legend('C Source Code', 'HDL')
title('HDL Output vs Simulation')


subplot(2,2,4)
plot(trd_vector_sim)
hold on
plot(spike_out,'--')
legend('C Source Code', 'HDL')
title('HDL Output vs Simulation')

