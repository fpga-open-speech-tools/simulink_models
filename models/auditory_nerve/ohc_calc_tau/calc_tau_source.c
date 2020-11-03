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

   Copyright 2020 Audio Logic Inc

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
   INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
   PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
   FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
   ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

   Dylan Wickham
   Audio Logic Inc
   985 Technology Blvd
   Bozeman, MT 59718
   support@flatearthinc.com


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


/** Get TauMax, TauMin for the tuning filter. The TauMax is determined by the bandwidth/Q10
    of the tuning filter at low level. The TauMin is determined by the gain change between high
    and low level */

double Get_tauwb(double cf, int species, int order, double *taumax,double *taumin)
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
  
  return 0;
}
/* -------------------------------------------------------------------------------------------- */
double Get_taubm(double cf, int species, double taumax,double *bmTaumax,double *bmTaumin, double *ratio)
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
  return 0;
}

/* -------------------------------------------------------------------------------------------- */
/** Calculate the gain and group delay for the Control path Filter */

double gain_groupdelay(double tdres,double centerfreq, double cf, double tau,int *grdelay)
{ 
  double tmpcos,dtmp2,c1LP,c2LP,tmp1,tmp2,wb_gain, test;
  //mexPrintf("I am in411 \n");
  tmpcos = cos(TWOPI*(centerfreq-cf)*tdres);
  dtmp2 = tau*2.0/tdres;
  c1LP = (dtmp2-1)/(dtmp2+1);
  //mexPrintf("I am in412 \n");
  c2LP = 1.0/(dtmp2+1);
  tmp1 = 1+c1LP*c1LP-2*c1LP*tmpcos;
  tmp2 = 2*c2LP*c2LP*(1+tmpcos);
  //mexPrintf("I am in413 \n");
  wb_gain = pow(tmp1/tmp2, 1.0/2.0);
  //mexPrintf("I am in4131 \n");
  *grdelay = (int)floor((0.5-(c1LP*c1LP-c1LP*tmpcos)/(1+c1LP*c1LP-2*c1LP*tmpcos)));
  //mexPrintf("I am in \n");
  return(wb_gain);
}

void calc_tau(double tdres, double cf, double centerfreq, double tmptauc1, int *grdelay, double *rsigma, double *tauc1, double *tauwb, double *wbgain){
    double Taumin[1],Taumax[1],bmTaumin[1],bmTaumax[1],ratiobm[1],lasttmpgain,ohcasym,ihcasym,delay, wb_gain, tmpgain[1], TauWBMax, TauWBMin, cohc, fcohc, bmTaubm, taubm, ratiowb;
	
    int bmorder = 3, species = 2, grd, wborder;

    cohc = 1;
    //mexPrintf("I am in \n");
    /*====== Parameters for the control-path wideband filter =======*/
    // Set Taumax and Taumin
    Get_tauwb(cf,species,bmorder,Taumax,Taumin);
    taubm   = cohc*(Taumax[0]-Taumin[0])+Taumin[0];
	  ratiowb = Taumin[0]/Taumax[0];
    //mexPrintf("I am in2 \n");
    /*====== Parameters for the signal-path C1 filter ======*/
	  Get_taubm(cf,species,Taumax[0],bmTaumax,bmTaumin,ratiobm);
	  bmTaubm  = cohc*(bmTaumax[0]-bmTaumin[0])+bmTaumin[0];
	  fcohc    = bmTaumax[0]/bmTaubm;
    //mexPrintf("I am in3 \n");
    /*====== Parameters for the control-path wideband filter =======*/
	  wborder  = 3;
    TauWBMax = Taumin[0]+0.2*(Taumax[0]-Taumin[0]);
	  TauWBMin = TauWBMax/Taumax[0]*Taumin[0];
    //mexPrintf("I am in4 \n");
    //mexPrintf("I am in42 \n");
	  tmpgain[0]   = *wbgain; 
    //mexPrintf("I am in43 \n");
	  lasttmpgain  = *wbgain;
    //mexPrintf("I am in5 \n");
    *tauc1    = cohc*(tmptauc1-bmTaumin[0])+bmTaumin[0];  /* time -constant for the signal-path C1 filter */
	  *rsigma   = 1/ *tauc1-1/bmTaumax[0]; /* shift of the location of poles of the C1 filter from the initial positions */

    *tauwb    = TauWBMax+(*tauc1-bmTaumax[0])*(TauWBMax-TauWBMin)/(bmTaumax[0]-bmTaumin[0]);
    wb_gain = gain_groupdelay(tdres,centerfreq,cf,*tauwb,grdelay);
    *wbgain = wb_gain;
    //mexPrintf("I am in6 \n");
    /*
    grd = grdelay[0]; 
    
    if ((grd+n)<totalstim)
         tmpgain[grd+n] = wb_gain;

    if (tmpgain[n] == 0)
        tmpgain[n] = lasttmpgain;	

    *wbgain      = tmpgain[n];
    lasttmpgain = *wbgain;*/
    
}

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{ 
  

    double cf, tdres, centerfreq, tmptauc1;
    double *ntmp, *grdelay, *rsigma, *tauc1, *tauwb, *wbgain;
    int n, *grd;

    //mexPrintf("Number of inputs: %d\n",nrhs);
    //mexPrintf("Number of outputs: %d\n",nlhs);

    tdres = mxGetScalar(prhs[0]);
    cf = mxGetScalar(prhs[1]);
    centerfreq = mxGetScalar(prhs[2]);
    tmptauc1 = mxGetScalar(prhs[3]);
    //mexPrintf("Inputs done\n");
    //ntmp = mxGetPr(prhs[4]);


    /* convert to integers */
    //n = (int) ntmp[0];

    /* get pointer to the data in the output */
    plhs[0] = mxCreateNumericMatrix(1, 1, mxINT32_CLASS, mxREAL);
    plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
    plhs[2] = mxCreateDoubleMatrix(1, 1, mxREAL);
    plhs[3] = mxCreateDoubleMatrix(1, 1, mxREAL);
    plhs[4] = mxCreateDoubleMatrix(1, 1, mxREAL);
    //mexPrintf("Matrices allocated \n");
    grd = mxGetPr(plhs[0]);
    rsigma = mxGetPr(plhs[1]);
    tauc1 = mxGetPr(plhs[2]);
    tauwb = mxGetPr(plhs[3]);
    wbgain = mxGetPr(plhs[4]);

    //mexPrintf("Ptr stuff done\n");

    calc_tau(tdres, cf, centerfreq, tmptauc1, grd, rsigma, tauc1, tauwb, wbgain);
    //mexPrintf("Number of outputs: %d\n",nlhs);
    //*grdelay = (double) *grd; 
   // mexPrintf("I am in \n");
}
