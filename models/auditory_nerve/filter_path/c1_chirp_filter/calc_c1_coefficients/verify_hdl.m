data_input  = testSignal.audio(:,1);
c1_chirp_out = zeros(1,length(data_input));

for i = 1:length(data_input)
    c1_chirp_out(1,i) = C1ChirpFilt(data_input(i), tdres, cf, i-1, taumax, rsigma);
end

c1_chirp_inhdl = hdlcosim_dataplane;

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
    [ce_out, avalon_source_valid, avalon_source_data, avalon_source_channel, avalon_source_error] = step(c1_chirp_inhdl, clk_enable, avalon_sink_valid, avalon_sink_data, avalon_sink_channel, avalon_sink_error, register_control_enable, rsigma);
    if(mod(i,1024) == 1)
        c1_chirp_hdl_out(j) = avalon_source_data;
    end
end

figure
subplot(2,1,1)
plot(data_input)
hold on
plot(hdl_data_in,'--')
title('Audio Input')
legend('Input', 'HDL Data In')

subplot(2,1,2)
plot(c1_chirp_out)
hold on
plot(c1_chirp_hdl_out,'--')
legend('C Source Code', 'HDL')
title('HDL Output vs Simulation')