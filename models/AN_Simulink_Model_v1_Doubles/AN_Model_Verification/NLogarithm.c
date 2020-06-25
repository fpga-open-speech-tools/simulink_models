/* NLogarithm() - A C function created to isolate the nonlinear Logarithm
   function found in the AN Model C source code model_IHC_BEZ2018 in order to
	 verify Simulink functionality

   vihctmp = NLogarithm(x, slope, asym, cf)

   The filter takes in either the C1 or C2 filtered signal, slope parameter,
	 asymmetry parameter, and characteristic frequency and returns the temporary
	 transduction function output.

   Inputs:
   x = signal in
   slope = function paramter (hard-coded in C source code)
   asym = ratior of positive Max to negative Max for nonlinear function
	 cf = characteristic frequency of neuron

   Outputs:
   vihctmp = temporary transduction function output

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
   NLogarithm.c Function
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
void NLogarithm(double x, double slope, double asym, double cf, double *out)
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

    *out = xx;
}
/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{

    double x, slope, asym, cf, *out;

    /* get the value of the scalar input  */
    x = mxGetScalar(prhs[0]);
    slope = mxGetScalar(prhs[1]);
    asym = mxGetScalar(prhs[2]);
    cf = mxGetScalar(prhs[3]);


    /* get pointer to the data in the output */
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    out = mxGetPr(plhs[0]);


    /* call the computational routine */
    NLogarithm(x, slope, asym, cf, out);
}
