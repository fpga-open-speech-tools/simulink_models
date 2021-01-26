function audioOutput = createEcho(data,wetDryRatio,feedbackGain,echoDuration)
  
  echoSignal = zeros(size(data));
  
  echoSignal((echoDuration+1):end) = feedbackGain*data(1:(end-echoDuration));
  
  audioOutput = wetDryRatio*data + (1-wetDryRatio)*echoSignal;

end