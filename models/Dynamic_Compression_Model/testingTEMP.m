x_in = 0:0.001:1;

tt = 0:1000;
tt = tt./48000;

simin = [tt',x_in'];
stop_time = tt(end);

address(:,1) = simout{2}.Values.data(:);
address(2:1001,1) = address(1:1000,1);
address(:,1) = abs(31-address(:,1));
address_r = address(:,1).*2+address(:,2);
figure(); semilogx(tt,address_r);
title("Read address over time");
xlabel("Time");
ylabel("Read Address");