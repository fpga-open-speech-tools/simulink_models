close all;

data_input            = testSignal.audio(:,1);
totalstim             = length(data_input);

wbout                 = zeros(1,totalstim);
ohc_sim               = zeros(1,totalstim);
ohc_boltzman          = zeros(1,totalstim);
c_grdelay             = zeros(1,totalstim);
c_rsigma              = zeros(1,totalstim);
c_tauc1               = zeros(1,totalstim);
c_tauwb               = zeros(1,totalstim);
c_wbgain              = zeros(1,totalstim);
c_wbgain_actual       = zeros(1,totalstim);
tmpgain               = zeros(1,totalstim);
c1_chirp_filter       = zeros(1,totalstim);
c2_wideband_filter    = zeros(1,totalstim);
inner_hair_cell_out   = zeros(1,totalstim);

%% Compute Auditory Nerve Results with C Source Code
% Source Code Compiled with Mex During Simulink Simulation
lasttmpgain = wbgain_i;

for i = 1:totalstim
    if(i == 1)
        wbout(1,i) = WbGammaTone(data_input(i),tdres,centerfreq,i-1,tauwb_i,wbgain_i,wborder, TauWBMax, cf);
    else
        wbout(1,i) = WbGammaTone(data_input(i),tdres,centerfreq,i-1,c_tauwb(1,i-1),c_wbgain_actual(1,i-1),wborder, TauWBMax, cf);
    end
    ohc_sim(1,i) = outer_hair_cell_source(wbout(1,i), ohcasym, s0, s1, x1, tdres, Fcohc, i-1, gainohc, orderohc, bmTaumin, bmTaumax);
    [c_grdelay(1,i), c_rsigma(1,i), c_tauc1(1,i), c_tauwb(1,i), c_wbgain(1,i)] = calc_tau_source(tdres, cf, centerfreq, ohc_sim(1,i));
    grd = int32(c_grdelay(i));
    if((grd+i) < length(data_input))
        tmpgain(grd+i) = c_wbgain(i);
    end
    if(tmpgain(i) == 0)
        tmpgain(i) = lasttmpgain;
    end
    c_wbgain_actual(i) = tmpgain(i);
    lasttmpgain = c_wbgain_actual(i);
    [c_grdelay(1,i), c_rsigma(1,i), c_tauc1(1,i), c_tauwb(1,i), c_wbgain(1,i)] = calc_tau_source(tdres, cf, centerfreq, ohc_sim(1,i));
    c1_chirp_filter(1,i)     = C1ChirpFilt(data_input(i), tdres, cf, i-1, taumaxc1, c_rsigma(1,i));
    c2_wideband_filter(1,i)  = C2ChirpFilt(data_input(i), tdres, cf, i-1, taumaxc2, fcohcc2);
    inner_hair_cell_out(1,i) = inner_hair_cell_source(c1_chirp_filter(i), slope_c1, ihcasym_c1, c2_wideband_filter(i), slope_c2, ihcasym_c2, tdres, Fcihc, i-1, gainihc, orderihc);
end

%% HDL Simulation
ihc_inhdl = hdlcosim_dataplane;

% Data Plane Inputs
clk_enable              = fi(1,0,1,0);
avalon_sink_valid       = fi(1,0,1,0);
avalon_sink_channel     = fi(1,0,1,0);
avalon_sink_error       = fi(1,0,2,0);
register_control_enable = fi(1,0,1,0);

hdl_data_in = zeros(totalstim,1);
anm_hdl_out = zeros(totalstim,1);

clock_cycles = totalstim * 1024;
j = 1;
progress_bar = waitbar(0, 'Initializing Simulation');
for i = 1:clock_cycles
    if(mod(i,1024) == 1)
        avalon_input_data = fi(data_input(j,1),1,32,28);
        hdl_data_in(j,1) = avalon_input_data;
        progress = j/totalstim;
        progress_str = ['Simulation: ' num2str(progress*100) '% Complete - Input ' num2str(j) ' of ' num2str(totalstim)];
        waitbar(progress,progress_bar,progress_str);
        j = j + 1;
    end
    [ce_out, avalon_source_valid, avalon_source_data, avalon_source_channel, avalon_source_error] = step(ihc_inhdl, clk_enable, avalon_sink_valid, avalon_input_data, avalon_sink_channel, avalon_sink_error, register_control_enable);
    if(mod(i,1024) == 1)
        anm_hdl_out(j,1) = avalon_source_data;
    end
end
close(progress_bar)

%% Plot the Results
figure
subplot(2,1,1)
plot(data_input)
hold on
plot(hdl_data_in,'--')
title('Audio Input')
legend('Input', 'HDL Data In')

subplot(2,1,2)
plot(inner_hair_cell_out)
hold on
plot(anm_hdl_out(3:end),'--')
legend('C Source Code', 'HDL')
title('Auditory Nerver HDL Simulation')