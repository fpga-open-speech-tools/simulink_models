/* C2ChirpFilt() - A C function created to isolate the C2 Wideband Filter
   function found in the AN Model C source code model_IHC_BEZ2018 in order to
	 verify Simulink functionality

   C2filterout = C2ChirpFilt(xx, tdres, cf, n, taumax, fcohc)

   The filter takes in either the signal output from the Middle Ear Filter,
   binsize, neuron characteristic frequency, sample number, max time constant,
   and impairment parameter and returns the C2 filter output signal.

   Inputs:
   xx = signal in (from ME filter)
   tdres = binsize, or sampling period
   cf = characteristic frequency of neuron
   n = sample number
   taumax = max time constant value
   fcohc = function specific parameter given as 1/ratiobm in source code

   Outputs:
   C2filterout = C2 filter output signal

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
   C2ChirpFilt.c Function
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
void C2ChirpFilt(double xx, double tdres, double cf, int n, double taumax, double fcohc, double *C2filterout)
{
    static double C2gain_norm, C2initphase;
    static double C2input[12][4];  static double C2output[12][4];

	double ipw, ipb, rpa, pzero, rzero;

	double sigma0,fs_bilinear,CF,norm_gain,phase,c2filterout;
	int    i,r,order_of_pole,half_order_pole,order_of_zero;
	double temp, dy, preal, pimg;

	COMPLEX p[11];

    /*================ setup the locations of poles and zeros =======*/

	  sigma0 = 1/taumax;
	  ipw    = 1.01*cf*TWOPI-50;
      ipb    = 0.2343*TWOPI*cf-1104;
	  rpa    = pow(10, log10(cf)*0.9 + 0.55)+ 2000;
	  pzero  = pow(10,log10(cf)*0.7+1.6)+500;

	/*===============================================================*/

     order_of_pole    = 10;
     half_order_pole  = order_of_pole/2;
     order_of_zero    = half_order_pole;

	 fs_bilinear = TWOPI*cf/tan(TWOPI*cf*tdres/2);
     rzero       = -pzero;
	 CF          = TWOPI*cf;

    if (n==0)
    {
	p[1].x = -sigma0;

    p[1].y = ipw;

	p[5].x = p[1].x - rpa; p[5].y = p[1].y - ipb;

    p[3].x = (p[1].x + p[5].x) * 0.5; p[3].y = (p[1].y + p[5].y) * 0.5;

    p[2] = compconj(p[1]); p[4] = compconj(p[3]); p[6] = compconj(p[5]);

    p[7] = p[1]; p[8] = p[2]; p[9] = p[5]; p[10]= p[6];

	   C2initphase = 0.0;
       for (i=1;i<=half_order_pole;i++)
	   {
           preal     = p[i*2-1].x;
		   pimg      = p[i*2-1].y;
	       C2initphase = C2initphase + atan(CF/(-rzero))-atan((CF-pimg)/(-preal))-atan((CF+pimg)/(-preal));
	   };

	/*===================== Initialize C2input & C2output =====================*/

      for (i=1;i<=(half_order_pole+1);i++)
      {
		   C2input[i][3] = 0;
		   C2input[i][2] = 0;
		   C2input[i][1] = 0;
		   C2output[i][3] = 0;
		   C2output[i][2] = 0;
		   C2output[i][1] = 0;
      }

    /*===================== normalize the gain =====================*/

     C2gain_norm = 1.0;
     for (r=1; r<=order_of_pole; r++)
		   C2gain_norm = C2gain_norm*(pow((CF - p[r].y),2) + p[r].x*p[r].x);
    };

    norm_gain= sqrt(C2gain_norm)/pow(sqrt(CF*CF+rzero*rzero),order_of_zero);

	p[1].x = -sigma0*fcohc;

	if (p[1].x>0.0) mexErrMsgTxt("The system becomes unstable.\n");

	p[1].y = ipw;

	p[5].x = p[1].x - rpa; p[5].y = p[1].y - ipb;

    p[3].x = (p[1].x + p[5].x) * 0.5; p[3].y = (p[1].y + p[5].y) * 0.5;

    p[2] = compconj(p[1]); p[4] = compconj(p[3]); p[6] = compconj(p[5]);

    p[7] = p[1]; p[8] = p[2]; p[9] = p[5]; p[10]= p[6];

    phase = 0.0;
    for (i=1;i<=half_order_pole;i++)
    {
           preal = p[i*2-1].x;
		   pimg  = p[i*2-1].y;
	       phase = phase-atan((CF-pimg)/(-preal))-atan((CF+pimg)/(-preal));

	};

	rzero = -CF/tan((C2initphase-phase)/order_of_zero);
    if (rzero>0.0) mexErrMsgTxt("The zeros are in the right-hand plane.\n");
   /*%==================================================  */
   /*%      time loop begins here                         */
   /*%==================================================  */

       C2input[1][3]=C2input[1][2];
	   C2input[1][2]=C2input[1][1];
	   C2input[1][1]= xx;

      for (i=1;i<=half_order_pole;i++)
      {
           preal = p[i*2-1].x;
		   pimg  = p[i*2-1].y;

           temp  = pow((fs_bilinear-preal),2)+ pow(pimg,2);

           /*dy = (input[i][1] + (1-(fs_bilinear+rzero)/(fs_bilinear-rzero))*input[i][2]
                                 - (fs_bilinear+rzero)/(fs_bilinear-rzero)*input[i][3] );
           dy = dy+2*output[i][1]*(fs_bilinear*fs_bilinear-preal*preal-pimg*pimg);

           dy = dy-output[i][2]*((fs_bilinear+preal)*(fs_bilinear+preal)+pimg*pimg);*/

	      dy = C2input[i][1]*(fs_bilinear-rzero) - 2*rzero*C2input[i][2] - (fs_bilinear+rzero)*C2input[i][3]
                 +2*C2output[i][1]*(fs_bilinear*fs_bilinear-preal*preal-pimg*pimg)
			     -C2output[i][2]*((fs_bilinear+preal)*(fs_bilinear+preal)+pimg*pimg);

		   dy = dy/temp;

		   C2input[i+1][3] = C2output[i][2];
		   C2input[i+1][2] = C2output[i][1];
		   C2input[i+1][1] = dy;

		   C2output[i][2] = C2output[i][1];
		   C2output[i][1] = dy;

       };

	  dy = C2output[half_order_pole][1]*norm_gain;
	  *C2filterout= dy/4.0;
}

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{

    double xx, tdres, cf, *ntmp, taumax, fcohc, *C2filterout;
    int n;

    /* get the value of the scalar input  */
    xx = mxGetScalar(prhs[0]);
    tdres = mxGetScalar(prhs[1]);
    cf = mxGetScalar(prhs[2]);
    ntmp = mxGetPr(prhs[3]);
    taumax = mxGetScalar(prhs[4]);
    fcohc = mxGetScalar(prhs[5]);


    /* convert to integer */
    n = (int) ntmp[0];

    /* get pointer to the data in the output */
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    C2filterout = mxGetPr(plhs[0]);

    /* call the computational routine */
    C2ChirpFilt(xx, tdres, cf, n, taumax, fcohc, C2filterout);
}
