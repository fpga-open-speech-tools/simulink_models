Start:
The starting point for the model is to run the script: Run_me_first.m
You will need to edit Run_me_first.m appropriately to modify the settings for your computer environment (directory paths, tools, etc).


Simulink Model File Organization:

   SG.slx - Simple Gain Simulink model

   SG_callback_init.m is called before the simulation runs.  This script initializes the model parameters.  It calls the following functions:

         SG = SG_init_control_signals(SG);   This function creates the control signals that control the simulink model.  Parameters such as the expected min and max values for a signal need to be added for proper conversion to VHDL

         SG = SG_init_test_signals(SG);      This function creates the test signals that are run through the model

         SG = SG_init_avalon_signals(SG);    This function puts the test signals into the Avalon Streaming Bus Interface that uses the data-channel-valid protocol.

  SG_callback_stop.m is called after the simulation runs.  It calls the following functions:

         SG = SG_stop_process_output(SG);    This function converts from Avalon Streaming to vector form needed for verification

         SG = SG_stop_verify(SG);            This function verifies that the output of the model is correct



VHDL Code Generation:
In the Simulink Model, when the text block is clicked that says: "Run simulation first before clicking this box to Generate VHDL", the following script runs:

   vgen_process_simulink_model.m;   This script controls the VHDL generation process.  It calls the following functions:

         avalon      = vgen_get_simulink_block_interfaces();    This function parses the simulink model to get the interface signals

         avalon.vhdl = vgen_generate_VHDL_component(avalon);
             


