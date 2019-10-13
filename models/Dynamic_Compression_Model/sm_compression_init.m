X_high = 1; % Maximum input
ref_dB = 85; X_ref = 1; % Define a reference point in X and its dBA value
M_bits = 5;   % decides length of tables, 2^(4+M_bits)

NChans = 5;
[chan_cfs, ~ , t_atts, t_rels] ...
   = InitializeCompressionSettings(NChans);

% [newfile, newpath] = uigetfile('*.wav','Open Signal File To Process.....');
% 
% if isequal(newfile,0) || isequal(newpath,0)
%     fprintf(1,'\nFile not found'); VALID_WAV_FILE = 0;
% else
%     [sig, Fs] = audioread(strcat(newpath,newfile));
% end


%% Test input: frequency sweep
Ts = mp.Ts;
Ts_system = mp.Ts_system; % THIS IS BAD I KNOW I'LL FIX IT LATER I SWEAR
% two things are named Ts_system, one is buried inside Model Parameters
Fs = mp.Fs;
%% Replacing update_channel_params with only the needed pieces

EQ_SPAN_MSEC = 6;

insrt_frqs = [125, 250, 500, 1000, 2000, 3000, 4000, 6000, 8000, 10000 ]; %% decimal values
insrt_gns = [0 3 5 10 15 20 25 30 30 30]; %% prescribed dB for 65 dB input
%insrt_gns = 5*ones(1,length(insrt_frqs));  %no prescription

UPPER_FREQ_LIM = min(11e3, 0.90*Fs/2);
[ig_eq, ~] = prescription_design_function(insrt_frqs, insrt_gns, Fs, EQ_SPAN_MSEC, 0); %% separate switch in [aid_sim] to turn off plotting.
%%% update_channel_params, to change edges array, as well as band levels when a channel cf changes.
edges = sqrt ( chan_cfs(2:end) .* chan_cfs(1:end-1) ); %% geometric mean
dummy_low_edge = edges(1)*(chan_cfs(1)/chan_cfs(2)); %% not used directly in Nchan_FbankAid, but helps with filter design, save for later
edges = [edges  UPPER_FREQ_LIM]; %% end stops to make software work, lowest not really implemented in software, upper set in main script
%%% spoof lowest edge freq for filyterbank design, not power calculations, does not produce edge in filterbank design
fb_edges = [dummy_low_edge  edges]; %% will need dummy low edge to make filterbank design software work, lowest not implemented in software other than transition width
[bpfs] = Nchan_FbankDesign(fb_edges, Fs, 0); %% Mar2016 move design of filterbank to here

calib_bpfs = bpfs; %% safety copy

recombGain = ones(1,NChans);
% translate sig into a form simulink likes
% Ts = 1/Fs;
% tt = (0:length(sig)-1).*Ts;
%t_end = tt(5*2^(M_bits+4) );   % to test table fill 
%t_end = tt(end);
%sig_in = [tt', sig];
min_thresh_dB = 0;
for ix = 1:NChans
   [Gain_Table(:,ix), max_gain_prescript(ix), X_in(:,ix), chan_crs(ix)] ...
     = Compression_Wrapper_V2(Fs, min_thresh_dB, ...
     X_high, calib_bpfs(:,ix), ig_eq, ref_dB, X_ref, M_bits);
end

Initialize_Delay_Values;
%chan_recomb_gain = 10.^((0.05*Calib_recomb_dBpost));
W_bits = 32;
F_bits = 28;
M_bits = 5;
M_Bits = M_bits;

% Generating signals for simulink
%Table_Fill = zeros(1,length(tt))';
%Table_Fill(1) = Gain_Table(end,5);
% Table_Fill(1                : 2^(M_bits+4) )  = Gain_Table(:,1);  
% Table_Fill(2^(M_bits+4)+1   : 2*2^(M_bits+4) )= Gain_Table(:,2);
% Table_Fill(2*2^(M_bits+4)+1 : 3*2^(M_bits+4) )= Gain_Table(:,3);  
% Table_Fill(3*2^(M_bits+4)+1 : 4*2^(M_bits+4) )= Gain_Table(:,4);
% Table_Fill(4*2^(M_bits+4)+1 : 5*2^(M_bits+4) )= Gain_Table(:,5);
%Table_Fill_t = [tt', zeros(1,length(tt))'];
%Fill_Valid = zeros(1,length(tt))';
% Fill_Valid(1:5*2^(M_bits+4)) = 1;
% Fill_Valid = boolean(Fill_Valid);
%Fill_Valid_t = [tt', Fill_Valid];
t_att = t_atts./1000; s_att = t_att.*Fs; % change units of t_atts from ms to samples
t_rel = t_rels./1000; s_rel = t_rel.*Fs; % change units of t_rels from ms to samples
r_att = nthroot(0.1, s_att);
r_rel = nthroot(0.1, s_rel);

%Reset = [tt', boolean(zeros(1,length(tt)))'];