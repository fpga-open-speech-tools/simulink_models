% %% JMAP_STOP
% % Output Signals and Plots/Sounds Comparisons
% % Model Output Signals
% xOut = double(sim_result);
% tOut = (1:length(sim_result))' / Fs;
% 
% % x = x;
% t_in = (1:length(x))'/ Fs_in;
% % Signals Normalized
% % x      = x/max(x);
% % x_exp     = x_exp/max(x_exp);
% % xOut_norm = xOut/max(xOut);
% 
% % Audio Players
% xIn_aud  = audioplayer(x, Fs_in);
% xOut_aud = audioplayer(xOut, Fs);
% xOut_exp = audioplayer(x_exp, Fs);
% % User Menu
% choice = 1; % Initialize Variable to not zero
% 
% 
% % plot(double(sim_result));
% % Write audio outputs to files.
% audiowrite('sim_result.wav', double(sim_result), Fs);
% audiowrite('alg_result.wav', x_exp, Fs);
% 
% disp('Calling dataCompare.m script');
% dataCompare
% 
% 
% 
% plot((1:double(sim_result))*Ts, double(sim_result));