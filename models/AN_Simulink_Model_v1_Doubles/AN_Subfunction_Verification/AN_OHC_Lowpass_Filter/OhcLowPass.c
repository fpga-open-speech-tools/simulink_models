/* OhcLowPass() - A C function created to isolate the OHC Lowpass
   filter found in the AN Model C source code model_IHC_BEZ2018 in order 
   to verify Simulink functionality

   ohcout = OhcLowPass(x, tdres, Fc, n, gain, order)

   The filter takes in either the signal output from the OHC nonlinear function,
   binsize, filter cutoff frequency, sample number, filter gain, and filter order
   and returns the OHC output signal.

   Inputs:
   x = signal in
   tdres = binsize, or sampling period
   Fc = lowpass filter cutoff frequency
   n = sample number
   gain = filter gain
   order = filter order

   Outputs:
   ohcout = OHC output signal

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
   openspeech@flatearthinc.com

   Auditory Nerve Simulink Model Code
   OhcLowPass.c Function
   06/26/2019 */

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
void OhcLowPass(double x, double tdres, double Fc, int n, double gain, int order, double *ohcout)
{
  static double ohc[4],ohcl[4];

  double c,c1LP,c2LP;
  int i,j;

  if (n==0)
  {
      for(i=0; i<(order+1);i++)
      {
          ohc[i] = 0;
          ohcl[i] = 0;
      }
  }

  c = 2.0/tdres;
  c1LP = ( c - TWOPI*Fc ) / ( c + TWOPI*Fc );
  c2LP = TWOPI*Fc / (TWOPI*Fc + c);

  ohc[0] = x*gain;
  for(i=0; i<order;i++)
    ohc[i+1] = c1LP*ohcl[i+1] + c2LP*(ohc[i]+ohcl[i]);
  for(j=0; j<=order;j++)
    ohcl[j] = ohc[j];
  *ohcout = ohc[order];
}

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{

    double x, tdres, Fc, *ntmp, gain, *ordertmp, *ohcout;
    int n, order;

    /* get the value of the scalar input  */
    x = mxGetScalar(prhs[0]);
    tdres = mxGetScalar(prhs[1]);
    Fc = mxGetScalar(prhs[2]);
    ntmp = mxGetPr(prhs[3]);
    gain = mxGetScalar(prhs[4]);
    ordertmp = mxGetPr(prhs[5]);


    /* convert to integers */
    n = (int) ntmp[0];
    order = (int) ordertmp[0];

    /* get pointer to the data in the output */
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    ohcout = mxGetPr(plhs[0]);

    /* call the computational routine */
    OhcLowPass(x, tdres, Fc, n, gain, order, ohcout);
}
