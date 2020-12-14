function gainArray = calculateGainArray(mins, maxes, inputdB)

  % Reshape the arrays as needed
  if size(mins,2) == 1
    mins = mins';
  end

  if size(maxes,2) == 1
    maxes = maxes';
  end

  if size(inputdB,2) == 1
    inputdB = inputdB';
  end

  % Determine the number of frequency bins and the number of divisions within those bins
  nFreq = size(mins,2);
  nDivs = size(inputdB,2);

  % Define the min, max, and dB arrays
  minArray    = repmat(mins,nDivs,1);
  maxArray    = repmat(maxes,nDivs,1);
  dBArray     = repmat(inputdB',1,nFreq);
  divArray= repmat([0:nDivs-1]',1,nFreq);
  
  % Calculate the gain to remap the input to the desired range
  dBGainArray = divArray.*(maxArray-minArray)/(nDivs-1) + minArray - dBArray;
  
  % Reshape the NxM array into a row vector
  gainArray = reshape(10.^(dBGainArray/10),1,nFreq*nDivs);
end