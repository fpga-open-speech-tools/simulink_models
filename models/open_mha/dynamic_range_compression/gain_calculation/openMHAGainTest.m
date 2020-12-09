close all
clear
clc

%% Define some parameters
mins     = [ 0 50 44 35 57 70 20 0 ];
maxes    = [ 93 85 93 50 60 90 30 60 ];

inputRef = 4e-10; % Defined in the Gain Calculation dB Lookup Table reference model
inputdB  = 0:3:93;

% Compute the input level for comparison
inputLev = 10.^(inputdB/10)*inputRef;

%% Compute the gains
gainArray = calculateGainArray(mins, maxes, inputdB);

%% Plot the data
figure(1)
hold on
plot(10*log10(gainArray(1:length(inputLev))) + inputdB)
plot(10*log10(gainArray(1:length(inputLev)).*inputLev/inputRef),'--')
hold off
legend('Gain + dB Input','Full Multiplication');
ylabel('Signal Level [ dB ]')

ncol = ceil(sqrt(length(mins)));
nrow = ceil(length(mins)/ncol);

% Make two more figures
figure('position',[ 150 150 1300 900 ])
figure('position',[ 150 150 1300 900 ])

for ii = 1:length(mins)
  inds = (1:length(inputdB)) + (ii-1)*length(inputdB);
  figure(2)
  subplot(nrow,ncol,ii)
  plot(inputdB,gainArray(inds));
  title(['Band ' num2str(ii)],'interpreter','latex','fontsize',14)
  xlabel('Input Level [ dB ]','interpreter','latex','fontsize',12)
  ylabel('Gain','interpreter','latex','fontsize',12)
  
  figure(3)
  subplot(nrow,ncol,ii)
  hold on
  plot(inputdB,10*log10(gainArray(inds)) + inputdB)
  plot(inputdB,10*log10(gainArray(inds).*inputLev/inputRef),'--')
  hold off
  axis([min(inputdB) max(inputdB) min(inputdB) max(inputdB)])
  title(['Band ' num2str(ii)],'interpreter','latex','fontsize',14)
  xlabel('Input Level [ dB ]','interpreter','latex','fontsize',12)
  ylabel('Adjusted dB Level','interpreter','latex','fontsize',12)
end

figure(3)
subplot(nrow,ncol,nrow)
plegend = legend('dB conversion','Full multiplication');
set(plegend,'interpreter','latex','fontsize',8,'location','northwest')



















