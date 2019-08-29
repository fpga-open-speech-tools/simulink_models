%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Audio Compression. 			                                              		%
%   Latest Update                                                                   %
%   05/01/17.                                                                 		%
%  																					%
%   Updated by  
%       E. Bailey Galacci
%  		Hao Yiya                                                              		%
%     	Ram Charan Chandra Shekar                                             		%
%     	Gautam Bhatt  																%			
%	Created By                                                                		%
%	Brian C.J Moore (et al)                                                   		%
%   Copyright © 2016                                                          		% 
%    Sensory Neuroscience and Experimental Psychology, University of Cambridge		%
%    All rights reserved.                                                          	%       
%																					%
%                                                          							%
%                                                                             		%
%    																		  		% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%#codegen

%% multi-channel version, requested by BCJM in April 2015: 1, 3, 5, 8, 12, 16, and 22 channels
% % try to make NChans selectable from program.
% % 1 Nov 2012: updated version to handle long attack times in SLOW compression M.A.Stone, Auditory Perception Group.
% % (1) put limiter in each channel after compressor stage (attack time & CRlim not available via GUI)
% % (2) print out %-age of activity of limiter (post [recalculate])
% % (3) extend range of frequencies for which IG can be specified (now down to 125 Hz, but subject to implementation via FIR)
% % Changes have occurred to [aid_sim, aid_panel.fig, recalculate, Nchan_FbankAid, dualchannel_AGC]
% % Small change to [prescription_design_function.m] so as to extend plotting area
% % DOS-box window

%% remove possible earlier variables for safety
clear
DIAGNOSTIC = 1;  %% flag to give more information as simulation proceeds such as comments & plots
CALIB_DIAGNOSTIC =  1; %% flag to give more information about calibration of filterbank due to overlap between filters: Mar 2016
PRESCRIPT = 1;  %% flag to plot requested versus achieved insertion gains (esp for 125-250 Hz region).
ipfiledigrms = -22; %% input file RMS in dB for 65 dB SPL equivalent
opfiledigrms = -36; %% output file RMS in dB for 65 dB SPL equivalent
equiv_ipSPL = 65; %% simulation of signal at this level through aid`
% % UPPER_FREQ_LIM = min(11e3, 0.95*Fs/2);  set below once Fs has been defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% do not change anything below here MAS June 2015
%VALID_WAV_FILE = 0; %% flag set by loadwavfile to indicate valid new file loaded
re_level = 10.^(.05*(equiv_ipSPL-65)); %% scale factor at start of hearing aid, to get input to desired simulation level
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NChans = 5 ; PermissibleNChans = [1, 3, 5, 8, 12, 16, 22];
%%%% TESTING, uncomment later
%while ~ismember(NChans, PermissibleNChans)
%    NChans = input('How many channels to simulate [1, 3, 5, 8, 12, 16, or 22] ? ');% Premade:[3, 5, or 22] ? '); % Dynamic:[1, 3, 5, 8, 12, 16, or 22] ? ');
%end
 %   AidSettings5Chans;
    aligndelaymsec = 0;
     
%eval( sprintf('AidSettings%dChans', NChans) ); %% load external script containing AGC & channel parameters
[deltaFSdB, chan_cfs, chan_crs, chan_thrs, t_atts, t_rels, ta_lim, tr_lim] ... %[aligndelaymsec]
    = AidSettingsXChans(NChans); %% load external script containing AGC & channel parameters
[VALID_WAV_FILE, sig, Fs, nbits, file_rms_dB, NStreams] ...
    = loadwavfile(ipfiledigrms); %%  find [Fs], performs [recalculate] externally, provided valid file found
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% start off with some default values for aid settings.
EQ_SPAN_MSEC = 6; %% width of FIR for equalisation curve, limits lowest freqs at which significant gain changes can occur
%% assume gains specified at 125, 250, 500, 1k, 2k, 3k, 4k, 6k, 8k and 10k Hz (125 Hz new post Nov 2012)
insrt_frqs = [125, 250, 500, 1000, 2000, 3000, 4000, 6000, 8000, 10000 ]; %% decimal values
%% gain values in dB at same freqs as insrt_frqs
%%insrt_gns = [ 0 0 0 0 0 0 0 0 0 0]; %% dB for 65 dB input
insrt_gns = [0 3 5 10 15 20 25 30 30 30]; %% dB for 65 dB input
%%insrt_gns = [5 5 5 5 5 5 5 5 5 5]; % make quiet sounds slightly louder
n_insrts = length(insrt_gns);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% only calculate simulation if new wav file found
if (VALID_WAV_FILE)
    UPPER_FREQ_LIM = min(11e3, 0.90*Fs/2);
    [ig_eq, calib_bpfs, dig_chan_lvl_0dBgain, dig_chan_dBthrs, Calib_recomb_dBpost] ...
        = update_channel_params(Fs, NChans, chan_cfs, chan_thrs, insrt_frqs, insrt_gns, ...
        ipfiledigrms, UPPER_FREQ_LIM, EQ_SPAN_MSEC, PRESCRIPT, DIAGNOSTIC, CALIB_DIAGNOSTIC) ;  %% calculates channel edge frequencies, generates expected band levels for LTASS SWN to calibrate compressors & filterbank
    
    % recalculate requires real-time analysis. Everything before can be done in pre-processing
    [proc_sig]...
        = recalculate ...
        (NChans, sig, Fs, re_level, calib_bpfs, t_atts, t_rels, ...
        chan_crs, dig_chan_lvl_0dBgain, dig_chan_dBthrs, deltaFSdB, ... %[aligndelaymsec]
        ta_lim, tr_lim, Calib_recomb_dBpost, ig_eq, DIAGNOSTIC); 
    
    [opwav, stop_ok] = savewavfile(opfiledigrms, ipfiledigrms, proc_sig, Fs, nbits, NStreams);
    
    if  stop_ok, fprintf('\nFINISHED normally\n');
    else
        fprintf('\nFailed to save processed file\n');
    end
else
    fprintf('\nABNORMAL TERMINATION: check messages above\n');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


