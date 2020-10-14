recObj = audiorecorder(48000, 24, 2);
test_size = size(testSignal.audio);
testAudio = zeros(test_size(1), test_size(2)) + .6;
%sound(testSignal.audio, testSignal.sampleRateHz, 24);
%sound(testAudio, testSignal.sampleRateHz, 24);
recordblocking(recObj, 15);
y = getaudiodata(recObj);

scaling_factor =  1;

figure(5)
subplot(3,1,1)
plot(testSignal.audio(:,1)); hold on
%plot(y(:,1))
title('Input')

subplot(3,1,2)
%plot(testSignal.audio(:,2)); hold on
%plot(testSignal.audio(:,1)); hold on
plot(y(:,1) * scaling_factor)
title('Output')

subplot(3,1,3)
plot(y(:,2) * scaling_factor)

disp(sum(abs(testSignal.audio(:,1))))
disp(sum(abs(y(:,1))))
 max_y = max(y(:,1));
 max_test = max(testSignal.audio(:,1));
 disp(max_test / max_y)

