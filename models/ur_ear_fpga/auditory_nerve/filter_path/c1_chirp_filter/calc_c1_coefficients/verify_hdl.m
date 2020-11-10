load rsigma.mat
mex c1_coefficients_source.c complex.c
rsigma = double(squeeze(rsigma_sim_in.Data));
rsigma = rsigma(9504:10504,1);

p = zeros(11,1);
C1coeffs_sim = zeros(length(rsigma), half_order_pole, 6); % Declar empty coefficient array
C1coeffs_hdl = zeros(length(rsigma), 3, 6); % Declar empty coefficient array

% Figure 1 Data Arrays
rzero_out    = zeros(1,length(rsigma));
rzero_calc   = zeros(1,length(rsigma));
rzero_temp   = zeros(1,length(rsigma));
temp_1_out   = zeros(1,length(rsigma));
temp_2_out   = zeros(1,length(rsigma));
temp_3_out   = zeros(1,length(rsigma));
temp_4_out   = zeros(1,length(rsigma));
temp_5_out   = zeros(1,length(rsigma));
temp_calc    = zeros(length(rsigma),half_order_pole);
phase_calc   = zeros(length(rsigma),half_order_pole);
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
    fs_bilinear_calc(j) = fs_bilinear;
    [rzero_out(1,j), temp_1_out(1,j), temp_2_out(1,j), temp_3_out(1,j), temp_4_out(1,j), temp_5_out(1,j), fs_bilinear_out(1,j),...
         c1_i1_coef1_out(1,j), c1_i1_coef2_out(1,j), c1_i1_coef3_out(1,j), c1_i1_coef5_out(1,j), c1_i1_coef6_out(1,j),...
         c1_i2_coef1_out(1,j), c1_i2_coef2_out(1,j), c1_i2_coef3_out(1,j), c1_i2_coef5_out(1,j), c1_i2_coef6_out(1,j),...
         c1_i3_coef1_out(1,j), c1_i3_coef2_out(1,j), c1_i3_coef3_out(1,j), c1_i3_coef5_out(1,j), c1_i3_coef6_out(1,j),...
         c1_i4_coef1_out(1,j), c1_i4_coef2_out(1,j), c1_i4_coef3_out(1,j), c1_i4_coef5_out(1,j), c1_i4_coef6_out(1,j),...
         c1_i5_coef1_out(1,j), c1_i5_coef2_out(1,j), c1_i5_coef3_out(1,j), c1_i5_coef5_out(1,j), c1_i5_coef6_out(1,j),...
         ] = c1_coefficients_source(tdres, cf, j-1, taumax, single(rsigma(j)));

    p(1) = (-sigma0-rsigma(j)) + 1i*ipw;                                    % Line 524 and 528
    p(5) = (real(p(1)) - rpa) + (imag(p(1))-ipb) * 1i;                      % Line 530
    p(3) = (real(p(1)) + real(p(5)))/2 + 1i*((imag(p(1)) + imag(p(5)))/2);  % Line 532
    p(2) = conj(p(1)); p(4) = conj(p(3)); p(6) = conj(p(5));                % Line 534
    p(7) = p(1); p(8) = p(2); p(9) = p(5); p(10) = p(6);                    % Line 536

    phase = phase_init;
    % Calculate phase & zero locations
    for i = 1:half_order_pole                                               % Lines 539-544
        preal = real(p(2*i-1));                                             % Line 541
        pimg  = imag(p(2*i-1));                                             % Line 542
        phase = phase - atan((CF-pimg)/(-preal))-atan((CF+pimg)/(-preal));  % Line 543  
%         phase = - atan((CF-pimg)/(-preal))-atan((CF+pimg)/(-preal));  % Line 543  
        phase_calc(j,i) = phase;
    end
    
    rzero_temp(1,j) = tan((C1initphase-phase)/order_of_zero);
    rzero = -CF/tan((C1initphase-phase)/order_of_zero);	                    % Line 546 
    rzero_calc(1,j) = rzero;
    
    % Calculate biquad filter coefficients
    for i = 1:half_order_pole
        preal = real(p(2*i-1));                                             % Line 561
        pimg = imag(p(2*i-1));                                              % Line 562
        
        temp  = (fs_bilinear-preal)^2+ pimg^2;                              % Line 564
        temp_calc(j,i) = temp;
    
        C1coeffs_sim(j,i,1) = (fs_bilinear-rzero)/temp;
        C1coeffs_sim(j,i,2) = -(2*rzero)/temp;
        C1coeffs_sim(j,i,3) = (-(fs_bilinear+rzero))/temp;
        C1coeffs_sim(j,i,4) = 1;
        C1coeffs_sim(j,i,5) = (2*(fs_bilinear*fs_bilinear-preal*preal-pimg*pimg))/temp;
        C1coeffs_sim(j,i,6) = (-((fs_bilinear+preal)*(fs_bilinear+preal)+ pimg*pimg))/temp;
    end
end

%% Simulate the Generated HDL
c1_coeff_calc_inhdl = hdlcosim_dataplane;

% Data Plane Inputs
clk_enable              = fi(1,0,1,0);
avalon_sink_valid       = fi(1,0,1,0);
avalon_sink_channel     = fi(1,0,1,0);
avalon_sink_error       = fi(1,0,2,0);
avalon_sink_data        = fi(1,1,32,28);
register_control_enable = fi(1,0,1,0);

