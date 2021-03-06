# The Beamer - AES 2020
The Beamer is a combination of multiple independent FrOST Example Designs: The Delay and Sum Beamformer, The Simple Gain, The FFT Filters, and the Noise Suppression. The Beamer was presented at the AES 2020 Conference in *Design of Audio Processing Systems with Autogenerated User Interfaces for System-on-Chip Field Programmable Gate Arrays*.

## Requirements
1. Configure the [FrOST Software](https://github.com/fpga-open-speech-tools/docs/blob/master/getting_started.md)

## Recreating the Beamer Project from AES 2020
1. In `[FrOST Repos]\simulink_models\models\Beamer\`, create `\hdlsrc\Beamer\quartus\ip\`
2. Open MATLAB and Navigate to `[FrOST Repos]\simulink_models\config\`   
3. Run `pathSetup.m`  

4. Copy the contents of `[FrOST Repos]\simulink_models\models\Beamer\ip\` into `[FrOST Repos]\simulink_models\models\Beamer\hdlsrc\Beamer\quartus\ip\` and jump to step 8

**Optional - Regenerate the VHDL**  

4. Generate the [**Delay and Sum Beamformer**](https://github.com/fpga-open-speech-tools/simulink_models/tree/dev/models/delay_and_sum_beamformer):
    - Open `[FrOST Repos]\simulink_models\models\delay_and_sum_beamformer\DSBF.slx`
    - Save the model - This accounts for any potential conflicts with MATLAB Versions
    - Click the `Run` button (Green Play Icon) in the toolbar
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
1. If necessary, create an [S3 Bucket](https://github.com/fpga-open-speech-tools/utils/tree/dev/s3) using the Frost CloudFormation Template
2. Create the Folder Structure in AWS S3 - `[s3-bucket]\audioresearch\beamer`
3. Upload the following files to the S3 Bucket from step 1
    - `[FrOST Repos]\simulink_models\models\Beamer\model.json`
    - `[FrOST Repos]\simulink_models\models\Beamer\hdlsrc\Beamer\aes_reflex.dtbo`
    - `[FrOST Repos]\simulink_models\models\Beamer\hdlsrc\Beamer\quartus\ip\delay_and_sum_beamformer\DSBF.ko`
    - `[FrOST Repos]\simulink_models\models\Beamer\hdlsrc\Beamer\quartus\ip\fft_filters\fft_filters.ko`
    - `[FrOST Repos]\simulink_models\models\Beamer\hdlsrc\Beamer\quartus\ip\noise_suppression\noise_suppression.ko`
    - `[FrOST Repos]\simulink_models\models\Beamer\hdlsrc\Beamer\quartus\ip\simple_gain\simple_gain.ko`
4. Program the Audio Research
    - Open Quartus and load the Beamer Project from `[FrOST Repos]\simulink_models\models\Beamer\hdlsrc\Beamer\quartus\DSBF_simple_gain_fft_filters_noise_suppression.qpf`
    - Open the FPGA Programmer from `Tools -> Programmer`
    - Click `Hardware Setup`, then `Arria 10` under the `Currently Selected Hardware` dropdown, then `Close`
    - Click `Auto Detect`
    - Select the `10AS066H2`, the click `OK`
    - Select the `10M16SA`, the click `OK`
    - In the bottom right, select the Arria 10 (`10AS066H2`)
    - Click `Chnage File`, Select the `output_files\DSBF_simple_gain_fft_filters_noise_suppression_reflex.sof`, and Click `Open`
    - Check the `Program/Configure` box for the Arria 10 (Middle Right)
    - Click `Start` on the left
    - Once programmed, the HPS will start to Boot
5. Connect to the web app on an Audio Research 
    - Log into the Arria 10 using the serial port 
        - Username: `root`
        - Password: `root`
    - Determine the IP Address using `ip addr`
    - In a web browser, navigate to `[ip address]:5000`
6. Download the Beamer Controls to the Audio Research
    - Enter the bucket name use during the upload step and click `Update`
    - Under device, select `audioresearch`
    - Under the beamer project, click the download icon
    - Once downloaded and installed, the project controls will be available
