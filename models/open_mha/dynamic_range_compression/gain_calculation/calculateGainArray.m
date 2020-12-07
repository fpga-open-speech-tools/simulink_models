function gainArray = calculateGainArray(mins, boost, maxes, inputdB)

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
  dBGainArray = zeros(size(dBArray));
  
  % Find the locations of the input that exceed the maximum value
  maxInds = dBArray > maxArray;
  
  % Set those indices to the max
  dBGainArray(maxInds) = maxArray(maxInds) - dBArray(maxInds);

  % Find all indices below the minimum plus the "boost"
  minInds = dBArray < minArray+boost;
  
  % Set those indices to the minimum plus the boost
  dBGainArray(minInds) = minArray(minInds) - dBArray(minInds) + boost;
  
  % Reshape the NxM array into a row vector
  gainArray = reshape(10.^(dBGainArray/10),1,nFreq*nDivs);
end