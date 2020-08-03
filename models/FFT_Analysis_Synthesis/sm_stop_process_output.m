%% Get the Avalon streaming signals from the model
function mp = sm_stop_process_output(mp)
t = mp.Avalon_Sink_Data.Time;             % time
d = squeeze(mp.Avalon_Sink_Data.Data);    % data      Note: the Matlab squeeze() function removes singleton dimensions (i.e. dimensions of length 1)
c = squeeze(mp.Avalon_Sink_Channel.Data); % channel
v = squeeze(mp.Avalon_Sink_Valid.Data);   % valid
left_index = 1;
right_index = 1;
for i=1:length(v)
    if v(i) == 1  % check if valid, valid is asserted when there is data
        if c(i) == 0  % if the channel number is zero, it is left channel data
            mp.left_data_out(left_index) = double(d(i));
            mp.left_time_out(left_index) = t(i);
            left_index            = left_index + 1;
        end
        if c(i) == 1  % if the channel number is one, it is right channel data
            mp.right_data_out(right_index) = double(d(i));
            mp.right_time_out(right_index) = t(i);
            right_index             = right_index + 1;
        end
    end
end

%%