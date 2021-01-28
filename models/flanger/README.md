# Flanger
This design implements [flanging](https://en.wikipedia.org/wiki/Flanging), which produces a "swooshing" effect. This model was developed using the Frost Autogen Framework and deployed to an Audio Mini using Frost Edge. To set up Frost Autogen or Frost Edge, please review the [Getting Started Guides](https://github.com/fpga-open-speech-tools/docs/tree/master/getting_started). 

## Algorithm
Flanging is a delay-based effect that originated in analog recording studios.
Two reel-to-reel tape machines are set to play the same tape, and their outputs are
added together. Pressing the flange of a reel slows the playback speed of the reel,
causing a slight delay between the two tape machines. The flange of each tape machine
is pressed in alternating fashion, resulting in a modulation of the delay between the
two tape machines. This effect can be modeled with a feedforward comb filter whose delay is slowly modulated over time with a low-frequency oscillator (LFO).

## Usage
 - `Enable`: Enable or disable the flanger. In a disabled state, audio is passed directly through the system.
 - `Rate`: The rate of the LFO that modulates the delay line. This value ranges between 0 and approximatley 8 Hz.
 - `Regen`: The amount of feedback gain 
 - `Wet Dry Mix`: The ratio of the original audio (dry) to the processed signal (wet). This value should range between 0 and 1, where 0 passes only the original audio and 1 passes only the modified signal.
 
## Implementation
The feedforward delay is implemented with a dual-port RAM-based circular buffer. The delay is modulated by an LFO that is implemented with a [numerically controlled oscillator (NCO)](https://en.wikipedia.org/wiki/Numerically-controlled_oscillator).

<p align="center">
  <img src="flanger.svg" />
</p>
