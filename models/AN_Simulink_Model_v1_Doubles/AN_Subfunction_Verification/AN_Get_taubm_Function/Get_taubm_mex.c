/* Get_taubm_mex() - A MATLAB function created to recreate the Get_taubm
  function implemented in the AN model C source code

  [bmTaumax, bmTaumin, ratio] = Get_taubm_mex(cf, species, taumax)

  The function takes in the neuron characteristic frequency, species
  number, and maximum time constant value and returns a new maximum time
  constant value, a time constant minimum value, and a ratio parameter.

  Inputs:
  cf = neuron characteristic frequency
  species = species number, specified as 1 for cat, 2 or 3 for human
  taumax = maximum time constant value

   Outputs:
   bmTaumax = new time constant maximum value
   bmTaumin = time constant minimum value
   ratio = ratio of upper to lower time constant bounds

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
   Get_taubm_mex.c Function
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
double Get_taubm_mex(double cf, int species, double taumax,double *bmTaumax,double *bmTaumin, double *ratio)
{
  double gain,factor,bwfactor;

  if(species==1) gain = 52.0/2.0*(tanh(2.2*log10(cf/0.6e3)+0.15)+1.0); /* for cat */
  if(species>1) gain = 52.0/2.0*(tanh(2.2*log10(cf/0.6e3)+0.15)+1.0); /* for human */
  /*gain = 52/2*(tanh(2.2*log10(cf/1e3)+0.15)+1);*/ /* older values */


  if(gain>60.0) gain = 60.0;
  if(gain<15.0) gain = 15.0;

  bwfactor = 0.7;
  factor   = 2.5;

  ratio[0]  = pow(10,(-gain/(20.0*factor)));

  bmTaumax[0] = taumax/bwfactor;
  bmTaumin[0] = bmTaumax[0]*ratio[0];

}

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{

    double cf, species, taumax, *bmTaumax, *bmTaumin, *ratio;

    /* get the value of the scalar input  */
    cf = mxGetScalar(prhs[0]);
    species = mxGetScalar(prhs[1]);
    taumax = mxGetScalar(prhs[2]);


    /* get pointer to the data in the output */
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    bmTaumax = mxGetPr(plhs[0]);
    plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
    bmTaumin = mxGetPr(plhs[1]);
    plhs[2] = mxCreateDoubleMatrix(1, 1, mxREAL);
    ratio = mxGetPr(plhs[2]);

    /* call the computational routine */
    Get_taubm_mex(cf, species, taumax, bmTaumax, bmTaumin, ratio);
}
