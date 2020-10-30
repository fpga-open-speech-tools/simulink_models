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


double C1ChirpFilt(double x, double tdres, double cf, int n, double taumax, double rsigma)
{
  static double C1gain_norm, C1initphase; 
  static double C1input[12][4], C1output[12][4];

  double ipw, ipb, rpa, pzero, rzero;
	double sigma0,fs_bilinear,CF,norm_gain,phase,c1filterout;
	int i,r,order_of_pole,half_order_pole,order_of_zero;
	double temp, dy, preal, pimg;

	COMPLEX p[11]; 
	
	/* Defining initial locations of the poles and zeros */
	/*======== setup the locations of poles and zeros =======*/
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

    p[2]   = compconj(p[1]);    p[4] = compconj(p[3]); p[6] = compconj(p[5]);

    p[7]   = p[1]; p[8] = p[2]; p[9] = p[5]; p[10]= p[6];

	   C1initphase = 0.0;
       for (i=1;i<=half_order_pole;i++)          
	   {
           preal     = p[i*2-1].x;
		   pimg      = p[i*2-1].y;
	       C1initphase = C1initphase + atan(CF/(-rzero))-atan((CF-pimg)/(-preal))-atan((CF+pimg)/(-preal));
	   };

	/*===================== Initialize C1input & C1output =====================*/

      for (i=1;i<=(half_order_pole+1);i++)          
      {
		   C1input[i][3] = 0; 
		   C1input[i][2] = 0; 
		   C1input[i][1] = 0;
		   C1output[i][3] = 0; 
		   C1output[i][2] = 0; 
		   C1output[i][1] = 0;
      }

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

    if (rzero>0.0) mexErrMsgTxt("The zeros are in the right-half plane.\n");
	 
   /*%==================================================  */
	 /*each loop below is for a pair of poles and one zero */
   /*%      time loop begins here                         */
   /*%==================================================  */
 
       C1input[1][3]=C1input[1][2]; 
	   C1input[1][2]=C1input[1][1]; 
	   C1input[1][1]= x;

       for (i=1;i<=half_order_pole;i++)          
       {
          preal = p[i*2-1].x;
		      pimg  = p[i*2-1].y;
		  	   
          temp  = pow((fs_bilinear-preal),2)+ pow(pimg,2);
		   

          /*dy = (input[i][1] + (1-(fs_bilinear+rzero)/(fs_bilinear-rzero))*input[i][2]
                                - (fs_bilinear+rzero)/(fs_bilinear-rzero)*input[i][3] );
          dy = dy+2*output[i][1]*(fs_bilinear*fs_bilinear-preal*preal-pimg*pimg);

          dy = dy-output[i][2]*((fs_bilinear+preal)*(fs_bilinear+preal)+pimg*pimg);*/
		   
	        dy = C1input[i][1]*(fs_bilinear-rzero) - 2*rzero*C1input[i][2] - (fs_bilinear+rzero)*C1input[i][3]
                +2*C1output[i][1]*(fs_bilinear*fs_bilinear-preal*preal-pimg*pimg)
			          -C1output[i][2]*((fs_bilinear+preal)*(fs_bilinear+preal)+pimg*pimg);

        dy = dy/temp;

        C1input[i+1][3] = C1output[i][2]; 
        C1input[i+1][2] = C1output[i][1]; 
        C1input[i+1][1] = dy;

        C1output[i][2] = C1output[i][1]; 
        C1output[i][1] = dy;
       }

	   dy = C1output[half_order_pole][1]*norm_gain;  /* don't forget the gain term */
	   c1filterout= dy/4.0;   /* signal path output is divided by 4 to give correct C1 filter gain */
	                   
     return (c1filterout);
}

double C2ChirpFilt(double xx, double tdres,double cf, int n, double taumax, double fcohc)
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
	  c2filterout= dy/4.0;
	  
	  return (c2filterout); 
}   

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
double IhcLowPass(double x, double y, double tdres, double Fc, int n, double gain, int order, double *ihcout)
{
  static double ihc[8],ihcl[8];

  double C,c1LP,c2LP, temp;
  int i,j;

  temp = x - y;

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

  ihc[0] = temp*gain;
  for(i=0; i<order;i++)
    ihc[i+1] = c1LP*ihcl[i+1] + c2LP*(ihc[i]+ihcl[i]);
  for(j=0; j<=order;j++) ihcl[j] = ihc[j];
  *ihcout = ihc[order];
}

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{ 
    double mef_out;
    double tdres, cf, *ntmp, taumax, rsigma, c1_chirp;
    double taumaxc2, fcohcc2, c2_wbf;
    double c1_slope, c1_asym, c1_out;
    double c2_slope, c2_asym, c2_out;
    double Fc, gain, *ordertmp, *ihcout;
    int n, order;

    // Middle Ear Output
    mef_out = mxGetScalar(prhs[0]);

    // C1 Chirp Filter
    tdres  = mxGetScalar(prhs[1]);
    cf     = mxGetScalar(prhs[2]);
    ntmp   = mxGetPr(prhs[3]);
    n      = (int) ntmp[0];
    taumax = mxGetScalar(prhs[4]);
    rsigma = mxGetScalar(prhs[5]);

    // C2 Wideband Filter
    taumaxc2 = mxGetScalar(prhs[6]);
    fcohcc2 = mxGetScalar(prhs[7]);

    // C1 Chirp NL Log Inputs
    c1_slope = mxGetScalar(prhs[8]);
    c1_asym = mxGetScalar(prhs[9]);

    // C2 WB Inputs
    c2_slope = mxGetScalar(prhs[10]);
    c2_asym = mxGetScalar(prhs[11]);

    // Low Pass Filter
    Fc = mxGetScalar(prhs[12]);
    gain = mxGetScalar(prhs[13]);
    ordertmp = mxGetPr(prhs[14]);

    /* convert to integers */
    order = (int) ordertmp[0];

    /* get pointer to the data in the output */
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    ihcout = mxGetPr(plhs[0]);

    c1_chirp = C1ChirpFilt(mef_out, tdres, cf, n, taumax, rsigma);
    c2_wbf   = C2ChirpFilt(mef_out, tdres, cf, n, taumaxc2, fcohcc2);

    c1_out = NLogarithm(c1_chirp, c1_slope, c1_asym, cf);
    c2_out = NLogarithm(c2_wbf, c2_slope, c2_asym, cf);
    /* call the computational routine */
    IhcLowPass(c1_out, c2_out, tdres, Fc, n, gain, order, ihcout);
}