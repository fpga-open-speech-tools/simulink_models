%% Scrolling Spectrogram Code
% Copied from https://www.mathworks.com/matlabcentral/answers/100963-how-can-i-generate-a-scrolling-spectrogram-using-the-surf-command-in-matlab-7-5-r2007b


%% Copied Code
%%How can I have my spectrogram scroll on display using the SURF command?
% 
% This can be done by calling the SURF command with new updates either in a
% for loop or through a timer triggered calling function to update the
% plot. In this example in the final figure (3) the figure is updated in a
% simple for loop.
%%Direct visualization of Spectrogram using the SPECTROGRAM function
T = 0:0.001:1;
X = chirp(T,100,1,200,'q');
spectrogram(X,128,120,128,1E3); 
title('Quadratic Chirp');
%%Using the SURF command instead of the default SPECTROGRAM Plot
T = 0:0.001:1;
X = chirp(T,100,1,200,'q');
[Y,F,T,P] = spectrogram(X,128,120,128,1E3);
figure
h = surf(F,T,10*log10(abs(P')),'EdgeColor','none');
axis xy; axis tight; colormap(jet); view(0,20);
xlabel('Time');
ylabel('Frequency (Hz)');
%%Allowing data to scroll using the SURF command
T = 0:0.001:1;
X = chirp(T,100,1,200,'q');
[Y,F,T,P] = spectrogram(X,128,120,128,1E3);
[Prows,Pcols] = size(P);
figure
P_temp = zeros(Prows,Pcols);
% Fix Axis Limits for Plotting so the scrolling appears to be constant
xmin = 0;
xmax = 1;
ymin = -120;
ymax = 120;
for i = 1:Prows
      % Create new matrices (T,F,P) so that they can be used by SURF
      P_temp(1:i,:) = P(1:i,:);
      % Surf Plot the Matrices which update in a for loop
      h = surf(F,T,10*log10(abs(P_temp')),'EdgeColor','none');
      axis xy; axis tight; colormap(jet); view(0,20);
      % Set the axis limits so they appear constant during the plotting
      % process
%    xlim([xmin xmax])
      ylim([ymin ymax])
      xlabel('Time');
      ylabel('Frequency (Hz)');
      pause(0.01)
end