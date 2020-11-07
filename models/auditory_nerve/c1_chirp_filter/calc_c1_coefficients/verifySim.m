% mp = sm_stop_verify(mp)
%
% Matlab function that verifies the model output 

% Inputs:
%   mp, which is the model data structure that holds the model parameters
%
% Outputs:
%   mp, the model data structure that now contains the left/right channel
%   data, which is in the following format:
%          mp.left_data_out         - The processed left channel data
%          mp.left_time_out         - time of left channel data
%          mp.right_data_out        - The processed right channel data
%          mp.right_time_out        - time of right channel data
%
% Copyright 2019 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Connor Dack
% Audio Logic
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

close all;
%% Calculate the Coefficients
rsigma = double(squeeze(rsigma_sim_in.Data));

p = zeros(11,1);
C1coeffs = zeros(length(rsigma), 5, 6); % Declar empty coefficient array
temp_calc = zeros(length(rsigma), 5);
phase_calc = zeros(length(rsigma), 5);
rzero_calc = zeros(length(rsigma),1);
p3_calc = zeros(length(rsigma),1);
p5_calc = zeros(length(rsigma),1);

for j = 1:length(rsigma) 
    p(1) = (-sigma0-rsigma(j)) + 1i*ipw;                                    % Line 524 and 528
    p(5) = (real(p(1)) - rpa) + (imag(p(1))-ipb) * 1i;                      % Line 530
    p(3) = (real(p(1)) + real(p(5)))/2 + 1i*((imag(p(1)) + imag(p(5)))/2);  % Line 532
    p(2) = conj(p(1)); p(4) = conj(p(3)); p(6) = conj(p(5));                % Line 534
    p(7) = p(1); p(8) = p(2); p(9) = p(5); p(10) = p(6);                    % Line 536

    % Calculate phase & zero locations
    for i = 1:half_order_pole                                               % Lines 539-544
        preal = real(p(2*i-1));                                             % Line 541
        pimg  = imag(p(2*i-1));                                             % Line 542
        phase = phase_init - atan((CF-pimg)/(-preal))-atan((CF+pimg)/(-preal));  % Line 543        
%         phase_calc(j,i) = atan((CF-pimg)/(-preal))-atan((CF+pimg)/(-preal));      
        phase_calc(j,i) = phase;
    end
    
    rzero = -CF/tan((C1initphase-phase)/order_of_zero);	                    % Line 546 
    rzero_calc(j,1) = rzero;
    
    % Calculate biquad filter coefficients
    for i = 1:half_order_pole
        preal = real(p(2*i-1));                                             % Line 561
        pimg = imag(p(2*i-1));                                              % Line 562
        
        temp  = (fs_bilinear-preal)^2+ pimg^2;                              % Line 564
        temp_calc(j,i) = temp;
        
        C1coeffs(j,i,1) = (fs_bilinear-rzero)/temp;
        C1coeffs(j,i,2) = -(2*rzero)/temp;
        C1coeffs(j,i,3) = (-(fs_bilinear+rzero))/temp;
        C1coeffs(j,i,4) = 1;
        C1coeffs(j,i,5) = -(2*(fs_bilinear*fs_bilinear-preal*preal-pimg*pimg))/temp;
        C1coeffs(j,i,6) = -(-((fs_bilinear+preal)*(fs_bilinear+preal)+pimg*pimg))/temp;
    end
end

%% Plot the Results
figure
subplot(3,1,1)
plot(rsigma)
title('R Sigma In')

subplot(3,1,2)
plot(phase_calc(:,1))
hold on
plot(phase_init_minus_phase_calc_i1,'--')
legend('Phase Init - PC_i1', 'Simulink')
title('Phase Init - Phase Calc i=1')

subplot(3,1,3)
plot(rzero_calc)
hold on
plot(rzero_sim,'--')
legend('MATLAB','Simulink')
title('R Zero')
