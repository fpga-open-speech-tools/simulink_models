%% get output and perform verification
% Don't run this when the model is converted to VHDL since we don't 
% want to run the verification multiple times at this point
% (HDL coder runs the simulation multiple times)

% if mp.fastsim_flag ~= 3  % Don't run when in HDL Coder Mode
%     
%     % Put the output into the mp data struct
%     % Note: The "To Workspace" block won't accept structs
%     mp.Avalon_Sink_Data.Time    = Avalon_Sink_Data.Time;    % time
%     mp.Avalon_Sink_Data.Data    = Avalon_Sink_Data.Data;    % data
%     mp.Avalon_Sink_Channel.Data = Avalon_Sink_Channel.Data; % channel
%     mp.Avalon_Sink_Valid.Data   = Avalon_Sink_Valid.Data;   % valid
%     
%     mp = sm_stop_process_output(mp);  % get the output and convert from Avalon to vector
%     mp = sm_stop_verify(mp);          % verify that the output is correct
%     
% end

%%