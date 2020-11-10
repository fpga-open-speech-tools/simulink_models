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
load rsigma.mat
mex c1_coefficients_source.c complex.c
rsigma = double(squeeze(rsigma_sim_in.Data));

p = zeros(11,1);
C1coeffs    = zeros(length(rsigma), order_of_zero, 6); % Declar empty coefficient array
rsigma_plot = zeros(1,length(rsigma));

% Figure 1 Data Arrays
rzero_out    = zeros(1,length(rsigma));
rzero_calc   = zeros(1,length(rsigma));
rzero_temp   = zeros(1,length(rsigma));
temp_1_out   = zeros(1,length(rsigma));
temp_2_out   = zeros(1,length(rsigma));
temp_3_out   = zeros(1,length(rsigma));
temp_4_out   = zeros(1,length(rsigma));
temp_5_out   = zeros(1,length(rsigma));
temp_calc    = zeros(length(rsigma),order_of_zero);
phase_calc   = zeros(length(rsigma),order_of_zero);
fs_bilinear_out   = zeros(1,length(rsigma));
fs_bilinear_calc  = zeros(1,length(rsigma));
% Figure 2 Data Arrays
c1_i1_coef1_out = zeros(1,length(rsigma));
c1_i1_coef2_out = zeros(1,length(rsigma));
c1_i1_coef3_out = zeros(1,length(rsigma));
c1_i1_coef5_out = zeros(1,length(rsigma));
c1_i1_coef6_out = zeros(1,length(rsigma));
% Figure 3 Data Arrays
c1_i2_coef1_out = zeros(1,length(rsigma));
c1_i2_coef2_out = zeros(1,length(rsigma));
c1_i2_coef3_out = zeros(1,length(rsigma));
c1_i2_coef5_out = zeros(1,length(rsigma));
c1_i2_coef6_out = zeros(1,length(rsigma));
% Figure 4 Data Arrays
c1_i3_coef1_out = zeros(1,length(rsigma));
c1_i3_coef2_out = zeros(1,length(rsigma));
c1_i3_coef3_out = zeros(1,length(rsigma));
c1_i3_coef5_out = zeros(1,length(rsigma));
c1_i3_coef6_out = zeros(1,length(rsigma));
% Figure 5 Data Arrays
c1_i4_coef1_out = zeros(1,length(rsigma));
c1_i4_coef2_out = zeros(1,length(rsigma));
c1_i4_coef3_out = zeros(1,length(rsigma));
c1_i4_coef5_out = zeros(1,length(rsigma));
c1_i4_coef6_out = zeros(1,length(rsigma));
% Figure 6 Data Arrays
c1_i5_coef1_out = zeros(1,length(rsigma));
c1_i5_coef2_out = zeros(1,length(rsigma));
c1_i5_coef3_out = zeros(1,length(rsigma));
c1_i5_coef5_out = zeros(1,length(rsigma));
c1_i5_coef6_out = zeros(1,length(rsigma));

