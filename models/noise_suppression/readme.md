# Flat Earth Inc
By Justin P. Williams and Ross K. Snider.

# WienerV2 MATLAB & Simulink Model Run Guide
This is a tutorial on how to run my somewhat thrown together Adaptive Wiener Speech Enhancement Filter.

	* Some notes:
		* This Model was based on the Simple Gain Model 
		* As such, similar scripts were used as well as the init functions
	* To Get Running:
		* Configure the "sm_run_me_firstLOCAL.m" Script with the following:
			* Configure your quartus and python paths
			* The rest of the paths should coincide with the model directory
				* Many of the utilities are within this sub-model folder, and don't call on the top level utilities folder in the top-level git repo
		* Configure the "sm_init_test_signalsLOCAL.m" file with the following: 
			* For the entire signal run time:
				* Comment lines: [81-83, 85] 
				* These correspond to the if else end conditional regarding the fast_simflag
This should be everything to get this model running from the git repo.
