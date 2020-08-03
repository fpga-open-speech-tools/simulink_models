function mp = sm_init_avalon_signals(mp)
%% create the data-channel-valid signals from the test signals
rate_change = (mp.Fs_system/mp.Fs);
mp.Nsamples_avalon = mp.test_signal.Nsamples * (mp.Fs_system/mp.Fs);
datavals_data    = zeros(1,mp.Nsamples_avalon);   % preallocate arrays
datavals_valid   = zeros(1,mp.Nsamples_avalon); 
datavals_channel = zeros(1,mp.Nsamples_avalon); 
datavals_error   = zeros(1,mp.Nsamples_avalon); 
dataval_index = 1;
for sample_index = 1:mp.test_signal.Nsamples
    %----------------------------
    % left channel
    %----------------------------
    datavals_data(dataval_index)     = mp.test_signal.left(sample_index); 
    datavals_valid(dataval_index)    = 1;   % data is valid in this time bin
    datavals_channel(dataval_index)  = 0;   % channel 0 = left
    datavals_error(dataval_index)    = 0;   % no error
    dataval_index                    = dataval_index + 1;
    %----------------------------
    % right channel
    %----------------------------
    datavals_data(dataval_index)     = mp.test_signal.right(sample_index); 
    datavals_valid(dataval_index)    = 1;  % data is valid in this time bin
    datavals_channel(dataval_index)  = 1;  % channel 1 = right
    datavals_error(dataval_index)    = 0;  % no error
    dataval_index                    = dataval_index + 1;
    %---------------------------------------------
    % fill in the invalid data slots with zeros
    %---------------------------------------------
    for k=1:(rate_change-2)
        datavals_data(dataval_index)    = 0;  % no data (put in zeros)
        datavals_valid(dataval_index)   = 0;  % data is not valid in these time bins
        datavals_channel(dataval_index) = 3;  % channel 3 = no data
        datavals_error(dataval_index)   = 0;  % no error
        dataval_index                   = dataval_index + 1;
    end
end

%% Convert to time series objects that can be read from "From Workspace" blocks
Ndatavals = length(datavals_data);  % get number of data points
timevals  =  [0 1:(Ndatavals-1)]*mp.Ts_system;  % get associated times assuming system clock
mp.Avalon_Source_Data     = timeseries(datavals_data,timevals);
mp.Avalon_Source_Valid    = timeseries(datavals_valid,timevals);
mp.Avalon_Source_Channel  = timeseries(datavals_channel,timevals);
mp.Avalon_Source_Error    = timeseries(datavals_error,timevals);

%%