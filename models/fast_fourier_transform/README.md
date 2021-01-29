# Fast Fourier Transform Analysis/Synthesis Models
This folder contains model references that provide a framework for frequency-domain processing:
- `fft_analysis`: transform audio into the frequency domain
- `fft_synthesis`: transform back into the time domain
- `fast_fourier_transform_sim`: a full simulation model that performs analysis and synthesis using the `fft_analysis`  and `fft_synthesis` models

These models were developed for use with the Frost Autogen Framework. To set up Frost Autogen, please review the [Getting Started Guides](https://github.com/fpga-open-speech-tools/docs/tree/master/getting_started). 

## Algorithm
A Fast Fourier Transform (FFT) is used to transform audio into the frequency domain (known as [Fourier Analysis](https://en.wikipedia.org/wiki/Fourier_analysis)), after which frequency-domain processing can be performed; after processing, an inverse FFT (iFFT) is used to synthesize the time-domain audio from it's frequency spectrum (known as Fourier Synthesis). The models contained here implement the [Short-time Fourier transform](https://en.wikipedia.org/wiki/Short-time_Fourier_transform) (STFT) and inverse STFT; the inverse STFT is implemented using the [overlap-and-add method](https://en.wikipedia.org/wiki/Overlap%E2%80%93add_method).

## Usage
The `fft_analysis` and `fft_synthesis` models are intended be used as [model references](https://www.mathworks.com/help/simulink/model-reference.html). To do frequency-domain processing, add the `fft_analysis` and `fft_synthesis` models to your model as referenced models. You will pass the audio into the `fft_analysis` block, do your desired frequency-domain processing on the `FFT_data` signal, then feed processed FFT data into the `modified_FFT_data` port of the `fft_synthesis` block. 

For a basic example of connecting the analysis and synthesis blocks together, see `fast_fourier_transform_sim`. For concrete examples of frequency-domain processing, see the [FFT filters](../fft_filters) model. 

When using the analysis and synthesis models, you need to implement all the parameters found in the `%% Model parameters` section of `modelparameters.m`; the variable names **can not be changed** without having to change them in the analysis and synthesis models. The only model parameter you should change is `mp.FFT_size`. All other parameters are derived parameters; **changing them will break the analysis and synthesis models**. 

## Implementation
The incoming audio signal is buffered into a dual-port RAM that is twice the FFT size. Once the buffer is full, data is read out in bursts at rate 32-times faster than the sampling rate. The STFT is implemented with Hanning windows that are overlapped by 1/4 of the FFT size.
