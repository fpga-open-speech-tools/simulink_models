function audioOutput = createEcho(data,wetDryRatio,feedbackGain,echoDuration)
  % This function is based off the block diagram for the Delay-Based Audio Effects example from Mathworks

  % Initialize the echo array
  echoSignal = zeros(size(data));
      
  % Loop through the array and apply the feedback
  for ii = echoDuration+2:length(data)
    
    echoSignal(ii) = feedbackGain.*echoSignal(ii-echoDuration-1) + data(ii-echoDuration);
    
    % Ensure the audio is bounded between -1 and 1
    if echoSignal(ii) > 1
      echoSignal(ii) = 1;
    elseif echoSignal(ii) < -1
      echoSignal(ii) = -1;
    end
    
  end
  
  % Combine the original audio (dry) and the echo signal (wet)
  audioOutput = (1-wetDryRatio)*data + wetDryRatio*echoSignal;
  
end