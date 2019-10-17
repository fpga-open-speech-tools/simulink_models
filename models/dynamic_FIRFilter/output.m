%% E. Bailey Galacci & Justin P Williams
% Flat Earth Inc.
% 10/17/2019

% This script is to display the outputs of the dynamicFIRv1 simulink model
close all;
%% Plot of Inputs
figure(1);
subplot(2,2,1);
plot(Register_Addr);
xlabel('Time [sec]'); title('Register Address');
subplot(2,2,2);
plot(Register_Data);
xlabel('Time [sec]'); title('Register Data');
subplot(2,2,3);
plot(Register_Write_En);
xlabel('Time [sec]'); title('Write Enable');
subplot(2,2,4);
plot(inSignal);
xlabel('Time [sec]'); title('Input Signal to get Filtered');
%% Plot of Outputs
figure(2);
subplot(3,1,1);
plot(out.wr_dout);
subplot(3,1,2);
plot(out.outputBus);
legend;
subplot(3,1,3);
plot(out.outSignal);