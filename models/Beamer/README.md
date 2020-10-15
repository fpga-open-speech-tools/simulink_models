# The Beamer - AES 2020

## Requirements
1. Configure the [FrOST Software](https://github.com/fpga-open-speech-tools/docs/blob/master/getting_started.md)

## Recreating the Beamer Project from AES 2020
1. In `[FrOST Repos]\simulink_models\models\Beamer\`, create `\hdlsrc\Beamer\quartus\ip\`
2. Open MATLAB and Navigate to `[FrOST Repos]\simulink_models\config\`   
3. Run `pathSetup.m`  

4. Copy the contents of `[FrOST Repos]\simulink_models\models\Beamer\ip\` into `[FrOST Repos]\simulink_models\models\Beamer\hdlsrc\Beamer\quartus\ip\` and jump to step 8

**Optional - Regenerate the VHDL**  

4. Generate the [**Delay and Sum Beamformer**](https://github.com/fpga-open-speech-tools/simulink_models/tree/dev/models/delay_and_sum_beamformer) by
    - Opening `[FrOST Repos]\simulink_models\models\delay_and_sum_beamformer\DSBF.slx`
    - Saving the model - This accounts for any potential conflicts with MATLAB Versions
    - Navigate to the top level of the design and click the `Run` button (Green Play Icon) in the toolbar
    - Click the Green Generate VHDL Button in the bottom left
5. In `[FrOST Repos]\simulink_models\models\Beamer\hdlsrc\Beamer\quartus\ip\`, create `delay_and_sum_beamformer\`
6. Copy the VHDL Files, the `[model_name]_dataplane_avalon_hw.tcl`, and `[model_name].ko` from `[FrOST Repos]\simulink_models\models\delay_and_sum_beamformer\hdlsrc\delay_and_sum_beamformer\` to `[FrOST Repos]\simulink_models\models\Beamer\hdlsrc\Beamer\quartus\ip\delay_and_sum_beamformer\`
7. Repeat Step 4-6 with the [**Noise Supression**](https://github.com/fpga-open-speech-tools/simulink_models/tree/dev/models/noise_suppression), [**Simple Gain**](https://github.com/fpga-open-speech-tools/simulink_models/tree/dev/models/simple_gain/), and [**FFT Filter**](https://github.com/fpga-open-speech-tools/simulink_models/tree/dev/models/fft_filters/)     

**Generating the Beamer**  

8. Run `build.m` script to generate the Platform Designer system and Quartus project, as well as compile the generated project
9. Copy `connect_mic_array.tcl` to `[FrOST Repos]\simulink_models\models\Beamer\hdlsrc\Beamer\quartus\`
10. From the Windows Command Prompt, navigate to `[FrOST Repos]\simulink_models\models\Beamer\hdlsrc\Beamer\quartus\`
11. Check the Qsys Root Directory with `echo %QSYS_ROOTDIR%`
    - Result: `C:\intelFPGA\20.1\quartus\sopc_builder\bin`
12. Run `%QSYS_ROOTDIR%\qsys-script --script=connect_mic_array.tcl --search-path=../../../../../component_library,$`
13. Rerun `build.m`


## Testing the Beamer Project
1. Create Folder Structure in AWS S3 -  `[s3-bucket]\audioresearch\beamer`
2. Upload the following files to the S3 Bucket from step 1
    - `[FrOST Repos]\simulink_models\models\Beamer\model.json`
    - `[FrOST Repos]\simulink_models\models\Beamer\hdlsrc\Beamer\aes_reflex.dtbo`
    - `[FrOST Repos]\simulink_models\models\Beamer\hdlsrc\Beamer\quartus\ip\delay_and_sum_beamformer\DSBF.ko`
    - `[FrOST Repos]\simulink_models\models\Beamer\hdlsrc\Beamer\quartus\ip\fft_filters\fft_filters.ko`
    - `[FrOST Repos]\simulink_models\models\Beamer\hdlsrc\Beamer\quartus\ip\noise_suppression\noise_suppression.ko`
    - `[FrOST Repos]\simulink_models\models\Beamer\hdlsrc\Beamer\quartus\ip\simple_gain\simple_gain.ko`
3. Program the Audio Research
4. Connect to the web app on an Audioresearch
- Download the project you uploaded, which will be listed as the final subdirectory in `path` that was used during upload
- After download, click the edit icon under `Controls` and then the wrench icon to generate the controls


# Notes
External users still can't upload to S3 (URL not configurable)
Use provided `model.json`
