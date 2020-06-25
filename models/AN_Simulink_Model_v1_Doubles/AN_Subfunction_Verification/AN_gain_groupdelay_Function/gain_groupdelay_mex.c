/* gain_groupdelay_mex() - A MATLAB function created to recreate the
   gain_groupdelay function implemented in the AN model C source code

  [wb_gain, grdelay] = gain_groupdelay_mex(tdres, centerfreq, cf, tau)

  The function takes in the binsize, neuron shifted centerfrequency,
  neuron characteristic frequency, and time constant and returns the
  wideband gain and group delay of the control path

  Inputs:
  tdres = binsize, or sampling period
  centerfreq = neuron shifted center frequency according to basilar membrane location
  cf = neuron characteristic frequency
  tau = time constant parameter

  Outputs:
  wb_gain = wideband filter control path gain
  grdelay = control path group delay

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
   gain_groupdelay_mex.c Function
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
void gain_groupdelay_mex(double tdres, double centerfreq, double cf, double tau, double *wb_gain, double *grdelay)
{
  double tmpcos,dtmp2,c1LP,c2LP,tmp1,tmp2;

  tmpcos = cos(TWOPI*(centerfreq-cf)*tdres);
  dtmp2 = tau*2.0/tdres;
  c1LP = (dtmp2-1)/(dtmp2+1);
  c2LP = 1.0/(dtmp2+1);
  tmp1 = 1+c1LP*c1LP-2*c1LP*tmpcos;
  tmp2 = 2*c2LP*c2LP*(1+tmpcos);

  *wb_gain = pow(tmp1/tmp2, 1.0/2.0);

  *grdelay = (0.5-(c1LP*c1LP-c1LP*tmpcos)/(1+c1LP*c1LP-2*c1LP*tmpcos));

}


/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{

    double tdres, centerfreq, cf, tau, *wb_gain, *grdelay;


    /* get the value of the scalar input  */
    tdres = mxGetScalar(prhs[0]);
    centerfreq = mxGetScalar(prhs[1]);
    cf = mxGetScalar(prhs[2]);
    tau = mxGetScalar(prhs[3]);


    /* get pointer to the data in the output */
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    wb_gain = mxGetPr(plhs[0]);
    plhs[1] = mxCreateDoubleMatrix(1,1, mxREAL);
    grdelay = mxGetPr(plhs[1]);


    /* call the computational routine */
    gain_groupdelay_mex(tdres, centerfreq, cf, tau, wb_gain, grdelay);
}
