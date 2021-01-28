# Sound Effects
A multi-effects processor! Originally presented at the [147th AES Convention](https://www.aes.org/e-lib/browse.cfm?elib=20623), this project is a combination of the [vector gain](../simple_gain_vector), [echo](../echo), [flanger](../flanger), and [bitcrusher](../bitcrusher). This model was developed using the Frost Autogen Framework and deployed to an Audio Mini using Frost Edge. To set up Frost Autogen or Frost Edge, please review the [Getting Started Guides](https://github.com/fpga-open-speech-tools/docs/tree/master/getting_started). 

## Usage
- `Gain Enable`: Enable or disable the gain
- `Gain`: Amount of gain to apply to the input audio
- `Flanger Enable`: Enable or disable the flanger
- `Flanger Rate`: The rate of the LFO that modulates the flanger's delay line
- `Flanger Regen`: Amount of feedback in the flanger
- `Echo Enable`: Enable or disable the echo
- `Echo Delay`: Amount of delay in samples
- `Echo Feedback`: Echo feedback gain
- `Echo Wet/Dry Mix`: The ratio of the original audio (dry) to the echo signal (wet)
- `Bitcrusher Enable`: Enable or disable the bitcrusher
- `Bitcrusher Bits`: Apparent resolution of output audio
- `Bitcrusher Wet/Dry Mix`: The ratio of the original audio (dry) to the bitcrushed audio (wet)