# FIR filter based hearing aid
**This is a legacy design**. It is only here for reference. It is not compatible with Frost Autogen or Frost Edge.

This model implements a basic 4-band hearing aid using band pass filters. Decimation and interpolation are used to reduce the computational resources needed for the band pass filters. This model is not recommended due to latency issues.  The recommended hearing aid model is the openMHA hearing aid model that uses the frequency domain.

The `HA_sys8_init*.m` files contain model initialization and parameters. 