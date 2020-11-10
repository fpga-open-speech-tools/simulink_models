/* C1ChirpFilt() - A C function created to isolate the C1 Chirp Filter
   function found in the AN Model C source code model_IHC_BEZ2018 in order to
	 verify Simulink functionality

   C1filterout = C2ChirpFilt(x, tdres, cf, n, taumax, rsigma)

   The filter takes in either the signal output from the Middle Ear Filter,
   binsize, neuron characteristic frequency, sample number, max time constant,
   and pole-shifting parameter and returns the C2 filter output signal.

   Inputs:
   x = signal in (from ME filter)
   tdres = binsize, or sampling period
   cf = characteristic frequency of neuron
   n = sample number
   taumax = max time constant value
   rsigma = pole-shifting parameter, updated every iteration in C source code

   Outputs:
   C1filterout = C1 filter output signal

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
   C1ChirpFilt.c Function
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

#include "complex.h"

#ifndef TWOPI
#define TWOPI 6.28318530717959
#endif

/* The computational function routine */
void C1ChirpFilt(double tdres, double cf, int n, double taumax, double rsigma, double *rzero_out, double *temp_1_out, double *temp_2_out, double *temp_3_out, double *temp_4_out, double *temp_5_out, double *fs_bl_out, 
                 double *c1_i1_coef1_out, double *c1_i1_coef2_out, double *c1_i1_coef3_out, double *c1_i1_coef5_out, double *c1_i1_coef6_out, 
                 double *c1_i2_coef1_out, double *c1_i2_coef2_out, double *c1_i2_coef3_out, double *c1_i2_coef5_out, double *c1_i2_coef6_out, 
                 double *c1_i3_coef1_out, double *c1_i3_coef2_out, double *c1_i3_coef3_out, double *c1_i3_coef5_out, double *c1_i3_coef6_out, 
                 double *c1_i4_coef1_out, double *c1_i4_coef2_out, double *c1_i4_coef3_out, double *c1_i4_coef5_out, double *c1_i4_coef6_out, 
                 double *c1_i5_coef1_out, double *c1_i5_coef2_out, double *c1_i5_coef3_out, double *c1_i5_coef5_out, double *c1_i5_coef6_out)
{
    static double C1gain_norm, C1initphase;
    static double C1input[12][4];  static double C1output[12][4];

	double ipw, ipb, rpa, pzero, rzero;
    double c1_c1, c1_c2, c1_c3, c1_c5, c1_c6;

	double sigma0,fs_bilinear,CF,norm_gain,phase,c1filterout;
	int    i,r,order_of_pole,half_order_pole,order_of_zero;
	double temp, dy, preal, pimg;

	COMPLEX p[11];
    /* Defining initial locations of the poles and zeros */
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
     *fs_bl_out = fs_bilinear;
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

	   C1initphase = 0.0;
       for (i=1;i<=half_order_pole;i++)
	   {
           preal     = p[i*2-1].x;
		   pimg      = p[i*2-1].y;
	       C1initphase = C1initphase + atan(CF/(-rzero))-atan((CF-pimg)/(-preal))-atan((CF+pimg)/(-preal));
	   };

    /*===================== normalize the gain =====================*/

     C1gain_norm = 1.0;
     for (r=1; r<=order_of_pole; r++)
		   C1gain_norm = C1gain_norm*(pow((CF - p[r].y),2) + p[r].x*p[r].x);
    };

    norm_gain= sqrt(C1gain_norm)/pow(sqrt(CF*CF+rzero*rzero),order_of_zero);

	p[1].x = -sigma0 - rsigma;

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

	rzero = -CF/tan((C1initphase-phase)/order_of_zero);
    *rzero_out = rzero;

    if (rzero>0.0) mexErrMsgTxt("The zeros are in the right-hand plane.\n");
   /*%==================================================  */
   /*each loop below is for a pair of poles and one zero */
   /*%      time loop begins here                         */
   /*%==================================================  */

      for (i=1;i<=half_order_pole;i++)
      {
            preal = p[i*2-1].x;
		    pimg  = p[i*2-1].y;

            temp  = pow((fs_bilinear-preal),2)+ pow(pimg,2);

            c1_c1 = (fs_bilinear-rzero)/temp;
            c1_c2 = (-2*rzero)/temp;
            c1_c3 = (-(fs_bilinear+rzero))/temp;
            c1_c5 = (2*(fs_bilinear*fs_bilinear-preal*preal-pimg*pimg))/temp;
            c1_c6 = (-((fs_bilinear+preal)*(fs_bilinear+preal)+pimg*pimg))/temp;

            if(i == 1)
           {
               *temp_1_out   = temp;
               *c1_i1_coef1_out  = c1_c1;
               *c1_i1_coef2_out  = c1_c2;
               *c1_i1_coef3_out  = c1_c3;
               *c1_i1_coef5_out  = c1_c5;
               *c1_i1_coef6_out  = c1_c6;
           }
           else if(i == 2)
           {
               *temp_2_out = temp;
               *c1_i2_coef1_out  = c1_c1;
               *c1_i2_coef2_out  = c1_c2;
               *c1_i2_coef3_out  = c1_c3;
               *c1_i2_coef5_out  = c1_c5;
               *c1_i2_coef6_out  = c1_c6;
           }
           else if(i == 3)
           {
               *temp_3_out = temp;
               *c1_i3_coef1_out  = c1_c1;
               *c1_i3_coef2_out  = c1_c2;
               *c1_i3_coef3_out  = c1_c3;
               *c1_i3_coef5_out  = c1_c5;
               *c1_i3_coef6_out  = c1_c6;
           }
           else if(i == 4)
           {
               *temp_4_out = temp;
               *c1_i4_coef1_out  = c1_c1;
               *c1_i4_coef2_out  = c1_c2;
               *c1_i4_coef3_out  = c1_c3;
               *c1_i4_coef5_out  = c1_c5;
               *c1_i4_coef6_out  = c1_c6;
           }
           else if(i == 5)
           {
               *temp_5_out = temp;
               *c1_i5_coef1_out  = c1_c1;
               *c1_i5_coef2_out  = c1_c2;
               *c1_i5_coef3_out  = c1_c3;
               *c1_i5_coef5_out  = c1_c5;
               *c1_i5_coef6_out  = c1_c6;
           }
       }

}

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{

    double tdres, cf, *ntmp, taumax, rsigma;
    double *rzero_out, *temp_1_out, *temp_2_out, *temp_3_out, *temp_4_out, *temp_5_out, *fs_bilinear_out;
    double *c1_i1_coef1_out, *c1_i1_coef2_out, *c1_i1_coef3_out, *c1_i1_coef5_out, *c1_i1_coef6_out;
    double *c1_i2_coef1_out, *c1_i2_coef2_out, *c1_i2_coef3_out, *c1_i2_coef5_out, *c1_i2_coef6_out;
    double *c1_i3_coef1_out, *c1_i3_coef2_out, *c1_i3_coef3_out, *c1_i3_coef5_out, *c1_i3_coef6_out;
    double *c1_i4_coef1_out, *c1_i4_coef2_out, *c1_i4_coef3_out, *c1_i4_coef5_out, *c1_i4_coef6_out;
    double *c1_i5_coef1_out, *c1_i5_coef2_out, *c1_i5_coef3_out, *c1_i5_coef5_out, *c1_i5_coef6_out;
    int n;

    /* get the value of the scalar input  */
    tdres = mxGetScalar(prhs[0]);
    cf = mxGetScalar(prhs[1]);
    ntmp = mxGetPr(prhs[2]);
    taumax = mxGetScalar(prhs[3]);
    rsigma = mxGetScalar(prhs[4]);

    /* convert to integer */
    n = (int) ntmp[0];

    /* get pointer to the data in the output */
    plhs[0]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    rzero_out   = mxGetPr(plhs[0]);
    plhs[1]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    temp_1_out  = mxGetPr(plhs[1]);
    plhs[2]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    temp_2_out  = mxGetPr(plhs[2]);
    plhs[3]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    temp_3_out  = mxGetPr(plhs[3]);
    plhs[4]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    temp_4_out  = mxGetPr(plhs[4]);
    plhs[5]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    temp_5_out  = mxGetPr(plhs[5]);
    plhs[6]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    fs_bilinear_out  = mxGetPr(plhs[6]);
    plhs[7]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i1_coef1_out  = mxGetPr(plhs[7]);
    plhs[8]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i1_coef2_out  = mxGetPr(plhs[8]);
    plhs[9]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i1_coef3_out  = mxGetPr(plhs[9]);
    plhs[10]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i1_coef5_out  = mxGetPr(plhs[10]);
    plhs[11]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i1_coef6_out  = mxGetPr(plhs[11]);
    
    plhs[12]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i2_coef1_out  = mxGetPr(plhs[12]);
    plhs[13]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i2_coef2_out  = mxGetPr(plhs[13]);
    plhs[14]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i2_coef3_out  = mxGetPr(plhs[14]);
    plhs[15]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i2_coef5_out  = mxGetPr(plhs[15]);
    plhs[16]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i2_coef6_out  = mxGetPr(plhs[16]);
    
    plhs[17]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i3_coef1_out  = mxGetPr(plhs[17]);
    plhs[18]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i3_coef2_out  = mxGetPr(plhs[18]);
    plhs[19]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i3_coef3_out  = mxGetPr(plhs[19]);
    plhs[20]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i3_coef5_out  = mxGetPr(plhs[20]);
    plhs[21]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i3_coef6_out  = mxGetPr(plhs[21]);
    
    plhs[22]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i4_coef1_out  = mxGetPr(plhs[22]);
    plhs[23]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i4_coef2_out  = mxGetPr(plhs[23]);
    plhs[24]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i4_coef3_out  = mxGetPr(plhs[24]);
    plhs[25]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i4_coef5_out  = mxGetPr(plhs[25]);
    plhs[26]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i4_coef6_out  = mxGetPr(plhs[26]);
    
    plhs[27]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i5_coef1_out  = mxGetPr(plhs[27]);
    plhs[28]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i5_coef2_out  = mxGetPr(plhs[28]);
    plhs[29]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i5_coef3_out  = mxGetPr(plhs[29]);
    plhs[30]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i5_coef5_out  = mxGetPr(plhs[30]);
    plhs[31]     = mxCreateDoubleMatrix(1, 1, mxREAL);
    c1_i5_coef6_out  = mxGetPr(plhs[31]);

    /* call the computational routine */
    C1ChirpFilt(tdres, cf, n, taumax, rsigma, rzero_out, temp_1_out, temp_2_out, temp_3_out, temp_4_out, temp_5_out, fs_bilinear_out, c1_i1_coef1_out, c1_i1_coef2_out, c1_i1_coef3_out, c1_i1_coef5_out, c1_i1_coef6_out, 
                                                                                                                                      c1_i2_coef1_out, c1_i2_coef2_out, c1_i2_coef3_out, c1_i2_coef5_out, c1_i2_coef6_out,
                                                                                                                                      c1_i3_coef1_out, c1_i3_coef2_out, c1_i3_coef3_out, c1_i3_coef5_out, c1_i3_coef6_out,
                                                                                                                                      c1_i4_coef1_out, c1_i4_coef2_out, c1_i4_coef3_out, c1_i4_coef5_out, c1_i4_coef6_out,
                                                                                                                                      c1_i5_coef1_out, c1_i5_coef2_out, c1_i5_coef3_out, c1_i5_coef5_out, c1_i5_coef6_out);
}
