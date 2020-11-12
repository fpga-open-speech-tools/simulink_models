
%%% Autogen parameters
test_FFT_to_gain_init;
mp.testFile = [mp.test_signals_path filesep 'acoustic.wav'];

% TODO: use booleans instead of 0 and 1
mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 5;
 mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;
%mp.nSamples = 2048;

mp.useAvalonInterface = false;

mp.W_bits = 24;
mp.F_bits = 23;

%% Model parameters 
mp.FFT_size = 128;
% XXX: an unsigned int of mp.FFT_size_Nbits only goes up to mp.FFT_size - 1; not sure if that's intended or a bug 
mp.FFT_size_Nbits = log2(mp.FFT_size);
mp.FFT_size_half = mp.FFT_size/2;
mp.FFT_frame_shift = mp.FFT_size/4;  % Changiing this from a divide by four implies substantial architectural changes
mp.FFT_frame_shift_Nbits = log2(mp.FFT_frame_shift);

mp.DPRAM1_size = mp.FFT_size*2;  % number of words
mp.DPRAM1_address_size = log2(mp.DPRAM1_size);

mp.SysRate_Upsample_Factor = mp.FFT_size/mp.FFT_frame_shift * 8 * 4;  % How much faster the fast clock must be to complete a FFT within the time of FFT_frame_shift number of samples

%% Declare DPR variables
num_bands = 8;
n_ar      = num_bands*2;
n_vy      = 32;
n_shift   = 16;
RAM_size = 8 ;

%% Create the input data
dp_gt = repmat(1:32,num_bands,1);

RAM_addresses = 2^(RAM_size);
%vy = dp_gt;
%for i = length(dp_gt)+1:RAM_addresses
%    vy(i,1) = 0;
%end

%ar_coeffs = 16:-1:1;

%% Declare Control Signals


ar_data_in   = (n_ar*ones(RAM_addresses,1))-1;
%ar_data_in = uint32(ar_data_in);
vy_data_in = (RAM_addresses*ones(RAM_addresses,1))-1;
%vy_data_in = uint32(vy_data_in);

ar_data_in(1:n_ar) = (1:n_ar)-1;
% ar_data_in(n_ar+1:end) = n_ar;

vy_data_in(1:RAM_addresses) = (1:RAM_addresses)-1;
% vy_data_in(RAM_addresses+1:end) = RAM_addresses;

% Shift the addresses into the correct location
ar_data_in = bitshift(ar_data_in,n_shift);
vy_data_in = bitshift(vy_data_in,n_shift);

% Add the coefficients to the variables
ar_data_in(1:n_ar) = ar_data_in(1:n_ar) + ar_coeffs(1:n_ar);
vy_data_in(1:RAM_addresses) = vy_data_in(1:RAM_addresses) + vy(1:RAM_addresses);

% ar_data_in   = (n_ar*ones(n_ar,1))-1;
% vy_data_in = (RAM_addresses*ones(RAM_addresses,1))-1;
% 
% ar_data_in(1:n_ar) = (1:n_ar)-1;
% % ar_data_in(n_ar+1:end) = n_ar;
% 
% vy_data_in(1:RAM_addresses) = (1:RAM_addresses)-1;
% % vy_data_in(RAM_addresses+1:end) = RAM_addresses;
% 
% % Shift the addresses into the correct location
% ar_data_in = bitshift(ar_data_in,n_shift);
% vy_data_in = bitshift(vy_data_in,n_shift);
% 
% % Add the coefficients to the variables
% ar_data_in(1:n_ar) = ar_data_in(1:n_ar) + ar_coeffs(1:n_ar)';
% vy_data_in(1:RAM_addresses) = vy_data_in(1:RAM_addresses) + vy(1:RAM_addresses)';