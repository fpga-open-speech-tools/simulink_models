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

#ifndef TWOPI
#define TWOPI 6.28318530717959
#endif


// OHC Boltzman Function
double Boltzman(double x, double asym, double s0, double s1, double x1)
{
    double shift,x0,out1,out;

    shift = 1.0/(1.0+asym);  /* asym is the ratio of positive Max to negative Max*/
    x0    = s0*log((1.0/shift-1)/(1+exp(x1/s1)));
    
    out1 = 1.0/(1.0+exp(-(x-x0)/s0)*(1.0+exp(-(x-x1)/s1)))-shift;
    out = out1/(1-shift);

    return(out);
}  /* output of the nonlinear function, the output is normalized with maximum value of 1 */

// OHC Lowpass Filter
double OhcLowPass(double x, double tdres, double Fc, int n, double gain, int order)
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
  for(j=0; j<=order;j++) ohcl[j] = ohc[j];
  return(ohc[order]);
}

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

    double x, asym, s0, s1, x1, ohc_boltzman;
    double ohc_lowpass, tdres, Fc, *ntmp, gain, *ordertmp;
    int n, order;
    double taumin, taumax, *out;

    // OHC Boltzman Filter
    x = mxGetScalar(prhs[0]);
    asym = mxGetScalar(prhs[1]);
    s0= mxGetScalar(prhs[2]);
    s1 = mxGetScalar(prhs[3]);
    x1 = mxGetScalar(prhs[4]);

    // OHC Lowpass Filter
    tdres = mxGetScalar(prhs[5]);
    Fc = mxGetScalar(prhs[6]);
    ntmp = mxGetPr(prhs[7]);
    n = (int) ntmp[0];
    gain = mxGetScalar(prhs[8]);
    ordertmp = mxGetPr(prhs[9]);
    order = (int) ordertmp[0];

    // OHC Nonlinear Filter
    taumin = mxGetScalar(prhs[10]);
    taumax = mxGetScalar(prhs[11]);

    /* get pointer to the data in the output */
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    out = mxGetPr(plhs[0]);


    /* call the computational routine */
    ohc_boltzman = Boltzman(x, asym, s0, s1, x1);
    ohc_lowpass  = OhcLowPass(ohc_boltzman, tdres, Fc, n, gain, order);
    NLafterohc(ohc_lowpass, taumin, taumax, asym, out);
}
