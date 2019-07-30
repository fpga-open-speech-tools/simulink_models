

t = Avalon_Sink_Data.Time;
d = squeeze(Avalon_Sink_Data.Data);   % the Matlab function squeeze removes dimensions of length 1
c = squeeze(Avalon_Sink_Channel.Data);
v = squeeze(Avalon_Sink_Valid.Data);

left_index = 1;
right_index = 1;
for i=1:length(v)
   if v(i) == 1
        if c(i) == 0
            left_data(left_index) = d(i);
            left_time(left_index) = t(i);
            left_index = left_index + 1;
        end
        if c(i) == 1
            right_data(right_index) = d(i);
            right_time(right_index) = t(i);
            right_index = right_index + 1;
        end
   end
end


figure(1)
subplot(4,1,1)
plot(test_signal_left, 'g'); 
subplot(4,1,2)
plot(left_time, left_data, 'g'); 
subplot(4,1,3)
plot(test_signal_right, 'b'); 
subplot(4,1,4)
plot(right_time, right_data, 'b'); 



