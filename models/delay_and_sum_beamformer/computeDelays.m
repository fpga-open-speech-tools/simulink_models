function delays = computeDelays(mp)
ELEMENT_SPACING = mp.arraySpacing;  % meters
SPEED_OF_SOUND = mp.speedOfSound; % meters/second
NUM_ELEMENTS_Y = mp.arraySize(1);
NUM_ELEMENTS_Z = mp.arraySize(2);
DEG_TO_RAD = pi/180;
SAMPLING_RATE = mp.Fs;

delays = zeros(mp.arraySize(1) * mp.arraySize(2), 1);
yElementIdx = 0:(NUM_ELEMENTS_Y - 1);
zElementIdx = 0:(NUM_ELEMENTS_Z - 1);

azimuthRadians = mp.simulatedAzimuth * DEG_TO_RAD;
elevationRadians = mp.simulatedElevation * DEG_TO_RAD;

yDistanceFromPhaseCenter = ELEMENT_SPACING * (yElementIdx - (NUM_ELEMENTS_Y - 1)/2);
zDistanceFromPhaseCenter = ELEMENT_SPACING * (zElementIdx - (NUM_ELEMENTS_Z - 1)/2);

idx = 0;
for z = zElementIdx
    for y = yElementIdx
        idx = idx + 1;
        delays(idx) = -SAMPLING_RATE/SPEED_OF_SOUND  * (yDistanceFromPhaseCenter(y + 1) * sin(azimuthRadians) * cos(elevationRadians) + ...
            zDistanceFromPhaseCenter(z + 1) * sin(elevationRadians));
    end
end
end