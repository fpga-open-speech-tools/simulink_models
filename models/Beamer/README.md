## Recreating the Beamer Project from AES 2020

- Generate Delay and Sum Beamformer, Noise Suppression, Simple Gain, and FFT Filter models individually
- Use provided `model.json`
- Create `hdlsrc/Beamer` subdirectories
- Place generated VHDL and HW TCL ip cores into `hdlsrc/Beamer/quartus/ip`
- Run `build.m` script to generate the Platform Designer system and Quartus project, as well as compile the generated project
- Copy `add_mic_array.tcl` to `hdlsrc/Beamer/quartus`
- Run `add_mic_array.tcl` with `qsys-script --script=connect_mic_array.tcl --search-path=../../../../../component_library,$`
    - If `qsys-script` is not on your path, starting from the installation directory it is found at `quartus/sopc_builder/bin/qsys-script`
- Update top level vhdl with provided one
- Run `build.m` once again


## Testing the Beamer Project
- Upload to S3??? (Not supported by people external to Audiologic) using `s3upload(mp, 'bucketName', 'path')`, where `bucketName` matches the S3 bucket you'd like to upload to and `path` is the path in the bucket you want it uploaded to
- Connect to the web app on an Audioresearch
- Download the project you uploaded, which will be listed as the final subdirectory in `path` that was used during upload
- After download, click the edit icon under `Controls` and then the wrench icon to generate the controls


# Notes
External users still can't upload to S3 (URL not configurable)
