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

   Copyright 2019 Flat Earth Inc

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

#include "complex.h"

#ifndef TWOPI
#define TWOPI 6.28318530717959
#endif

/* The Nonlinear Log Function */
double NLogarithm(double x, double slope, double asym, double cf)
{
	double corner,strength,xx,splx,asym_t;

    corner    = 80;
    strength  = 20.0e6/pow(10,corner/20);

    xx = log(1.0+strength*fabs(x))*slope;

    if(x<0)
	{
		splx   = 20*log10(-x/20e-6);
		asym_t = asym -(asym-1)/(1+exp(splx/5.0));
		xx = -1/asym_t*xx;
	};

    return(xx);
}

/* The IHC Lowpass Filter  */
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
    double cf;
    double c1_chirp, c1_slope, c1_asym, c1_out;
    double c2_wbf,   c2_slope, c2_asym, c2_out;
    double tdres, Fc, *ntmp, gain, *ordertmp, *ihcout;
    int n, order;

    // C1 Chirp Inputs
    c1_chirp = mxGetScalar(prhs[0]);
    c1_slope = mxGetScalar(prhs[1]);
    c1_asym = mxGetScalar(prhs[2]);

    // C2 WB Inputs
    c2_wbf = mxGetScalar(prhs[3]);
    c2_slope = mxGetScalar(prhs[4]);
    c2_asym = mxGetScalar(prhs[5]);

    // Low Pass Filter
    tdres = mxGetScalar(prhs[6]);
    Fc = mxGetScalar(prhs[7]);
    ntmp = mxGetPr(prhs[8]);
    gain = mxGetScalar(prhs[9]);
    ordertmp = mxGetPr(prhs[10]);


    /* convert to integers */
    n = (int) ntmp[0];
    order = (int) ordertmp[0];

    /* get pointer to the data in the output */
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    ihcout = mxGetPr(plhs[0]);

    c1_out = NLogarithm(c1_chirp, c1_slope, c1_asym, cf);
    c2_out = -NLogarithm(c2_wbf, c2_slope, c2_asym, cf);
    /* call the computational routine */
    IhcLowPass(c1_out + c2_out, tdres, Fc, n, gain, order, ihcout);
}
