/* Get_tauwb_mex() - A MATLAB function created to recreate the Get_tauwb
  function implemented in the AN model C source code

  [taumax, taumin] = Get_tauwb_mex(cf, species, order)

  The function takes in the neuron characteristic frequency, order, and species
  and returns a maximum and minimum time constant value.

  Inputs:
  cf = neuron characteristic frequency
  species = species number, specified as 1 for cat, 2 or 3 for human
  order = constant declared in source code (no explanation given)

   Outputs:
   taumax = time constant maximum value
   taumin = time constant minimum value

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
   Get_tauwb_mex.c Function
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
double Get_tauwb(double cf, int species, int order, double *taumax, double *taumin)
{
  double Q10,bw,gain,ratio;

  if(species==1) gain = 52.0/2.0*(tanh(2.2*log10(cf/0.6e3)+0.15)+1.0); /* for cat */
  if(species>1) gain = 52.0/2.0*(tanh(2.2*log10(cf/0.6e3)+0.15)+1.0); /* for human */
  /*gain = 52/2*(tanh(2.2*log10(cf/1e3)+0.15)+1);*/ /* older values */

  if(gain>60.0) gain = 60.0;
  if(gain<15.0) gain = 15.0;

  ratio = pow(10,(-gain/(20.0*order)));       /* ratio of TauMin/TauMax according to the gain, order */
  if (species==1) /* cat Q10 values */
  {
    Q10 = pow(10,0.4708*log10(cf/1e3)+0.4664);
  }
  if (species==2) /* human Q10 values from Shera et al. (PNAS 2002) */
  {
    Q10 = pow((cf/1000),0.3)*12.7*0.505+0.2085;
  }
  if (species==3) /* human Q10 values from Glasberg & Moore (Hear. Res. 1990) */
  {
    Q10 = cf/24.7/(4.37*(cf/1000)+1)*0.505+0.2085;
  }
  bw     = cf/Q10;
  taumax[0] = 2.0/(TWOPI*bw);

  taumin[0]   = taumax[0]*ratio;

}

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{

    double cf, species, *ordertmp, *taumax, *taumin;
    int order;

    /* get the value of the scalar input  */
    cf = mxGetScalar(prhs[0]);
    species = mxGetScalar(prhs[1]);
    ordertmp= mxGetPr(prhs[2]);

    /* convert to integers */
    order = (int) ordertmp[0];

    /* get pointer to the data in the output */
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    taumax = mxGetPr(plhs[0]);
    plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
    taumin = mxGetPr(plhs[1]);

    /* call the computational routine */
    Get_tauwb(cf, species, order, taumax, taumin);
}
