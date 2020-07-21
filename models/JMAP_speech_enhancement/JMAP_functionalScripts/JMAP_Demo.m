%% Load Audio Files
[xx1, Fs1] = audioread('flat_earth.wav');
[xx2, Fs2] = audioread('alan_1.wav');
Fs = 48000;

cnt = 1;

% Add Noise to Signals
xx1 = resample(xx1, Fs, Fs1);
xx1 = xx1 + 0.005*max(xx1)*rand(size(xx1));
xx2 = resample(xx2, Fs, Fs2);
xx2 = xx2 + 0.005*max(xx2)*rand(size(xx2));

tt1 = (1:length(xx1))' / Fs;
tt2 = (1:length(xx2))' / Fs;

% Shorten Signal 2
sigShort = tt2(find(tt2 <= 10));

tt2 = tt2(1:length(sigShort));
xx2 = xx2(1:length(sigShort));
x2Out = zeros(length(xx2), 6);
x1Out = zeros(length(xx1), 6);

t2Out = zeros(length(tt2), 6);
t1Out = zeros(length(tt1), 6);

%% Clean Up Audio 
for beta = 0.5:0.5:1
    % Obtain Cleaned up signal with beta factor
    [y1, t1] = JMAP_Postfilt_SE_OG(xx1, Fs1, beta);
    [y2, t2] = JMAP_Postfilt_SE_OG(xx2, Fs2, beta);
    
%     figure('units','normalized','outerposition',[0 0 1 1])    
%     Signal 1
%     subplot(211);
%     plot(t1, y1, 'k');
%     title(['Input Signal flat-earth.wav Post JMAP Filtering ' newline ...
%            'with \beta = ', num2str(beta) ]);
%     xlabel('Time [sec]');
%     
    x1Out(:,cnt) = y1;
    t1Out(:,cnt) = t1;

    % Signal 2
%     subplot(212);
%     plot(t2, y2, 'k');
%     title(['Input Signal alan-1.wav Post JMAP Filtering ' newline ...
%            'with \beta = ', num2str(beta) ]);
%     xlabel('Time [sec]');
%     print(['output_beta_', num2str(cnt)], '-djpeg');
    
    x2Out(:,cnt) = y2;
    t2Out(:,cnt) = t2;
    
    % Increment counter and clear signals
    cnt = cnt + 1;
    clear('y1');
    clear('t1');
    clear('y2');
    clear('t2');
end
%% Write Waves
% audiowrite('x1Out_beta_0d5.wav', x1Out(:,1), Fs);
% audiowrite('x1Out_beta_1.wav'  , x1Out(:,2), Fs);
% audiowrite('x1Out_beta_1d5.wav', x1Out(:,3), Fs);
% audiowrite('x1Out_beta_2.wav'  , x1Out(:,4), Fs);
% audiowrite('x1Out_beta_2d5.wav', x1Out(:,5), Fs);
% audiowrite('x1Out_beta_3.wav'  , x1Out(:,6), Fs);
% 
% audiowrite('x2Out_beta_0d5.wav', x2Out(:,1), Fs);
% audiowrite('x2Out_beta_1.wav'  , x2Out(:,2), Fs);
% audiowrite('x2Out_beta_1d5.wav', x2Out(:,3), Fs);
% audiowrite('x2Out_beta_2.wav'  , x2Out(:,4), Fs);
% audiowrite('x2Out_beta_2d5.wav', x2Out(:,5), Fs);
% audiowrite('x2Out_beta_3.wav'  , x2Out(:,6), Fs);


%% User Menu Diff cmd
runn = 1;
brk = 1;
while (runn ~= 0)
list = {'Play Input Audio File 1 (flat_earth.wav)'         ...
        'Play Input Audio File 2 (alan_1.wav)'             ...
        'Play Output Audio File 1 (flat_earth_Mod.wav) \beta = 0.5'    ...
        'Play Output Audio File 2 (flat_earth_Mod.wav) \beta = 1.5'        ...
        'Play Output Audio File 2 (flat_earth_Mod.wav) \beta = 3.0'        ...
        'Play Output Audio File 2 (alan_1_Mod.wav) \beta = 0.5'        ...
        'Play Output Audio File 2 (alan_1_Mod.wav) \beta = 1.5'        ...
        'Play Output Audio File 2 (alan_1_Mod.wav) \beta = 3.0'        ...
        'Exit.'};
[indx, tf] = listdlg('ListString', list, 'ListSize', [900, 600], 'Name', 'Audio Logic JMAP Demos');

sndShort = length(xx2)*0.25;
switch(indx)
    case 1
        close all;
        figure('units','normalized','outerposition',[0 0 1 1])    
        plot((1:length(xx1))' / Fs, xx1);
        xlabel('Time [sec]');
        title('Input Signal: flat-earth.wav');
        pause(1.5);
        soundsc(xx1, Fs);
        
    case 2
        close all;
        figure('units','normalized','outerposition',[0 0 1 1])    
        plot((1:length(xx2))' / Fs, xx2(1:length(xx2)));
        xlabel('Time [sec]');
        title('Input Signal: alan-1.wav');
        pause(1.5);
        soundsc(xx2, Fs);
        
    case 3
        close all;
        figure('units','normalized','outerposition',[0 0 1 1])    
        plot(t1Out(:,1), x1Out(:,1));
        xlabel('Time [sec]');
        title('Output Signal: flat-earth.wav (JMAP Modified \beta = 0.5)');
        pause(1.5);
        soundsc(x1Out(:,1), Fs);
        
    case 4
        close all;
        figure('units','normalized','outerposition',[0 0 1 1])    
        plot(t1Out(:,3), x1Out(:,3));
        xlabel('Time [sec]');
        title('Output Signal: flat-earth.wav (JMAP Modified \beta = 1.5');
        pause(1.5);
        soundsc(x1Out(:,3), Fs);
        
    case 5
        close all;
        figure('units','normalized','outerposition',[0 0 1 1])    
        plot(t1Out(:,6), x1Out(:,6));
        xlabel('Time [sec]');
        title('Output Signal: flat-earth.wav (JMAP Modified \beta = 3.0');
        pause(1.5);
        soundsc(x1Out(:,6), Fs);
        
    case 6
        close all;
        figure('units','normalized','outerposition',[0 0 1 1])    
        plot(t2Out(:,1), x2Out(:,1));
        xlabel('Time [sec]');
        title('Output Signal: alan-1.wav (JMAP Modified \beta = 0.5');
        pause(1.5);
        soundsc(x2Out(:,1), Fs);
        
    case 7
        close all;
        figure('units','normalized','outerposition',[0 0 1 1])    
        plot(t2Out(:,3), x2Out(:,3));
        xlabel('Time [sec]');
        title('Output Signal: alan-1.wav (JMAP Modified \beta = 1');
        pause(1.5);
        soundsc(x2Out(:,3), Fs);
        
    case 8
        close all;
        figure('units','normalized','outerposition',[0 0 1 1])    
        plot(t2Out(:,6), x2Out(:,6));
        xlabel('Time [sec]');
        title('Output Signal: alan-1.wav (JMAP Modified \beta = 1.5');
        pause(1.5);
        soundsc(x2Out(:,6), Fs);
        
    case 9
        runn = 0;
end

indx = [];

end

close all;
