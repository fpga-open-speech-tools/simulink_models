%% WAWA Filter Coefficient Setup

% Copyright 2020 Flat Earth Inc
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% E. Bailey Galacci
% Flat Earth Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com

% This script is designed to setup a given number of text files that will
% contain the coefficients for N IIR filters. When switching between these
% filters in the desired order, the result will sweep from low to high to
% low frequency boosting.

% Full transfer function
% H(z) = 1+H_0/2 * (1- A_2(z))          
% Second order allpass filter: 
% A_2(z) = (?a_B + (d ? d*a_B)*z^-1 + z^-2) /
%               (1 + (d-d*a_B)*z^-1 + a_B*z^-2)

% Define system constants
clear;
fs = 48000; % sample rate


%% Global Variable Declaration
W_bits = 32;            % Word length
F_bits = 28;            % Fractional length
Fs     = 48000;
Ts     = 1/Fs;
t      = 0 : Ts : 2;    % Signal duration

%% HPF Filter Design
% This section designs a 512-order FIR filter with cutoff frequency of 140
% Hz. The filter coefficients are then represented using an unsigned
% fixed-point number system. 

hpFilt = designfilt('highpassfir', ...
                        'FilterOrder', 511, ...
                        'PassbandFrequency',200, ...
                        'StopbandFrequency', 140, ... 
                        'SampleRate', Fs, ...
                        'DesignMethod', 'equiripple');
hpFiltFi = fi(hpFilt.Coefficients, 1, W_bits, F_bits);

%% LPF Filter Design
% This section designs a 128-order FIR filter with cutoff frequency of 140
% Hz. The filter coefficients are then represented using an unsigned
% fixed-point number system.

lpFilt = designfilt('lowpassfir', ...                           % Response type
                       'FilterOrder',511, ...                   % Filter order
                       'PassbandFrequency',130, ...             % Frequency constraints
                       'StopbandFrequency',180, ...
                       'DesignMethod','ls', ...                 % Design method
                       'PassbandWeight',1, ...                  % Design method options
                       'StopbandWeight',2, ...
                       'SampleRate',Fs);                        % Sample rate
lpFiltFi = ufi(lpFilt.Coefficients, W_bits, F_bits);


%% Write files contaning filter data
addrW = ceil(log2(length(lpFiltFi(:))));
% Define address counting math
Fm_addr = fimath('RoundingMethod','Floor',...
    'OverflowAction','Wrap',...
    'ProductMode','SpecifyPrecision',...
    'ProductWordLength',addrW,...
    'ProductFractionLength',0,...
    'SumMode','SpecifyPrecision',...
    'SumWordLength',addrW,...
    'SumFractionLength',0);

% Define address setup variables
  % address width
b_kAddr = 0;% b_k starting address

W_bits = 32;    % Coefficient memory size 
F_bits = 28;    % Coefficient fractional size
%ts = 1/fs;

% Define center frequencies
%fLow = 293.66; fHigh = 1174.66; % D4 to D6
%fc = logspace(log10(fLow), log10(fHigh), N);    

lpFiltFi = lpFiltFi';
hpFiltFi = hpFiltFi';
save('FIRSetup.mat', 'lpFiltFi');

% Write out the files, containing data and address to write to.



%% set up strings and addresses for b_k memory files
% Lowpass 
write = fopen(sprintf('LPF_Coeff.txt'), 'w');
addr = fi(b_kAddr, 0, addrW, 0, Fm_addr);                      
lineFI = fi(lpFiltFi, 1, W_bits, F_bits);
for(j = 1:length(lpFiltFi))
    line = sprintf( [addr.hex ',' lineFI.hex(j,:) '\n']);
    fprintf(write, '%s', line);
    addr = addr+1;
end

fclose(write);


% Highpass 
write = fopen(sprintf('HPF_Coeff.txt'), 'w');
addr = fi(b_kAddr, 0, addrW, 0, Fm_addr);                      
lineFI = fi(hpFiltFi, 1, W_bits, F_bits);
for(j = 1:length(hpFiltFi))
    line = sprintf( [addr.hex ',' lineFI.hex(j,:) '\n']);
    fprintf(write, '%s', line);
    addr = addr+1;
end

fclose(write);




