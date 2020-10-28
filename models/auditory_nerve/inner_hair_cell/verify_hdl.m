c1_chirp_filter     = testSignal.audio(:,1);
c2_wideband_filter  = testSignal2.audio(:,1);
inner_hair_cell_out = zeros(1,length(c1_chirp_filter));

for i = 1:length(c1_chirp_filter)
    inner_hair_cell_out(1,i) = inner_hair_cell_source(c1_chirp_filter(i), slope_c1, ihcasym_c1, c2_wideband_filter(i), slope_c2, ihcasym_c2, tdres, Fcihc, i-1, gainihc, orderihc);
end

ihc_inhdl = hdlcosim_dataplane;

% Data Plane Inputs
clk_enable              = fi(1,0,1,0);
avalon_sink_valid       = fi(1,0,1,0);
avalon_sink_channel     = fi(1,0,1,0);
avalon_sink_error       = fi(1,0,2,0);
register_control_enable = fi(1,0,1,0);

clock_cycles = length(c1_chirp_filter) * 1024;
j = 1;
for i = 1:clock_cycles
    if(mod(i,1024) == 1)
        avalon_sink_data = fi(c1_chirp_filter(j),1,32,28);
        sink_data2       = fi(c2_wideband_filter(j),1,32,28);
        hdl_data_in1(j) = avalon_sink_data;
        hdl_data_in2(j) = sink_data2;
        j = j + 1;
    end
    [ce_out, avalon_source_valid, avalon_source_data, avalon_source_channel, avalon_source_error] = step(ihc_inhdl, clk_enable, avalon_sink_valid, avalon_sink_data, avalon_sink_channel, avalon_sink_error, register_control_enable, sink_data2);
    if(mod(i,1024) == 1)
        ihc_out(j) = avalon_source_data;
    end
end

figure
subplot(3,1,1)
plot(c1_chirp_filter)
hold on
plot(hdl_data_in1,'--')
title('Audio Input - C1 Chirp Filter')
legend('Input', 'HDL Data In')

subplot(3,1,2)
plot(c2_wideband_filter)
hold on
plot(hdl_data_in2,'--')
title('Audio Input - C2 Wideband Filter')
legend('Input', 'HDL Data In')

subplot(3,1,3)
plot(ihc_out)
hold on
plot(ihc_out,'--')
legend('C Source Code', 'HDL')
title('Inner Hair Cell: HDL Output vs Simulation')