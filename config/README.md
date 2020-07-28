# Path Setup Instructions
To use FPGA Open Speech Tools' Simulink code generation tools, MATLAB needs to know where the code generation tools and Quartus are located. 
By convention, all of the FPGA Open Speech Tools repositories are cloned to the same root directory during development.

## Automatic Path Setup
By default, `pathSetup.m` will try to automatically find the required paths. For this to work, the [simulink_codegen](https://github.com/fpga-open-speech-tools/simulink_codegen) repository needs to be in the same folder as [simulink_models](https://github.com/fpga-open-speech-tools/simulink_models). Quartus is found automatically from your system's environment variables. 

### Quartus Environment Variables
Users should not need to manually define any Quartus environment variables. We check for the following environment variables:
```
QUARTUS_ROOTDIR_OVERRIDE
QUARTUS_ROOTDIR
QSYS_ROOTDIR
```

On systems with multiple Quartus installations, `QUARTUS_ROOTDIR_OVERRIDE` can be used to define which Quartus installation is the default installation. `QUARTUS_ROOTDIR` should automatically be defined on Windows, and `QSYS_ROOTDIR` should exist on Linux if you used the default installation procedure; if Linux users have not followed the default Quartus installation, they will need to manually define at least one of the environment variables listed above. 

## Manual Path Setup
Paths can be manually specified by creating a `path.json` file. An example is shown in `example_path.json`:
```json
{
	"root" : "C:\\Users\\wickh\\Documents\\NIH\\",
	"quartus" : "C:\\intelFPGA\\18.0\\quartus\\bin64"
}
```
The `root` path is where [simulink_codgen](https://github.com/fpga-open-speech-tools/simulink_codegen) and [simulink_models](https://github.com/fpga-open-speech-tools/simulink_models) are located.
