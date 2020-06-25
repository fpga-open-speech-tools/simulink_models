/* WbGammaTone() - A C function created to isolate the Control Path Wideband
   Gammatone Filter function found in the AN Model C source code
   model_IHC_BEZ2018 in order to verify Simulink functionality

   output = WbGammaTone(x, tdres, centerfreq, n, tau, gain, order)

   The filter takes in the Middle Ear Filter output signal, binsize,
   shifted center frequency, sample number, wideband time constant, wideband
   filter gain, and filter order, and outputs the wideband output signal.

   Inputs:
   x = signal in
	 tdres = binsize, or sampling period
   centerfreq = shifted center frequency of the neuron according to basilar
                membrane location
   n = sample number
   tau = wideband filter time constant
   gain = wideband filter gain
   order = wideband filter order

   Outputs:
   output = wideband output signal

 ------------------------------------------------------------------------

   Copyright 2019 Audio Logic

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
   INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
   PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
   FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
   ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

   Matthew Blunt
   Audio Logic
   985 Technology Blvd
   Bozeman, MT 59718
   support@flatearthinc.com

   Auditory Nerve Simulink Model Code
   WbGammaTone.c Function
   06/27/2019 */

/*-----------------------------------------------------------------------
 * CODE:
 *----------------------------------------------------------------------*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <mex.h>
#include <time.h>

#include "complex.hpp"

#ifndef TWOPI
#define TWOPI 6.28318530717959
#endif

/* The computational function routine */
double WbGammaTone(double x, double tdres, double centerfreq, int n, double tau, double gain, int order, double *output)
{
  static double wbphase;
  static COMPLEX wbgtf[4], wbgtfl[4];

  double delta_phase,dtmp,c1LP,c2LP,out;
  int i,j;

  if (n==0)
  {
      wbphase = 0;
      for(i=0; i<=order;i++)
      {
            wbgtfl[i] = compmult(0,compexp(0));
            wbgtf[i]  = compmult(0,compexp(0));
      }
  }

  delta_phase = -TWOPI*centerfreq*tdres;
  wbphase += delta_phase;

  dtmp = tau*2.0/tdres;
  c1LP = (dtmp-1)/(dtmp+1);
  c2LP = 1.0/(dtmp+1);
  wbgtf[0] = compmult(x,compexp(wbphase));                 /* FREQUENCY SHIFT */

  for(j = 1; j <= order; j++)                              /* IIR Bilinear transformation LPF */
  wbgtf[j] = comp2sum(compmult(c2LP*gain,comp2sum(wbgtf[j-1],wbgtfl[j-1])),
      compmult(c1LP,wbgtfl[j]));
  out = REAL(compprod(compexp(-wbphase), wbgtf[order])); /* FREQ SHIFT BACK UP */

  for(i=0; i<=order;i++) wbgtfl[i] = wbgtf[i];
  *output = out;
}


/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{

    double x, tdres, centerfreq, *ntmp, tau, gain, *ordertmp, *output;
    int n, order;

    /* get the value of the scalar input  */
    x = mxGetScalar(prhs[0]);
    tdres = mxGetScalar(prhs[1]);
    centerfreq = mxGetScalar(prhs[2]);
    ntmp = mxGetPr(prhs[3]);
    tau = mxGetScalar(prhs[4]);
    gain = mxGetScalar(prhs[5]);
    ordertmp = mxGetPr(prhs[6]);


    /* convert to integers */
    n = (int) ntmp[0];
    order = (int) ordertmp[0];

    /* get pointer to the data in the output */
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    output = mxGetPr(plhs[0]);

    /* call the computational routine */
    WbGammaTone(x, tdres, centerfreq, n, tau, gain, order, output);
}
