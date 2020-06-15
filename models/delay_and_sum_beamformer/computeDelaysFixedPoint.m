function delays = computeDelaysFixedPoint(mp)
ELEMENT_SPACING = fi(mp.arraySpacing, 0, 16, 15);  % meters
SPEED_OF_SOUND = fi(mp.speedOfSound, 0, 9, 0); % meters/second
NUM_ELEMENTS_Y = fi(mp.arraySize(1), 1, 5, 1);
NUM_ELEMENTS_Z = fi(mp.arraySize(2), 1, 5, 1);

DEG_TO_RAD = fi(pi/180, 0, 8, 7);
SAMPLING_RATE = sfi(mp.Fs);

delays = fi(zeros(mp.arraySize(1) * mp.arraySize(2), 1), mp.delayDataTypeSign, mp.delayDataTypeWordLength, mp.delayDataTypeFractionLength);
yElementIdx = fi(0:(NUM_ELEMENTS_Y - 1), 1, 5, 1);
zElementIdx = fi((0:(NUM_ELEMENTS_Z - 1)), 1, 5, 1);

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