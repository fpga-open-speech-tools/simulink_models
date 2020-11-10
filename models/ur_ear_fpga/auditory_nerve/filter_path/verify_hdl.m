
%% Compute the C Source Output
close all;

load rsigma.mat                        % Load Rsigma
mex C1ChirpFilt.c complex.c            % Compile C1 Filter Source
mex C2ChirpFilt.c complex.c            % Compile C2 Filter Source
mex inner_hair_cell_source.c complex.c % Compile the IHC Source

% Initialize Data Arrays
data_input          = testSignal.audio(:,1);
rsigma_plot         = zeros(1,length(data_input));
c1_chirp_out        = zeros(1,length(data_input));
c2_wbf_out          = zeros(1,length(data_input));
inner_hair_cell_out = zeros(1,length(data_input));


for i = 1:length(data_input)
    rsigma_plot(i)           = rsigma_sim_in.data(i);
    c1_chirp_out(1,i)        = C1ChirpFilt(data_input(i), tdres, cf, i-1, taumaxc1, rsigma_plot(i));
    c2_wbf_out(1,i)          = C2ChirpFilt(data_input(i), tdres, cf, i-1, taumaxc2, fcohcc2);
    inner_hair_cell_out(1,i) = inner_hair_cell_source(c1_chirp_out(i), slope_c1, ihcasym_c1, c2_wbf_out(i), slope_c2, ihcasym_c2, tdres, Fcihc, i-1, gainihc, orderihc);
end

%% Run the HDL Simulation
filter_path_inhdl = hdlcosim_dataplane;
% Initialize Data Arrays
rsigma_hdl_in       = zeros(length(data_input),1);
hdl_data_in         = zeros(length(data_input),1);
filter_path_hdl_out = zeros(length(data_input),1);

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
        rsigma_hdl_in(j) = single(rsigma(j)); 
        hdl_data_in(j)   = avalon_sink_data;
        j = j + 1;
    end
    [ce_out, avalon_source_valid, avalon_source_data, avalon_source_channel, avalon_source_error] = step(filter_path_inhdl, clk_enable, avalon_sink_valid, avalon_sink_data, avalon_sink_channel, avalon_sink_error, register_control_enable, rsigma_hdl_in(j));
    if(mod(i,1024) == 1)
        filter_path_hdl_out(j) = avalon_source_data;
    end
end

%% Plot the Results
figure
subplot(3,1,1)
plot(data_input)
hold on
plot(hdl_data_in, '--')
legend('Middle Ear Filter Result', 'HDL Audio Input')
title('Audio Input')

subplot(3,1,2)
plot(rsigma_plot)
hold on
plot(rsigma_hdl_in, '--')
legend('Rsigma', 'Rsigma HDL')
title('R Sigma Input')

subplot(3,1,3)
plot(inner_hair_cell_out)
hold on
plot(filter_path_hdl_out,'--')
legend('C Source Code','HDL')
title('Filter Path Results')