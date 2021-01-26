function audioOutput = createEcho(data,wetDryRatio,feedbackGain,echoDuration)
  % This function is based off the block diagram for the Delay-Based Audio Effects example from Mathworks

  data = data';
  echoSignal = data;
      
  % Loop through the array
  for ii = echoDuration+1:length(data)-1
    
    echoSignal(ii+1) = feedbackGain.*echoSignal(ii-echoDuration) + data(ii+1);
    
    if echoSignal(ii) > 1
      echoSignal(ii) = 1;
    elseif echoSignal(ii) < -1
      echoSignal(ii) = -1;
    end
  end
  audioOutput = wetDryRatio*data + (1-wetDryRatio)*echoSignal;
  
  audioOutput(audioOutput > 1) = 1;
  audioOutput(audioOutput < -1) = -1;
end