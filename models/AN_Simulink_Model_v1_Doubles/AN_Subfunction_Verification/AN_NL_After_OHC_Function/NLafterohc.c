/* NLafterohc() - A C function created to isolate the nonlinear After OHC
   function found in the AN Model C source code model_IHC_BEZ2018 in order to
	 verify Simulink functionality

   out = NLafterohc(x, taumin, taumax, asym)

   The function takes in the lowpass filter OHC output signal, max and min time
	 constant values, and an asymmetry parameter and returns a time-varying
	 constant for the C1 filter

   Inputs:
   x = signal in
	 taumin = minimum time constant parameter
	 taumax = maximum time constant parameter
   asym = ratio of positive Max to negative Max for nonlinear function

   Outputs:
   out = time-varying constant for C1 filter

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
   NLafterohc.c Function
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
double NLafterohc(double x,double taumin, double taumax, double asym, double *out)
{
	double R,dc,R1,s0,x1,output,minR;

	minR = 0.05;
    R  = taumin/taumax;

	if(R<minR) minR = 0.5*R;
    else       minR = minR;

    dc = (asym-1)/(asym+1.0)/2.0-minR;
    R1 = R-minR;

    /* This is for new nonlinearity */
    s0 = -dc/log(R1/(1-minR));

    x1  = fabs(x);
    output = taumax*(minR+(1.0-minR)*exp(-x1/s0));
	if (output<taumin) output = taumin;
    if (output>taumax) output = taumax;

    *out = output;
}
/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{

    double x, taumin, taumax, asym, *out;

    /* get the value of the scalar input  */
    x = mxGetScalar(prhs[0]);
    taumin = mxGetScalar(prhs[1]);
    taumax = mxGetScalar(prhs[2]);
    asym = mxGetScalar(prhs[3]);


    /* get pointer to the data in the output */
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    out = mxGetPr(plhs[0]);


    /* call the computational routine */
    NLafterohc(x, taumin, taumax, asym, out);
}
