function delays = computeDelays(mp)
%#codegen    
% TODO: optimize data types
ELEMENT_SPACING = fi(25e-3, 0, 16, 15);  % meters
SPEED_OF_SOUND = fi(343, 0, 9, 0); % meters/second
NUM_ELEMENTS_Y = fi(4, 1, 5, 1);
NUM_ELEMENTS_Z = fi(1, 1, 5, 1);

DEG_TO_RAD = fi(pi/180, 0, 8, 7);
SAMPLING_RATE = sfi(48e3);

% TODO: make array size generic
delays = fi(zeros(4, 1), mp.delayDataTypeSign, mp.delayDataTypeWordLength, mp.delayDataTypeFractionLength);
yElementIdx = fi(0:(NUM_ELEMENTS_Y - 1), 1, 5, 1);
zElementIdx = fi((0:(NUM_ELEMENTS_Z - 1)), 1, 5, 1);

azimuthRadians = mp.simulatedAzimuth * DEG_TO_RAD;
elevationRadians = mp.simulatedElevation * DEG_TO_RAD;

yDistanceFromPhaseCenter = ELEMENT_SPACING * (yElementIdx - (NUM_ELEMENTS_Y - 1)/2);
zDistanceFromPhaseCenter = ELEMENT_SPACING * (zElementIdx - (NUM_ELEMENTS_Z - 1)/2) * -1;

idx = 0;
for y = yElementIdx
    for z = zElementIdx
        idx = idx + 1;
        delays(idx) = -SAMPLING_RATE/SPEED_OF_SOUND  * (yDistanceFromPhaseCenter(y + 1) * sin(azimuthRadians) * cos(elevationRadians) + ...
            zDistanceFromPhaseCenter(z + 1) * sin(elevationRadians));
    end
end
end