clear;
DIAGNOSTIC = 0;  %% flag to give more information as simulation proceeds such as comments & plots
CALIB_DIAGNOSTIC =  0; %% flag to give more information about calibration of filterbank due to overlap between filters: Mar 2016
PRESCRIPT = 1;  %% flag to plot requested versus achieved insertion gains (esp for 125-250 Hz region).
ipfiledigrms = -36; %% input file RMS in dB for 65 dB SPL equivalent
opfiledigrms = -36; %% output file RMS in dB for 65 dB SPL equivalent
equiv_ipSPL = 65; %% simulation of signal at this level through aid`
X_high = 1; % Maximum input
ref_dB = 85; X_ref = 1; % Define a reference point in X and its dBA value
% re_level = 10.^(.05*(equiv_ipSPL-65)); %% scale factor at start of hearing aid, to get input to desired simulation level
M_bits = 5;   % decides length of tables, 2^(4+M_bits)

NChans = 5;
[chan_cfs, ~ , t_atts, t_rels] ...
   = InitializeCompressionSettings(NChans);
% AidSettings5Chans;

%[VALID_WAV_FILE, sig, Fs, nbits, file_rms_dB, NStreams] ...
%  = loadwavfile(ipfiledigrms); %%  find [Fs], performs [recalculate] externally, provided valid file found
% VALID_WAV_FILE = 1;
%[newfile, newpath] = uigetfile('*.wav','Open Signal File To Process.....');
%if isequal(newfile,0) || isequal(newpath,0)
%    fprintf(1,'\nFile not found'); VALID_WAV_FILE = 0;
%else
%    [sig, Fs] = audioread(strcat(newpath,newfile));
%end


%% Test input: frequency sweep
X_thresh = 1*10^(0.05*(0-85));
Amplitudes = [X_thresh, X_thresh*10, X_thresh*100, X_thresh*1000, X_thresh*10000, 1]; %, X_thresh*100000];

fMin = 100; %Hz
fMax = 10000; %Hz
Fs = 48000; %Hz
Ts = 1/Fs;
%tt = (0:length(sig)-1 )./Fs;
tt = 0:Ts:4;
deltaF = (fMax - fMin)/tt(end);
X_sweep = Amplitudes'*sin(2*pi*(fMin*tt +  0.5*deltaF*tt.*tt)) ;

Fs = 48000;
Volume = 6;
sig = X_sweep(Volume,:)';
%% Replacing update_channel_params with only the needed pieces

% opplayer  = audioplayer(sig, Fs);
% nbits = opplayer.bitspersample;
%sig = resample(sig,48000,Fs);
%Fs = 48000;


% NStreams = min(size(sig));
EQ_SPAN_MSEC = 6;

insrt_frqs = [125, 250, 500, 1000, 2000, 3000, 4000, 6000, 8000, 10000 ]; %% decimal values
insrt_gns = [0 3 5 10 15 20 25 30 30 30]; %% prescribed dB for 65 dB input
%insrt_gns = 5*ones(1,length(insrt_frqs));  %no prescription
% n_insrts = length(insrt_gns);

UPPER_FREQ_LIM = min(11e3, 0.90*Fs/2);

% [ig_eq, calib_bpfs, dig_chan_lvl_0dBgain, dig_chan_dBthrs, Calib_recomb_dBpost] ...
%     = update_channel_params(Fs, NChans, chan_cfs, chan_thrs, insrt_frqs, insrt_gns, ...
%     0.1, UPPER_FREQ_LIM, EQ_SPAN_MSEC, PRESCRIPT, DIAGNOSTIC, CALIB_DIAGNOSTIC) ;  %% calculates channel edge frequencies, generates expected band levels for LTASS SWN to calibrate compressors & filterbank
[ig_eq, ~] = prescription_design_function(insrt_frqs, insrt_gns, Fs, EQ_SPAN_MSEC, 0); %% separate switch in [aid_sim] to turn off plotting.
%%% update_channel_params, to change edges array, as well as band levels when a channel cf changes.
edges = sqrt ( chan_cfs(2:end) .* chan_cfs(1:end-1) ); %% geometric mean
dummy_low_edge = edges(1)*(chan_cfs(1)/chan_cfs(2)); %% not used directly in Nchan_FbankAid, but helps with filter design, save for later
edges = [edges  UPPER_FREQ_LIM]; %% end stops to make software work, lowest not really implemented in software, upper set in main script
%%% spoof lowest edge freq for filyterbank design, not power calculations, does not produce edge in filterbank design
fb_edges = [dummy_low_edge  edges]; %% will need dummy low edge to make filterbank design software work, lowest not implemented in software other than transition width
[bpfs] = Nchan_FbankDesign(fb_edges, Fs, 0); %% Mar2016 move design of filterbank to here

calib_bpfs = bpfs; %% safety copy
% spec_size = 1024;
% bpzTotal= zeros(1,spec_size);
% bpCalzTotal = zeros(1,spec_size);
% Callibrate recombining gain? Or just fix bandpass FIRs to have unity peak gain.
% NOTE: Turns out bpfs have a pretty good peak unity gain. The combination
% of them all has a max error of -65 dBA (0.06%) above unity gain. That's fine.
%close(1); close(2);
% for(ix = 1:NChans)
%     [bpz(ix,:),bpFqs] = freqz(bpfs(2:(bpfs(1,ix)+1),ix),1,spec_size,Fs);
%     bpzMax(ix) = max(abs(bpz(ix,:)));
%     bpCalz(ix,:) = bpz(ix,:)./bpzMax(ix);
%     bpzTotal = bpzTotal + abs(bpz(ix,:));
%     bpCalzTotal = bpCalzTotal + abs(bpCalz(ix,:));
%     figure(1); hold on; semilogx(bpFqs, abs(bpz(ix,:)), 'b');
%     figure(2); hold on; semilogx(bpFqs, abs(bpCalz(ix,:)), 'g');
% end
% figure(1); hold on;
% semilogx(bpFqs, abs(bpzTotal), 'k'); %axis([100 12000 0 1.2]);
% xlabel('tested frqs(Hz)'); ylabel('Gain'); title('Original BP Response');
% figure(2); hold on;
% semilogx(bpFqs, abs(bpCalzTotal), 'k'); %axis([100 12000 0 1.2]);
% xlabel('tested frqs(Hz)'); ylabel('Gain'); title('Callibrated BP Response');
%%

% recombGain = 10.^(0.05.*Calib_recomb_dBpost);
recombGain = ones(1,NChans);
% translate sig into a form simulink likes
% Ts = 1/Fs;
% tt = (0:length(sig)-1).*Ts;
%t_end = tt(5*2^(M_bits+4) );   % to test table fill 
t_end = tt(end);
sig_in = [tt', sig];
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
Table_Fill = zeros(1,length(tt))';
Table_Fill(1                : 2^(M_bits+4) )  = Gain_Table(:,1);  
Table_Fill(2^(M_bits+4)+1   : 2*2^(M_bits+4) )= Gain_Table(:,2);
Table_Fill(2*2^(M_bits+4)+1 : 3*2^(M_bits+4) )= Gain_Table(:,3);  
Table_Fill(3*2^(M_bits+4)+1 : 4*2^(M_bits+4) )= Gain_Table(:,4);
Table_Fill(4*2^(M_bits+4)+1 : 5*2^(M_bits+4) )= Gain_Table(:,5);
Table_Fill_t = [tt', zeros(1,length(tt))'];
Fill_Valid = zeros(1,length(tt))';
% Fill_Valid(1:5*2^(M_bits+4)) = 1;
% Fill_Valid = boolean(Fill_Valid);
% Fill_Valid_t = [tt', Fill_Valid];
t_att = t_atts./1000; s_att = t_att.*Fs; % change units of t_atts from ms to samples
t_rel = t_rels./1000; s_rel = t_rel.*Fs; % change units of t_rels from ms to samples
r_att = nthroot(0.1, s_att);
r_rel = nthroot(0.1, s_rel);

Reset = [tt', boolean(zeros(1,length(tt)))'];