
%% Before Running
x_in = 0:0.001:3;

tt = 0:length(x_in)-1;
tt = tt./48000;

simin_Data_In = [tt',x_in'];
simin_Table_Wr_Data = [tt',x_in'];
simin_Table_Wr_Addr = [tt',x_in'];
simin_Wr_En = [tt',x_in'];
stop_time = tt(end);



%% After Running

output = out.simout.Data(:);
outputIdeal = sqrt(x_in);
address = addr.Data(:);
%address(2:1001,1) = address(1:1000,1);
%address(:,1) = abs(31-address(:,1));
%address_r = address(:,1).*2+address(:,2);
address(1:3000) = address(2:3001);
figure(3); plot(x_in,address);
title("Read addresses as a function of input (Corrected)");
xlabel("Input");
ylabel("Read Address");

output(1:2998) = output(4:3001);
figure(2); plot(x_in,output, x_in,outputIdeal);
title("Output Data over Input, sqrt Function (Corrected)");
xlabel("Input");
ylabel("Read Address");
legend("Table Output", "Ideal Output");

%allowed_in = (x_in <= 1) && (x_in >= 2^-15);
above = x_in >= 2^-15;
below = x_in <= 1;
allowed_in = above & below;

valid_addr = address(2:1001);
valid_out = output(2:1001);
valid_out_ideal = outputIdeal(2:1001);
valid_x_in = x_in(2:1001);

err = (valid_out_ideal - valid_out')./valid_out_ideal;
max_err = max(err);
figure(4); semilogx(valid_x_in, 100*err);
title("Output Error as a function of Input");
xlabel("Input");
ylabel("Output Error %");