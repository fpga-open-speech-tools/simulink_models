/* Boltzman() - A C function created to isolate the nonlinear Boltzman
   function found in the AN Model C source code model_IHC_BEZ2018 in order to
	 verify Simulink functionality

   out = Boltzman(x, asym, s0, s1, x1)

   The filter takes in the wideband gammatone output signal, asymmetry parameter,
	 and s0, s1, and x1 parameters and returns the OHC nonlinear Boltzman output.

   Inputs:
   x = signal in
   asym = ratio of positive Max to negative Max for nonlinear function
	 s0 = function specific parameter
   s1 = function specific parameter
   x1 = function specific parameter

   Outputs:
   out = OHC nonlinear Boltzman function output

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
   Boltzman.c Function
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
void Boltzman(double x, double asym, double s0, double s1, double x1, double *out)
  {
	double shift,x0,out1;

    shift = 1.0/(1.0+asym);  /* asym is the ratio of positive Max to negative Max*/
    x0    = s0*log((1.0/shift-1)/(1+exp(x1/s1)));

    out1 = 1.0/(1.0+exp(-(x-x0)/s0)*(1.0+exp(-(x-x1)/s1)))-shift;
	*out = out1/(1-shift);
}
/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{

    double x, asym, s0, s1, x1, *out;

    /* get the value of the scalar input  */
    x = mxGetScalar(prhs[0]);
    asym = mxGetScalar(prhs[1]);
    s0= mxGetScalar(prhs[2]);
    s1 = mxGetScalar(prhs[3]);
    x1 = mxGetScalar(prhs[4]);


    /* get pointer to the data in the output */
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    out = mxGetPr(plhs[0]);


    /* call the computational routine */
    Boltzman(x, asym, s0, s1, x1, out);
}
