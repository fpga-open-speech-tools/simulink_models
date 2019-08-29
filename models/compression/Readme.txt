%%
% Readme file for Multichannel compression by Dr. BCJ Moore 
% Requested by Dr. I Panahi
% Anshuman Ganguly SSPRL 9/16/2016
% Added documentation by Bailey Galacci


% The following is the order of the execution of the Multichannel Compression Algo.:


% MultiChanAidSim.m (Main script)- Calling the Main script calls all other functions
%	1.0 AidSettingsXChans.m		- Loads settings for X number of channels

%	1.1 loadwavfile.m - Loads wav file
%		1.1.1 channel_rms.m		- Measure RMS of audio signal in a standard way
%			1.1.1.1 generate_key_percent.m		- Move key_thr_dB to account for noise less peakier than signal

%	1.2 update_channel_params.m - Updates channel parameters
%		1.2.1 Nchan_FbankDesign.m
%		1.2.2 prescription_design_function.m (ifft)
%		1.2.3 CalibrateFilterBankOverlap.m
%			1.2.3.1 gen_eh2008_speech_noise.m	- generate 1-sec callibration noise, with unity RMS input level
%			1.2.3.2 integrate_band_powers.m	(4x)- generates new dB levels for each bandpass to correct non-unity gain

%	1.3 recalculate.m
%		1.3.2 Nchan_FbankAGCAid.m		- uses designed filters to offset the bandpass
%			1.3.2.1 dualchannel_AGC.m	- apply gain as an envelope function
%				1.3.2.1.1 time_advance.m	- commented out, not needed to align bandpass outputs

%	1.4 savewavfile.m
		
>> spectrogram(sig, 512, 256, logspace(1,4, 1001), Fs);
%%
% My simulink version of things:
% Startup:
%	AidSettingsXChans.m 
%	loadwav.m
%	update_channel_params
%	Initialize_AGC_Consts.m
%
%		Now that things are defined well enough in the workspace, the actual model begins