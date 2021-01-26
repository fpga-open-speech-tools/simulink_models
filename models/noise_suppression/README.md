# Noise Suppression via Adaptive Wiener Filtering
This Simulink model implements an adaptive Wiener filter based on [Speech enhancement with an adaptive Wiener filter](https://link.springer.com/article/10.1007/s10772-013-9205-5). This model was developed using the Frost Autogen Framework and deployed to an Audio Mini using Frost Edge. To set up Frost Autogen or Frost Edge, please review the [Getting Started Guides](https://github.com/fpga-open-speech-tools/docs/tree/master/getting_started).  

## Algorithm
The algorithm takes advantage of the varying local speech statistics in the time-domain to obtain an estimate of a speech signal that is corrupted by additive zero mean white Gaussian noise. The variance of the additive noise is assumed a priori. The mean and variance of the speech signal are estimated every sample using a sliding window. The estimated speech signal is the signal mean plus the incoming sample weighted by a ratio of the speech and noise variances. See the [paper](https://link.springer.com/article/10.1007/s10772-013-9205-5#Sec7). 

Heuristically, if the speech variance is much greater than the assumed noise variance, we have high confidence that the incoming sample contains speech information; on the other hand, if the assumed noise variance is much greater than the estimated speech variance, we have little confidence that the incoming sample is anything other than noise, so the best estimate of the speech signal is the mean of the current window.

## Usage
The noise suppression can be turned on and off via the `enable` register. 

The amount of noise suppression can be varied at runtime by adjusting the value of the `noise_variance` register, which ranges from 0 to 1; a higher value results in more noise suppression.

## Implementation
To make the algorithm hardware-friendly and resource-efficient, the mean and variance of the incoming signal are computed as the [exponential moving average](https://en.wikipedia.org/wiki/Moving_average#Exponential_moving_average) and the [exponential moving variance](https://en.wikipedia.org/wiki/Moving_average#Exponentially_weighted_moving_variance_and_standard_deviation). Additionally, the division operation in the original algorithm is approximated iteratively because division is resource intensive in FPGAs. 



