# Signal Conversion Block
Converts the FFT Audio Signal into N dB Intensities - 1 per Frequency Band

## Validation Modes
Type `help toggleModelRefDebug` for more information.

### Debug Mode
Debug Mode sets the number of reference models allowed to **1** and **enables** *To Workspace* Data Logging.
1. Open the Model - `signal_conversion_sim.slx`    
2. Run `toggleModelRefDebug(true)` in the Command Window   
3. Set `debug=true;` on Line 26 of model_parameters.m  
4. Run the Simulation from the Simulink Model  

### Simulation Mode
Simulation Mode sets the number of reference models allowed to **multiple** and **disables** *To Workspace* Data Logging.
1. Open the Model - `signal_conversion_sim.slx`    
2. Run `toggleModelRefDebug(false)` in the Command Window   
3. Set `debug=false;` on Line 26 of model_parameters.m  
4. Run the Simulation from the Simulink Model  