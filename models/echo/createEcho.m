function audioOutput = createEcho(data,wetDryRatio,feedbackGain,echoDuration)
  % This function is based off the block diagram for the Delay-Based Audio Effects example from Mathworks

  echoSignal = zeros(size(data));
      
  % Loop through the array
  for ii = echoDuration+1:length(data)-1
    
    echoSignal(ii+1) = feedbackGain.*echoSignal(ii-echoDuration) + data(ii-echoDuration+1);
    
    if echoSignal(ii) > 1
      echoSignal(ii) = 1;
    elseif echoSignal(ii) < -1
      echoSignal(ii) = -1;
    end
  end
  audioOutput = (1-wetDryRatio)*data + wetDryRatio*echoSignal;
  
  audioOutput(audioOutput > 1) = 1;
  audioOutput(audioOutput < -1) = -1;
end