%% Calculate the Results
for j = 1:length(rsigma) 
    rsigma_plot(j) = rsigma(j);
    fs_bilinear_calc(j) = fs_bilinear;
    [rzero_out(1,j), temp_1_out(1,j), temp_2_out(1,j), temp_3_out(1,j), temp_4_out(1,j), temp_5_out(1,j), fs_bilinear_out(1,j),...
         c1_i1_coef1_out(1,j), c1_i1_coef2_out(1,j), c1_i1_coef3_out(1,j), c1_i1_coef5_out(1,j), c1_i1_coef6_out(1,j),...
         c1_i2_coef1_out(1,j), c1_i2_coef2_out(1,j), c1_i2_coef3_out(1,j), c1_i2_coef5_out(1,j), c1_i2_coef6_out(1,j),...
         c1_i3_coef1_out(1,j), c1_i3_coef2_out(1,j), c1_i3_coef3_out(1,j), c1_i3_coef5_out(1,j), c1_i3_coef6_out(1,j),...
         c1_i4_coef1_out(1,j), c1_i4_coef2_out(1,j), c1_i4_coef3_out(1,j), c1_i4_coef5_out(1,j), c1_i4_coef6_out(1,j),...
         c1_i5_coef1_out(1,j), c1_i5_coef2_out(1,j), c1_i5_coef3_out(1,j), c1_i5_coef5_out(1,j), c1_i5_coef6_out(1,j),...
         ] = c1_coefficients_source(tdres, cf, j-1, taumax, rsigma_plot(j));

    p(1) = (-sigma0-rsigma(j)) + 1i*ipw;                                    % Line 524 and 528
    p(5) = (real(p(1)) - rpa) + (imag(p(1))-ipb) * 1i;                      % Line 530
    p(3) = (real(p(1)) + real(p(5)))/2 + 1i*((imag(p(1)) + imag(p(5)))/2);  % Line 532
    p(2) = conj(p(1)); p(4) = conj(p(3)); p(6) = conj(p(5));                % Line 534
    p(7) = p(1); p(8) = p(2); p(9) = p(5); p(10) = p(6);                    % Line 536
    
    phase = phase_init;
    % Calculate phase & zero locations
    for i = 1:order_of_zero                                                 % Lines 539-544
        preal = real(p(2*i-1));                                             % Line 541
        pimg  = imag(p(2*i-1));                                             % Line 542
        phase = phase - atan((CF-pimg)/(-preal))-atan((CF+pimg)/(-preal));  % Line 543   
        phase_calc(j,i) = phase;
    end
    
    rzero_temp(1,j) = tan((C1initphase-phase)/order_of_zero);
    rzero = -CF/tan((C1initphase-phase)/order_of_zero);	                    % Line 546 
    rzero_calc(1,j) = rzero;
    
    % Calculate biquad filter coefficients
    for i = 1:order_of_zero
        preal = real(p(2*i-1));                                             % Line 561
        pimg = imag(p(2*i-1));                                              % Line 562
        
        temp  = (fs_bilinear-preal)^2+ pimg^2;                              % Line 564
        temp_calc(j,i) = temp;
    
        C1coeffs(j,i,1) = (fs_bilinear-rzero)/temp;
        C1coeffs(j,i,2) = -(2*rzero)/temp;
        C1coeffs(j,i,3) = (-(fs_bilinear+rzero))/temp;
        C1coeffs(j,i,4) = 1;
        C1coeffs(j,i,5) = (2*(fs_bilinear*fs_bilinear-preal*preal-pimg*pimg))/temp;
        C1coeffs(j,i,6) = (-((fs_bilinear+preal)*(fs_bilinear+preal)+ pimg*pimg))/temp;
    end
end

%% Plot the steps of the Phase Computation
figure
subplot(5,1,1)
plot(phase_calc(:,1))
hold on
plot(phase_i1_simulink,'--')
legend('MATLAB', 'Simulink')
title('Phase when i=1');

subplot(5,1,2)
plot(phase_calc(:,2))
hold on
plot(phase_i2_simulink,'--')
legend('MATLAB', 'Simulink')
title('Phase when i=2');

subplot(5,1,3)
plot(phase_calc(:,3))
hold on
plot(phase_i3_simulink,'--')
legend('MATLAB', 'Simulink')
title('Phase when i=3');

subplot(5,1,4)
plot(phase_calc(:,4))
hold on
plot(phase_i4_simulink,'--')
legend('MATLAB', 'Simulink')
title('Phase when i=4');

subplot(5,1,5)
plot(phase_calc(:,5))
hold on
plot(phase_i5_simulink,'--')
legend('MATLAB', 'Simulink')
title('Phase when i=5');

%% Plot the Results - FS Bilinear, R Zero, Temp for a given value of i
figure
subplot(7,1,1)
plot(fs_bilinear_out)
hold on
plot(fs_bilinear_calc,'--')
legend('C Source Code','MATLAB')
title('FS Bilinear');

subplot(7,1,2)
plot(rzero_out)
hold on
plot(rzero_calc)
hold on
plot(rzero_sim, '--')
legend('C Source Code','MATLAB', 'Simulink')
title('R Zero')

