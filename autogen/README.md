# Autogen Framework Model Interfaces
The Autogen framework gives 3 major file based interfaces for models: `model.json`, `modelparameters.m`, and `sm_stop_verify.m` and 1 major interface available as a struct in the Matlab workspace: `mp`.

## model.json
`model.json` is a required configuration file shared between the Autogen Framework and the Autogen Tools. This covers both system-level properties as well as run-time tunable parameters for the model via registers.  
`model.json` properties:  
- `system`: An object to describe the overall system  
    - `target`: Which hardware system is being targeted, the `audiomini` or `audioblade` (default: `audiomini`)  
    - `sampleClockFrequency`: The sampling rate of the audio being processed (default: `48000`)  
    - `systemClockFrequency`: Clock rate of the audio processing on the FPGA (default: `98304000`)  
    - `inputDataType`: Object representing the data type of the audio input  
        - `wordLength`: number of total bits in the data type  
        - `fractionLength`: number of fractional bits in the fixed point number  
        - `signed`: true if the data type is signed, false otherwise  
    - `outputDataType`: Object reprenting the data type of the audio output
    (Note: Currently unused, only inputDataType is read)
        - `wordLength`: number of total bits in the data type  
        - `fractionLength`: number of fractional bits in the fixed point number  
        - `signed`: true if the data type is signed, false otherwise  
    - `numberOfChannels`: number of channels in the audio to be processed (default: `2`)  
- `devices`: An array of objects representing devices. Simulation support is only for one device.  
    - device object  
        - `name`: Name of the Simulink model  
        - `registers`: An array of objects representing run-time tunable parameters as registers  
        - register object  
            - `dataType`: object representing the data type of the register  
                - `fractionLength`: number of fractional bits in the fixed point number  
                - `signed`: true if the data type is signed, false otherwise  
                - `type`: string representation of type ('boolean', 'string', 'int')  
                - `wordLength`: number of total bits in the data type  
            - `defaultValue`: default value to set the register to (should be 1 or 0 for boolean types)  
            - `name`: name of the tunable parameter  
            - `registerNumber`: offset in memory for the register (starts at 1 and must have registerNumber's defined between 1 and the highest value given)  

## Model Parameters
`modelparameters.m` is an optional model specific script that can define both properties to directly interface with Autogen or to be available to the Simulink Model. These model parameters are available via the `mp` struct.  

Configurable Autogen model parameters:  
- `testFile`: A path to an audio file for input to the simulation. The number of channels should match `numberOfChannels` defined in `model.json`  
- `nSamples`: Number of samples of the test audio source to simulate after resampling
- `sim_prompts`: Flag to enable prompts during simulation  
- `sim_verify`: Enables simulation verification with the user defined script `verifySim`  

## Verifying the Simulation
If `sim_verify` is set to `1`, then the Autogen framework will attempt to run the user defined script `verifySim` post-simulation. Autogen makes the output data available via the following two fields on the `mp` struct:  
- `dataOut`: m x n array where m is the number of channels and n is the number of samples containing the channel's audio data  

The `verifySim` should have the same inputs and outputs as the example below:  
```Matlab
function mp = verifySim(mp, test_signal)

%% Verify that the test data got encoded, passed through the model, and
% decoded correctly. 

figure(1)
subplot(2,1,1)
plot(testSignal.audio(:,1)); hold on
plot(mp.dataOut(1,:))
title(['Delay = ' num2str(mp.register{2}.value) '  Bypass = ' num2str(mp.register{1}.value) '  Decay = ' num2str(mp.register{3}.value)  '  Wet/Dry Mix = ' num2str(mp.register{4}.value)])

subplot(2,1,2)
plot(testSignal.audio(:,2)); hold on
plot(mp.dataOut(2,:))
title(['Delay = ' num2str(mp.register{2}.value) '  Bypass = ' num2str(mp.register{1}.value) '  Decay = ' num2str(mp.register{3}.value)  '  Wet/Dry Mix = ' num2str(mp.register{4}.value)])

end
```  

## mp: The model parameters struct
Notable fields on the `mp` struct, in addition to those described above:
- `W_bits`: number of total bits in the audio data  
- `F_bits`: number of fractional bits in the audio data  
- `nChannels`: number of channels in the audio  
- `signed`: true if the audio data is signed, false otherwise  
- `Fs`: Sampling rate of the audio data  
- `Ts`: Sampling time of the audio data  
- `Ts_sim`: Sample time expected during Simulation  
- `register`: Cell array of registers  
    - `name`: Name of tunable parameter  
    - `value`: Value that the tunable parameter is set to  
    - `dataType`: Matlab datatype of the tunable parameter  
    - `timeseries`: timeseries object containing the register's value for use in simulation  
