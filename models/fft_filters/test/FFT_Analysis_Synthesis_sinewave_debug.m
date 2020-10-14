

close all

m1 = debug(4700:4900,1);
m2 = debug(4700:4900,2);
v  = debug(4700:4900,3);
v  = v*max(m1(:));
m3 = debug(4700:4900,4);



plot(m1)
hold on
plot(m2)
plot(m3)
plot(v)

