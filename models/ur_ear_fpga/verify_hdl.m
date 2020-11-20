% Matlab function that verifies the Simulink HDL 
%
% Copyright 2019 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Connor Dack
% AudioLogic, Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

%% Initialization
data_input = testSignal.audio(:,1);
total_stim = length(data_input);
rep_time   = total_stim * tdres;
total_mean_rate = sum(data_input/length(data_input));
MaxArraySizeSpikes = length(data_input)*nrep;

%% Compute the HDL Simulation Results from the Source Code
mex 'validation\model_IHC_BEZ2018.c' 'validation\complex.c'                             % Compile the UR EAR IHC BEZ2018 Model
mex 'synapse_spike_generator_model\spike_generator\spikegen_source.c' 'synapse_spike_generator_model\complex.c'
anm_source_out = model_IHC_BEZ2018(data_input', cf, 1, tdres, rep_time, cohc, cihc, 2); % Simulate the Auditory Nerve Model
pla_nl_out     = NLBeforePLA(anm_source_out, total_stim, spont, cf);
syn_out        = PowerLaw(pla_nl_out, total_stim, randNums, Fs);
[spCount_source, sptime_source, trd_vector_source, sp_count_redock_1, sp_count_redock_2, sp_count_redock_3, sp_count_redock_4] = spikegen_source( ...
    syn_out, tdres, t_rd_rest, t_rd_init, tau, t_rd_jump, nSites, tabs, trel, spont, total_stim, nrep, total_mean_rate, MaxArraySizeSpikes);
[counts_source_out, valid_source_out] = integrateCounts(integrationTime,sp_count_redock_1,sp_count_redock_2,sp_count_redock_3,sp_count_redock_4);

%% HDL Simulation
ur_ear_fpga_inhdl = hdlcosim_dataplane;
hdl_data_in       = zeros(total_stim,1);
counts_hdl_out    = zeros(total_stim,1);
valid_hdl_out     = zeros(totatl_stim,1);

% Data Plane Inputs
clk_enable              = fi(1,0,1,0);
avalon_sink_valid       = fi(1,0,1,0);
avalon_sink_channel     = fi(1,0,1,0);
avalon_sink_error       = fi(1,0,2,0);
register_control_enable = fi(1,0,1,0);

clock_cycles = total_stim * 1024;
j = 1;

progress_bar = waitbar(0, 'Initializing Simulation');

for i = 1:clock_cycles
    if(mod(i,1024) == 1)
        avalon_sink_data = fi(data_input(j),1,32,28);
        hdl_data_in(j) = avalon_sink_data;
        progress = j/totalstim;
        progress_str = ['Simulation: ' num2str(progress*100) '% Complete - Input ' num2str(j) ' of ' num2str(totalstim)];
        waitbar(progress,progress_bar,progress_str);
        j = j + 1;
    end
    [~, ~, avalon_source_data, ~, ~, count_hdl, valid_hdl] = step(ur_ear_fpga_inhdl, clk_enable, avalon_sink_valid, avalon_sink_data, avalon_sink_channel, avalon_sink_error, register_control_enable);
    if(mod(i,1024) == 1)
        counts_hdl_out(j) = count_hdl;
        valid_hdl_out(j)  = valid_hdl;
    end
end


%% Plot the Results
figure
subplot(3,1,1)
plot(data_input)
hodl on
plot(hdl_data_in,'--')
title(['Audio Input: Sampling Freq: ' num2str(Fs) ' Hz'])

subplot(3,1,2)
plot(counts_source_out)
hold on
plot(spike_count_sim_out,'--')
legend('MATLAB Source Code','Simulink')
title('UR EAR - Accumulator Counts' )

subplot(4,1,4)
plot(valid_source_out)
hold on
plot(spike_valid_sim_out,'--')
legend('MATLAB Code','Simulink')
title('UR EAR - Accumulator Valid')