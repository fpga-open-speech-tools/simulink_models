# Selectable Filter Bank
This project implements four frequency-domain filters: low pass (LPF), band pass (BPF), high pass (HPF), and all pass (APF). The active filter can be changed during runtime. This model was developed using the Frost Autogen Framework and deployed to an Audio Mini using Frost Edge. To set up Frost Autogen or Frost Edge, please review the [Getting Started Guides](https://github.com/fpga-open-speech-tools/docs/tree/master/getting_started). 

## Usage
- `enable`: enable or disable the filter
- `filter_select`: change between filters

The filter selection will show up in Frost Edge as a button where you can select between LPF, BPF, HPF, and APF. 

## Implementation
The main model, `fft_filters`, uses multiple referenced models. The [FFT analysis/synthesis models](../fast_fourier_transform) are used to transform into and out of the frequency domain. `filter_bank` implements the filters via lookup tables containing the appropriate filter coefficients. The filter cutoff frequencies and coefficients are defined and calculated in `modelparameters`.

See the [FFT analysis/synthesis README](../fast_fourier_transform/README.md) for more information.