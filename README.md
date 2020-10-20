# Simulink Models

## Folder structure
- autogen: contains the Autogen framework
- models: simulink model projects utilizing the Autogen framework
- config: path configuration files for the Autogen framework
- test_signals: audio files for testing the models


## Getting started with a new Simulink Model
- Create the Simulink Model matching Autogen examples  
- Run `config/pathSetup.m`  
- Create `model.json` using `createModelJson`, ex. `createModelJson("echo")`  
- (optional) Create `modelparameters.m` for additional configuration  
- (optional) Create `sm_stop_verify.m` for verifying simulation  

More information on `model.json`, `modelparameters.m`, and `sm_stop_verify.m` can be found [here](autogen/README.md)