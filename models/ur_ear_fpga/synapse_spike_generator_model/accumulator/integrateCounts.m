function [counts, valid] = integrateCounts(integrationTime,spcountRedock1,spcountRedock2,spcountRedock3,spcountRedock4)

% Initialize the output variables
counts = zeros(size(spcountRedock1));
valid = zeros(size(spcountRedock1));

integrationInds = 1:integrationTime;

for ii = floor(1:(length(spcountRedock1)/integrationTime-1))
  
  inds = integrationInds(1:end-1) + integrationTime*(ii-1);
  counts(inds) = cumsum(spcountRedock1(inds)) + cumsum(spcountRedock2(inds)) ...
               + cumsum(spcountRedock3(inds)) + cumsum(spcountRedock4(inds));
               
  valid(inds(end)) = 1;
end

if size(counts,2) > inds(end)
  counts(inds(end)+1:end) = cumsum(spcountRedock1(inds(end)+1:end)) + cumsum(spcountRedock2(inds(end)+1:end)) ...
                          + cumsum(spcountRedock3(inds(end)+1:end)) + cumsum(spcountRedock4(inds(end)+1:end));
end


end