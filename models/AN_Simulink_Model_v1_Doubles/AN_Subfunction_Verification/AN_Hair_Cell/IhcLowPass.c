/* IhcLowPass() - A C function created to isolate the IHC Lowpass Filter
   function found in the AN Model C source code model_IHC_BEZ2018 in order to
	 verify Simulink functionality

   ihcout = IhcLowPass(x, tdres, Fc, n, gain, order)

   The filter takes in either the signal output from the IHC nonlinear functions,
   binsize, filter cutoff frequency, sample number, filter gain, and filter order
   and returns the IHC output signal.

   Inputs:
   x = signal in
   tdres = binsize, or sampling period
   Fc = lowpass filter cutoff frequency
   n = sample number
   gain = filter gain
   order = filter order

   Outputs:
   ihcout = IHC output signal

 ------------------------------------------------------------------------

   Copyright 2019 Audio Logic

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
   INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
   PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
   FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
   ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

   Matthew Blunt
   Flat Earth Inc
   985 Technology Blvd
   Bozeman, MT 59718
   support@flatearthinc.com

   Auditory Nerve Simulink Model Code
   IhcLowPass.c Function
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
double IhcLowPass(double x, double tdres, double Fc, int n, double gain, int order, double *ihcout)
{
  static double ihc[8],ihcl[8];

  double C,c1LP,c2LP;
  int i,j;

  if (n==0)
  {
      for(i=0; i<(order+1);i++)
      {
          ihc[i] = 0;
          ihcl[i] = 0;
      }
  }

  C = 2.0/tdres;
  c1LP = ( C - TWOPI*Fc ) / ( C + TWOPI*Fc );
  c2LP = TWOPI*Fc / (TWOPI*Fc + C);

  ihc[0] = x*gain;
  for(i=0; i<order;i++)
    ihc[i+1] = c1LP*ihcl[i+1] + c2LP*(ihc[i]+ihcl[i]);
  for(j=0; j<=order;j++) ihcl[j] = ihc[j];
  *ihcout = ihc[order];
}

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{

    double x, tdres, Fc, *ntmp, gain, *ordertmp, *ihcout;
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
    ihcout = mxGetPr(plhs[0]);

    /* call the computational routine */
    IhcLowPass(x, tdres, Fc, n, gain, order, ihcout);
}
