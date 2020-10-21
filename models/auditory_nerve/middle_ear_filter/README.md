# Auditory Nerve Model - The Middle Ear Filter

## Folder Structure
    |-- Middle Ear Filter
        |-- mef_parameters.m       # Calculates the Middle Ear Filter Coefficients
        |-- mef_subsystem.slx      # Simulink Subsystem Model of the M.E.F.
        |-- mef_verification.m     # Function to compute the results of the Middle Ear Filter
        |-- middle_ear_filter.slx  # Simulink Model used for Test and Validation
        |-- model.json             # Parameters for the FrOST Frame Work
        |-- modelparameters.m      # Model Parameters used in Simulink Simulation
        |-- README.md              # This file
        |-- verify_mef_hdl.m       # MATLAB Script to verify the generated HDL using the CoSimWizard
        |-- verifySim.m            # MATLAB Script to Verify the Simulink Model

## Validating the Simulink Model
1. Run  `[FrOST Repos]\simulink_models\config\pathSetup.m`
2. Navigate to `[FrOST Repos]\simulink_models\auditory_nerve\middle_ear_filter`
3. Open `middle_ear_filter.slx` and run the simulation

## Generating the VHDL
1. In the Simulink Model, open the HDL Coder App
2. In the HDL Coder Toolbar, open `Settings`
    1. Under Basic Options, update the output folder path
    2. Under Target, update the device to the Arria 10 
    3. Under Floating Point:  
        A. For Floating Point Library, select `Native Floating Point`  
        B. For Latency Strategy, select `ZERO`
    4. Under Global Settings, set the Module name prefix to `<empty>`
3. In the HDL Coder Toolbar, click `Generate HDL Code`

## Cosim Wizard
1. In the MATLAB Command Window, run `cosimWizard`
2. Cosimulation Type:
    A. HDL Cosimulation with `MATLAB System Object`
    B. Use HDL Simulator at the following location: `C:\modeltech_pe_10.5a\win32pe`
3. Select the Generated VHDL Files
4. Select the `Dataplane` as the Top Level File to Simulate
5. For Output Ports, set the outputs format and signed v. unsigned
6. Click Next until complete

## Running the Simulation
1. Launch ModelSim by running `launch_hdl_simulator_dataplane.m`
2. Update line 4 of `verify_mef_hdl.m` with the correct hdlcosim handler
3. Run `verify_mef_hdl.m`