subplot(7,1,3)
plot(temp_1_out)
hold on
plot(temp_calc(:,1))
hold on
plot(temp_p1,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('Temp: i = 1')

subplot(7,1,4)
plot(temp_2_out)
hold on
plot(temp_calc(:,2))
hold on
plot(temp_p3,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('Temp: i = 2')

subplot(7,1,5)
plot(temp_3_out)
hold on
plot(temp_calc(:,3))
hold on
plot(temp_p5,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('Temp: i = 3')

subplot(7,1,6)
plot(temp_4_out)
hold on
plot(temp_calc(:,4))
hold on
plot(temp_p1,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('Temp: i = 4')

subplot(7,1,7)
plot(temp_5_out)
hold on
plot(temp_calc(:,5))
hold on
plot(temp_p5,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('Temp: i = 5')

%% Plot the Results - Coefficients for i=1
figure;
subplot(5,1,1)
plot(c1_i1_coef1_out)
hold on
plot(C1coeffs(:,1,1))
hold on
plot(p1_coef_1,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 1 when i=1');

subplot(5,1,2)
plot(c1_i1_coef2_out)
hold on
plot(C1coeffs(:,1,2))
hold on
plot(p1_coef_2,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 2 when i=1');

subplot(5,1,3)
plot(c1_i1_coef3_out)
hold on
plot(C1coeffs(:,1,3))
hold on
plot(p1_coef_3,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 3 when i=1');

subplot(5,1,4)
plot(c1_i1_coef5_out)
hold on
plot(C1coeffs(:,1,5)'.')
hold on
plot(p1_coef_5,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 5 when i=1');

subplot(5,1,5)
plot(c1_i1_coef6_out)
hold on
plot(C1coeffs(:,1,6))
hold on
plot(p1_coef_6,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 6 when i=1');

%% Plot the Results - Coefficients for i=2
figure;
subplot(5,1,1)
plot(c1_i2_coef1_out)
hold on
plot(C1coeffs(:,2,1))
hold on
plot(p3_coef_1,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 1 when i=2');

subplot(5,1,2)
plot(c1_i2_coef2_out)
hold on
plot(C1coeffs(:,2,2))
hold on
plot(p3_coef_2,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 2 when i=2');

subplot(5,1,3)
plot(c1_i2_coef3_out)
hold on
plot(C1coeffs(:,2,3))
hold on
plot(p3_coef_3,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 3 when i=2');

subplot(5,1,4)
plot(c1_i2_coef5_out)
hold on
plot(C1coeffs(:,2,5))
hold on
plot(p3_coef_5,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 5 when i=2');

subplot(5,1,5)
plot(c1_i2_coef6_out)
hold on
plot(C1coeffs(:,2,6))
hold on
plot(p3_coef_6,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 6 when i=2');

%% Plot the Results - Coefficients for i=3
figure;
subplot(5,1,1)
plot(c1_i3_coef1_out)
hold on
plot(C1coeffs(:,3,1))
hold on
plot(p5_coef_1,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 1 when i=3');

subplot(5,1,2)
plot(c1_i3_coef2_out)
hold on
plot(C1coeffs(:,3,2)'.')
hold on
plot(p5_coef_2,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 2 when i=3');

subplot(5,1,3)
plot(c1_i3_coef3_out)
hold on
plot(C1coeffs(:,3,3))
hold on
plot(p5_coef_3,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 3 when i=3');

subplot(5,1,4)
plot(c1_i3_coef5_out)
hold on
plot(C1coeffs(:,3,5))
hold on
plot(p5_coef_5,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 5 when i=3');

subplot(5,1,5)
plot(c1_i3_coef6_out)
hold on
plot(C1coeffs(:,3,6)'.')
hold on
plot(p5_coef_6,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 6 when i=3');

%% Plot the Results - Coefficients for i=4
figure;
subplot(5,1,1)
plot(c1_i4_coef1_out)
hold on
plot(C1coeffs(:,4,1))
hold on
plot(p1_coef_1,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 1 when i=4');

subplot(5,1,2)
plot(c1_i4_coef2_out)
hold on
plot(C1coeffs(:,4,2))
hold on
plot(p1_coef_2,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 2 when i=4');

subplot(5,1,3)
plot(c1_i4_coef3_out)
hold on
plot(C1coeffs(:,4,3))
hold on
plot(p1_coef_3,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 3 when i=4');

subplot(5,1,4)
plot(c1_i4_coef5_out)
hold on
plot(C1coeffs(:,4,5))
hold on
plot(p1_coef_5,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 5 when i=4');

subplot(5,1,5)
plot(c1_i4_coef6_out)
hold on
plot(C1coeffs(:,4,6))
hold on
plot(p1_coef_6,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 6 when i=4');

%% Plot the Results - Coefficients for i=5
figure;
subplot(5,1,1)
plot(c1_i5_coef1_out)
hold on
plot(C1coeffs(:,5,1))
hold on
plot(p5_coef_1,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 1 when i=5');

subplot(5,1,2)
plot(c1_i5_coef2_out)
hold on
plot(C1coeffs(:,5,2)'.')
hold on
plot(p5_coef_2,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 2 when i=5');

subplot(5,1,3)
plot(c1_i5_coef3_out)
hold on
plot(C1coeffs(:,5,3)'.')
hold on
plot(p5_coef_3,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 3 when i=5');

subplot(5,1,4)
plot(c1_i5_coef5_out)
hold on
plot(C1coeffs(:,5,5)'.')
hold on
plot(p5_coef_5,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 5 when i=5');

subplot(5,1,5)
plot(c1_i5_coef6_out)
hold on
plot(C1coeffs(:,5,6)'.')
hold on
plot(p5_coef_6,'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 6 when i=5');

