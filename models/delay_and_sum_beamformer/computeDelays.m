function delays = computeDelays(azimuth, elevation)
%#codegen    
% TODO: optimize data types
ELEMENT_SPACING = fi(25e-3, 0);  % meters
SPEED_OF_SOUND = fi(343, 0); % meters/second
NUM_ELEMENTS_Y = fi(4, 1, 32, 28);
NUM_ELEMENTS_Z = fi(4, 1, 32, 28);
DEG_TO_RAD = fi(pi/180, 0, 10, 9);
SAMPLING_RATE = 48e3;

delays = fi(zeros(16, 1), 1, 32, 28); 

yElementIdx = fi(0:(NUM_ELEMENTS_Y - 1), 1, 16, 8);
zElementIdx = fi((0:(NUM_ELEMENTS_Z - 1)).', 1, 16, 8);

azimuthRadians = azimuth * DEG_TO_RAD;
elevationRadians = elevation * DEG_TO_RAD;

yDistanceFromPhaseCenter = ELEMENT_SPACING * (yElementIdx - (NUM_ELEMENTS_Y - 1)/2);
zDistanceFromPhaseCenter = ELEMENT_SPACING * (zElementIdx - (NUM_ELEMENTS_Z - 1)/2);

for z = zElementIdx
    for y = yElementIdx
        delays(y + z + 1) = SAMPLING_RATE/SPEED_OF_SOUND  * (yDistanceFromPhaseCenter(y + 1) * sin(azimuthRadians) * cos(elevationRadians) + ...
            zDistanceFromPhaseCenter(z + 1) * sin(elevationRadians));
    end
end
end