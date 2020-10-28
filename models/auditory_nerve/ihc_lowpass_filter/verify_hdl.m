data_input1 = testSignal.audio(:,1);
data_input2 = testSignal2.audio(:,1);
ihc_lpf_out = zeros(1,length(data_input1));

for i = 1:length(data_input1)
    ihc_lpf_out(1,i) = IhcLowPass(data_input1(i), data_input2(i), tdres, Fcihc, i-1, gainihc, orderihc);
end

ihc_nl_log_inhdl = hdlcosim_dataplane;

% Data Plane Inputs
clk_enable              = fi(1,0,1,0);
avalon_sink_valid       = fi(1,0,1,0);
avalon_sink_channel     = fi(1,0,1,0);
avalon_sink_error       = fi(1,0,2,0);
register_control_enable = fi(1,0,1,0);

clock_cycles = length(data_input1) * 1024;
j = 1;
for i = 1:clock_cycles
    if(mod(i,1024) == 1)
        avalon_sink_data = fi(data_input1(j),1,32,28);
        sink_data2 = fi(data_input2(j),1,32,28);
        hdl_data_in1(j) = avalon_sink_data;
        hdl_data_in2(j) = sink_data2;
        j = j + 1;
    end
    [ce_out, avalon_source_valid, avalon_source_data, avalon_source_channel, avalon_source_error] = step(ihc_nl_log_inhdl, clk_enable, avalon_sink_valid, avalon_sink_data, avalon_sink_channel, avalon_sink_error, register_control_enable, sink_data2);
    if(mod(i,1024) == 1)
        ihc_lpf_hdl_out(j) = avalon_source_data;
    end
end

figure
subplot(3,1,1)
plot(data_input1)
hold on
plot(hdl_data_in1,'--')
title('Audio Input - C1 Chirp NL Log')
legend('Input', 'HDL Data In')

subplot(3,1,2)
plot(data_input2)
hold on
plot(hdl_data_in2,'--')
title('Audio Input - C2 Wideband NL Log')
legend('Input', 'HDL Data In')

subplot(3,1,3)
plot(ihc_lpf_out)
hold on
plot(ihc_lpf_hdl_out,'--')
legend('C Source Code', 'HDL')
title('HDL Output vs Simulation')