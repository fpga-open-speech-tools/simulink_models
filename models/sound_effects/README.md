# Sound Effects
A multi-effects processor! Originally presented at the [147th AES Convention](https://www.aes.org/e-lib/browse.cfm?elib=20623), this project is a combination of the [vector gain](../simple_gain_vector), [flanger](../flanger), [echo](../echo), and [bitcrusher](../bitcrusher). This model was developed using the Frost Autogen Framework and deployed to an Audio Mini using Frost Edge. To set up Frost Autogen or Frost Edge, please review the [Getting Started Guides](https://github.com/fpga-open-speech-tools/docs/tree/master/getting_started). 

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

## Implementation
This design utilizes Simulink [model references](https://www.mathworks.com/help/simulink/model-reference.html), which promotes code reuse by allowing designs to be created by combining multiple models together. This model references the `vector_gain_ref`, `flanger_ref`, `echo_ref`, and `bitcrusher_ref` models from the [vector gain](../simple_vector_gain), [flanger](../flanger), [echo](../echo), and [bitcrusher](../bitcrusher) projects. These reference models do not contain the components that are typically included in the top-level of a Frost model, such as input audio signals and register control signals.