clock_cycles = length(rsigma) * 1024;
j = 1;
for i = 1:clock_cycles
    if(mod(i,1024) == 1)
        rsigma_in_hdl  = rsigma(j);
        j = j + 1;
    end
    [ce_out, avalon_source_valid, avalon_source_data, avalon_source_channel, avalon_source_error, ...
        p1_coef_1_hdl_out, p1_coef_2_hdl_out, p1_coef_3_hdl_out, p1_coef_5_hdl_out, p1_coef_6_hdl_out, ...
        p3_coef_1_hdl_out, p3_coef_2_hdl_out, p3_coef_3_hdl_out, p3_coef_5_hdl_out, p3_coef_6_hdl_out, ...
        p5_coef_1_hdl_out, p5_coef_2_hdl_out, p5_coef_3_hdl_out, p5_coef_5_hdl_out, p5_coef_6_hdl_out ...
        ] = step(c1_coeff_calc_inhdl, clk_enable, avalon_sink_valid, avalon_sink_data, avalon_sink_channel, avalon_sink_error, register_control_enable, rsigma_in_hdl);
    if(mod(i,1024) == 1)
        C1coeffs_hdl(j,1,1) = p1_coef_1_hdl_out;
        C1coeffs_hdl(j,1,2) = p1_coef_2_hdl_out;
        C1coeffs_hdl(j,1,3) = p1_coef_3_hdl_out;
        C1coeffs_hdl(j,1,5) = p1_coef_5_hdl_out;
        C1coeffs_hdl(j,1,6) = p1_coef_6_hdl_out;
        C1coeffs_hdl(j,2,1) = p3_coef_1_hdl_out;
        C1coeffs_hdl(j,2,2) = p3_coef_2_hdl_out;
        C1coeffs_hdl(j,2,3) = p3_coef_3_hdl_out;
        C1coeffs_hdl(j,2,5) = p3_coef_5_hdl_out;
        C1coeffs_hdl(j,2,6) = p3_coef_6_hdl_out;
        C1coeffs_hdl(j,3,1) = p5_coef_1_hdl_out;
        C1coeffs_hdl(j,3,2) = p5_coef_2_hdl_out;
        C1coeffs_hdl(j,3,3) = p5_coef_3_hdl_out;
        C1coeffs_hdl(j,3,5) = p5_coef_5_hdl_out;
        C1coeffs_hdl(j,3,6) = p5_coef_6_hdl_out;
    end
end


%% Plot the Results - Coefficients for i=1
figure;
subplot(5,1,1)
plot(c1_i1_coef1_out)
hold on
plot(C1coeffs_sim(:,1,1))
hold on
plot(C1coeffs_hdl(:,1,1),'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 1 when i=1');

subplot(5,1,2)
plot(c1_i1_coef2_out)
hold on
plot(C1coeffs_sim(:,1,2))
hold on
plot(C1coeffs_hdl(:,1,2),'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 2 when i=1');

subplot(5,1,3)
plot(c1_i1_coef3_out)
hold on
plot(C1coeffs_sim(:,1,3))
hold on
plot(C1coeffs_hdl(:,1,3),'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 3 when i=1');

subplot(5,1,4)
plot(c1_i1_coef5_out)
hold on
plot(C1coeffs_sim(:,1,5)'.')
hold on
plot(C1coeffs_hdl(:,1,5),'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 5 when i=1');

subplot(5,1,5)
plot(c1_i1_coef6_out)
hold on
plot(C1coeffs_sim(:,1,6))
hold on
plot(C1coeffs_hdl(:,1,6),'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 6 when i=1');

%% Plot the Results - Coefficients for i=2
figure;
subplot(5,1,1)
plot(c1_i2_coef1_out)
hold on
plot(C1coeffs_sim(:,2,1))
hold on
plot(C1coeffs_hdl(:,2,1),'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 1 when i=2');

subplot(5,1,2)
plot(c1_i2_coef2_out)
hold on
plot(C1coeffs_sim(:,2,2))
hold on
plot(C1coeffs_hdl(:,2,2),'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 2 when i=2');

subplot(5,1,3)
plot(c1_i2_coef3_out)
hold on
plot(C1coeffs_sim(:,2,3))
hold on
plot(C1coeffs_hdl(:,2,3),'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 3 when i=2');

subplot(5,1,4)
plot(c1_i2_coef5_out)
hold on
plot(C1coeffs_sim(:,2,5))
hold on
plot(C1coeffs_hdl(:,2,5),'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 5 when i=2');

subplot(5,1,5)
plot(c1_i2_coef6_out)
hold on
plot(C1coeffs_sim(:,2,6))
hold on
plot(C1coeffs_hdl(:,2,6),'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 6 when i=2');

%% Plot the Results - Coefficients for i=3
figure;
subplot(5,1,1)
plot(c1_i3_coef1_out)
hold on
plot(C1coeffs_sim(:,3,1))
hold on
plot(C1coeffs_hdl(:,3,1),'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 1 when i=3');

subplot(5,1,2)
plot(c1_i3_coef2_out)
hold on
plot(C1coeffs_sim(:,3,2)'.')
hold on
plot(C1coeffs_hdl(:,3,2),'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 2 when i=3');

subplot(5,1,3)
plot(c1_i3_coef3_out)
hold on
plot(C1coeffs_sim(:,3,3))
hold on
plot(C1coeffs_hdl(:,3,3),'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 3 when i=3');

subplot(5,1,4)
plot(c1_i3_coef5_out)
hold on
plot(C1coeffs_sim(:,3,5))
hold on
plot(C1coeffs_hdl(:,3,5),'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 5 when i=3');

subplot(5,1,5)
plot(c1_i3_coef6_out)
hold on
plot(C1coeffs_sim(:,3,6)'.')
hold on
plot(C1coeffs_hdl(:,3,6),'--')
legend('C Source Code','MATLAB', 'Simulink')
title('C1 Coefficient 6 when i=3');
