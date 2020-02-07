
%% Before Running
x_in = 0:0.001:3;
ts = 1/48000;
tt = 0:length(x_in)-1;
tt = tt.*ts;

simin_Data_In = [tt',x_in'];
simin_Table_Wr_Data = [tt',x_in'];
simin_Table_Wr_Addr = [tt',x_in'];
simin_Wr_En = [tt',x_in'];
stop_time = tt(end);

maxInput = 1;
M_bits = 4; N_bits = 4;
d = ceil(log2(maxInput));
X_in = zeros(1, 2^(M_bits+N_bits));
addr = 1;

for NShifts = 2^N_bits-1:-1:0
    for M = 0:2^M_bits - 1
        X_in(addr) = 2^(d-NShifts) + M*2^(d-NShifts-M_bits);
        addr = addr+1;
    end
end

Y_out = tanh(X_in); 

Table_Wr_Data = [zeros(1,length(x_in)), Y_out, zeros(1,length(x_in))];
tt = 0:length(Table_Wr_Data)-1;
tt = tt.*ts;
Data_In = [x_in, zeros(1,length(Y_out)), x_in];
Table_Wr_Addr = [zeros(1,length(x_in)), 0:length(Y_out)-1, zeros(1,length(x_in))];
Wr_En = [zeros(1,length(x_in)), ones(1,length(Y_out)), zeros(1,length(x_in))];

simin_Data_In = [tt',Data_In'];
simin_Table_Wr_Data = [tt',Table_Wr_Data'];
simin_Table_Wr_Addr = [tt',Table_Wr_Addr'];
simin_Wr_En = [tt',Wr_En'];
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