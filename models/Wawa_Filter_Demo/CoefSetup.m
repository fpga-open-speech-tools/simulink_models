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
G = 10;     % dB gain of center frequency
fb = 100;   % bandwidth of boosted or cut frequencies
N = 10;     % Number of filters to define

% Define address setup variables
addrW = 4;  % address width
b_kAddr = 0;% b_k starting address
a_kAddr = 4;% a_k starting address

% Define address counting math
Fm_addr = fimath('RoundingMethod','Floor',...
    'OverflowAction','Wrap',...
    'ProductMode','SpecifyPrecision',...
    'ProductWordLength',addrW,...
    'ProductFractionLength',0,...
    'SumMode','SpecifyPrecision',...
    'SumWordLength',addrW,...
    'SumFractionLength',0);

W_bits = 32;    % Coefficient memory size 
F_bits = 28;    % Coefficient fractional size
%ts = 1/fs;

% Define center frequencies
fLow = 293.66; fHigh = 1174.66; % D4 to D6
fc = logspace(log10(fLow), log10(fHigh), N);    
d = -cos(2*pi*fc/fs);

% Define H_0 to apply center frequency gain 
V_0 = 10^(G/20);
H_0 = V_0 - 1;

% Define alpha, the boost or cut coefficient
if(G <= 0)  % a is cutting 
    alpha = (tan(2*pi*fb/fs)-V_0)/(tan(2*pi*fb/fs)+V_0); % Need to double check this, reference seems to have a typo
else        % a is boosting
    alpha = (tan(2*pi*fb/fs)-1)/(tan(2*pi*fb/fs)+1);
end

% Define IIR coefficient set. Note a_k(0) is 0, not 1. This is for
% implementation reasons. 
b_k = [-alpha*ones(1,N);    d*(1-alpha);   ones(1,N)];
a_k = [zeros(1,N);          -d*(1-alpha);  alpha*ones(1,N)];


% Write out the files, containing data and address to write to.
for(i = 1:N)
    write = fopen(sprintf('PeakCoeff_%d.txt', i), 'w');
    
    % set up strings and addresses for b_k memory
    addr = fi(b_kAddr, 0, addrW, 0, Fm_addr);                      
    lineFI = fi(b_k(:,i), 1, W_bits, F_bits);
    for(j = 1:3)
        line = sprintf( [addr.hex ',' lineFI.hex(j,:) '\n']);
        fprintf(write, '%s', line);
        addr = addr+1;
    end
    
    % set up strings and addresses for a_k memory
    addr = fi(a_kAddr, 0, addrW, 0, Fm_addr);
    lineFI = fi(a_k(:,i), 1, W_bits, F_bits);
    for(j = 1:3)
        line = sprintf( [addr.hex ',' lineFI.hex(j,:) '\n']);
        fprintf(write, '%s', line);
        addr = addr+1;
    end
    
    fclose(write);
end
