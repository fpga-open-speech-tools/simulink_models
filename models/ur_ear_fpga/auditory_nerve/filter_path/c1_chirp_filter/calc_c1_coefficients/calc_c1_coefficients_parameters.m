function [sigma0, ipw, ipb, rpa, pzero, order_of_zero, fs_bilinear, CF, phase_init, C1initphase, preal, pimag, order_of_pole] = calc_c1_coefficients_parameters(cf, tdres, taumax)
    TWOPI = 6.28318530717959;
    % Line Numbers from model_IHC_BEZ2018.c
    sigma0 = 1/taumax;                          % Line 464
    ipw    = 1.01 * cf * (TWOPI) - 50;           % Line 465
    ipb    = 0.2343 * (TWOPI) * cf - 1104;       % Line 466
    rpa    = 10^(log10(cf)*0.9 + 0.55)+ 2000;   % Line 467
    pzero  = 10^(log10(cf)*0.7+1.6)+500;        % Line 468
    order_of_pole    = 10;                      % Line 472
    half_order_pole  = order_of_pole/2;         % Line 473
    order_of_zero    = half_order_pole;         % Line 474

    fs_bilinear = TWOPI*cf/tan(TWOPI*cf*tdres/2); % Line 476
    rzero       = -pzero;                         % Line 477
    CF          = TWOPI*cf;                       % Line 478
    phase_init  = 0;                              % Line 538                    

    preal = zeros(11,1);
    pimag = zeros(11,1);

    % Initial Conditions - If n == 0: Line 480
    % Complex Conjugate of a+bi = a-bi
    preal(1)  = -sigma0;                      % Line 482
    preal(5)  = preal(1) - rpa;               % Line 486
    preal(3)  = (preal(1) + preal(5)) * 0.5;  % Line 488
    preal(7)  = preal(1);                     % Line 492
    preal(9)  = preal(5);                     % Line 492
    preal(2)  = preal(1);                     % Line 490
    preal(4)  = preal(3);                     % Line 490
    preal(6)  = preal(5);                     % Line 490
    preal(8)  = preal(2);                     % Line 492
    preal(10) = preal(6);                     % Line 492

    pimag(1)  = ipw;                          % Line 484
    pimag(5)  = pimag(1) - ipb;               % Line 486
    pimag(3)  = (pimag(1) + pimag(5)) * 0.5;  % Line 488
    pimag(7)  = pimag(1);                     % Line 492
    pimag(9)  = pimag(5);                     % Line 492
    pimag(2)  = -pimag(1);                    % Line 492
    pimag(4)  = -pimag(3);                    % Line 490
    pimag(6)  = -pimag(5);                    % Line 490
    pimag(8)  = pimag(2);                     % Line 492
    pimag(10) = pimag(6);                     % Line 492

    % Calculate initial phase
    C1initphase = 0.0;                        % Line 494
    for i = 1:half_order_pole                 % Lines 495-500
        p_real = preal(2*i-1);                % Line 497
        p_img  = pimag(2*i-1);                % Line 498
        C1initphase = C1initphase + atan(CF/(-rzero))-atan((CF-p_img)/(-p_real))-atan((CF+p_img)/(-p_real)); % Line 499
    end
end