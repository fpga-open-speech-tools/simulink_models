/* This is the BEZ2018 version of the code for auditory periphery model from the Carney, Bruce and Zilany labs.
 * 
 * This release implements the version of the model described in:
 *
 *   Bruce, I.C., Erfani, Y., and Zilany, M.S.A. (2018). "A Phenomenological
 *   model of the synapse between the inner hair cell and auditory nerve: 
 *   Implications of limited neurotransmitter release sites," to appear in
 *   Hearing Research. (Special Issue on "Computational Models in Hearing".)
 *
 * Please cite this paper if you publish any research
 * results obtained with this code or any modified versions of this code.
 *
 * See the file readme.txt for details of compiling and running the model.
 *
 * %%% Ian C. Bruce (ibruce@ieee.org), Yousof Erfani (erfani.yousof@gmail.com),
 *     Muhammad S. A. Zilany (msazilany@gmail.com) - December 2017 %%%
 *
 */

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

#ifndef __max
#define __max(a,b) (((a) > (b))? (a): (b))
#endif

#ifndef __min
#define __min(a,b) (((a) < (b))? (a): (b))
#endif

/* This function is the MEX "wrapper", to pass the input and output variables between the .mex* file and Matlab or Octave */

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    
    double *px, cf, tdres, tabs, trel, noiseType, implnt, spont, I;
    int    nrep, pxbins, lp, totalstim;
    mwSize  outsize[2];
    
    double *pxtmp, *cftmp, *nreptmp, *tdrestmp, *noiseTypetmp, *implnttmp, *sponttmp, *tabstmp, *treltmp;
    
    double *varrate, *psth, *synout, *trd_vector, *trel_vector;
    
    double Synapse(double *, double, double, int, int, double, double,  double, double, double *);
    
    double sampFreq = 10e3; /* Sampling frequency used in the synapse */
    
    /* Check for proper number of arguments */
    
    if (nrhs != 9)
    {
        mexErrMsgTxt("model_Synapse requires 9 input arguments.");
    };
    
    if (nlhs > 6)
    {
        mexErrMsgTxt("model_Synapse has a maximum of 6 output argument.");
    };
    
    /* Assign pointers to the inputs */
    
    pxtmp		 = mxGetPr(prhs[0]);
    cftmp		 = mxGetPr(prhs[1]);
    nreptmp		 = mxGetPr(prhs[2]);
    tdrestmp	 = mxGetPr(prhs[3]);
    noiseTypetmp = mxGetPr(prhs[4]);
    implnttmp	 = mxGetPr(prhs[5]);
    sponttmp	 = mxGetPr(prhs[6]);
    tabstmp      = mxGetPr(prhs[7]);
    treltmp      = mxGetPr(prhs[8]);

    /* Check individual input arguments */
    
    spont = sponttmp[0];
    if ((spont<1e-4)||(spont>180))
        mexErrMsgTxt("spont must in the range [1e-4,180]\n");   
    
    pxbins = (int)mxGetN(prhs[0]);
    if (pxbins==1)
        mexErrMsgTxt("px must be a row vector\n");
    
    cf = cftmp[0];
    
    nrep = (int)nreptmp[0];
    if (nreptmp[0]!=nrep)
        mexErrMsgTxt("nrep must an integer.\n");
    if (nrep<1)
        mexErrMsgTxt("nrep must be greater that 0.\n");
    
    tdres = tdrestmp[0];
    
    noiseType  = noiseTypetmp[0];  /* fixed or variable fGn */
    
    implnt = implnttmp[0];  /* actual/approximate implementation of the power-law functions */
    
    tabs = tabstmp[0];  /* absolute refractory period */
    if ((tabs<0)||(tabs>20e-3))
        mexErrMsgTxt("tabs must in the range [0,20e-3]\n");
    
    trel = treltmp[0];  /* baseline relative refractory period */
    if ((trel<0)||(trel>20e-3))
        mexErrMsgTxt("trel must in the range [0,20e-3]\n");
    
    /* Calculate number of samples for total repetition time */
    
    totalstim = totalstim * nrep; // Modified to match spikegen_source
    
    px = (double*)mxCalloc(totalstim*nrep,sizeof(double));
    
    /* Put stimulus waveform into pressure waveform */
    
    for (lp=0; lp<pxbins; lp++)
        px[lp] = pxtmp[lp];
    
    /* Create arrays for the return arguments */
    
    outsize[0] = 1;
    outsize[1] = totalstim*nrep;
    
    plhs[0] = mxCreateNumericArray(2, outsize, mxDOUBLE_CLASS, mxREAL);
    
    /* Assign pointers to the outputs */
    
    synout = mxGetPr(plhs[0]);
    
    /* run the model */
    I = Synapse(px, tdres, cf, totalstim, nrep, spont, noiseType, implnt, sampFreq, synout);
    
    mxFree(px);
    
}

/* --------------------------------------------------------------------------------------------*/
double Synapse(double *ihcout, double tdres, double cf, int totalstim, int nrep, double spont, double noiseType, double implnt, double sampFreq, double *synout)
{
    /* Initalize Variables */
    int z, b;
    int resamp = (int) ceil(1/(tdres*sampFreq));
    double incr = 0.0; int delaypoint = (int) floor(7500/(cf/1e3));
    
    double alpha1, beta1, I1, alpha2, beta2, I2, binwidth;
    int    k,j,indx,i;
    
    double cf_factor,cfslope,cfsat,cfconst,multFac;
    
    double *sout1, *sout2, *synSampOut, *powerLawIn, *mappingOut, *TmpSyn;
    double *m1, *m2, *m3, *m4, *m5;
    double *n1, *n2, *n3;
        
    mxArray	*randInputArray[5], *randOutputArray[1];
    double *randNums;
    
    mxArray	*IhcInputArray[3], *IhcOutputArray[1];
    double *sampIHC, *ihcDims;
    
    mappingOut = (double*)mxCalloc((long) ceil(totalstim*nrep),sizeof(double));
    powerLawIn = (double*)mxCalloc((long) ceil(totalstim*nrep+3*delaypoint),sizeof(double));
    sout1 = (double*)mxCalloc((long) ceil((totalstim*nrep+2*delaypoint)*tdres*sampFreq),sizeof(double));
    sout2 = (double*)mxCalloc((long) ceil((totalstim*nrep+2*delaypoint)*tdres*sampFreq),sizeof(double));
    synSampOut  = (double*)mxCalloc((long) ceil((totalstim*nrep+2*delaypoint)*tdres*sampFreq),sizeof(double));
    TmpSyn  = (double*)mxCalloc((long) ceil(totalstim*nrep+2*delaypoint),sizeof(double));
    
    m1 = (double*)mxCalloc((long) ceil((totalstim*nrep+2*delaypoint)*tdres*sampFreq),sizeof(double));
    m2 = (double*)mxCalloc((long) ceil((totalstim*nrep+2*delaypoint)*tdres*sampFreq),sizeof(double));
    m3  = (double*)mxCalloc((long) ceil((totalstim*nrep+2*delaypoint)*tdres*sampFreq),sizeof(double));
    m4 = (double*)mxCalloc((long) ceil((totalstim*nrep+2*delaypoint)*tdres*sampFreq),sizeof(double));
    m5  = (double*)mxCalloc((long) ceil((totalstim*nrep+2*delaypoint)*tdres*sampFreq),sizeof(double));
    
    n1 = (double*)mxCalloc((long) ceil((totalstim*nrep+2*delaypoint)*tdres*sampFreq),sizeof(double));
    n2 = (double*)mxCalloc((long) ceil((totalstim*nrep+2*delaypoint)*tdres*sampFreq),sizeof(double));
    n3 = (double*)mxCalloc((long) ceil((totalstim*nrep+2*delaypoint)*tdres*sampFreq),sizeof(double));
    
    /*----------------------------------------------------------*/
    /*------- Parameters of the Power-law function -------------*/
    /*----------------------------------------------------------*/
    binwidth = 1/sampFreq;
    alpha1 = 1.5e-6*100e3; beta1 = 5e-4; I1 = 0;
    alpha2 = 1e-2*100e3; beta2 = 1e-1; I2 = 0;
    
    /*----------------------------------------------------------*/
    /*------- Generating a random sequence ---------------------*/
    /*----------------------------------------------------------*/
    randInputArray[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    *mxGetPr(randInputArray[0])= ceil((totalstim*nrep+2*delaypoint)*tdres*sampFreq);
    randInputArray[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
    *mxGetPr(randInputArray[1])= 1/sampFreq;
    randInputArray[2] = mxCreateDoubleMatrix(1, 1, mxREAL);
    *mxGetPr(randInputArray[2])= 0.9; /* Hurst index */
    randInputArray[3] = mxCreateDoubleMatrix(1, 1, mxREAL);
    *mxGetPr(randInputArray[3])= noiseType; /* fixed or variable fGn */
    randInputArray[4] = mxCreateDoubleMatrix(1, 1, mxREAL);
    *mxGetPr(randInputArray[4])= spont; /* high, medium, or low */
    
    mexCallMATLAB(1, randOutputArray, 5, randInputArray, "ffGn");
    randNums = mxGetPr(randOutputArray[0]);
    /*----------------------------------------------------------*/
    /*----- Mapping Function from IHCOUT to input to the PLA ----------------------*/
    /*----------------------------------------------------------*/
    cfslope = pow(spont,0.19)*pow(10,-0.87);
    cfconst = 0.1*pow(log10(spont),2)+0.56*log10(spont)-0.84;
    cfsat = pow(10,(cfslope*8965.5/1e3 + cfconst));
    cf_factor = __min(cfsat,pow(10,cfslope*cf/1e3 + cfconst))*2.0;

    multFac = __max(2.95*__max(1.0,1.5-spont/100),4.3-0.2*cf/1e3);

    k = 0;
    for (indx=0; indx<totalstim*nrep; ++indx)
    {
        mappingOut[k] = pow(10,(0.9*log10(fabs(ihcout[indx])*cf_factor))+ multFac);
        if (ihcout[indx]<0) mappingOut[k] = - mappingOut[k];
        k=k+1;
    }
    for (k=0; k<delaypoint; k++)
        powerLawIn[k] = mappingOut[0]+3.0*spont;
    for (k=delaypoint; k<totalstim*nrep+delaypoint; k++)
        powerLawIn[k] = mappingOut[k-delaypoint]+3.0*spont;
    for (k=totalstim*nrep+delaypoint; k<totalstim*nrep+3*delaypoint; k++)
        powerLawIn[k] = powerLawIn[k-1]+3.0*spont;
    /*----------------------------------------------------------*/
    /*------ Downsampling to sampFreq (Low) sampling rate ------*/
    /*----------------------------------------------------------*/
    IhcInputArray[0] = mxCreateDoubleMatrix(1, k, mxREAL);
    ihcDims = mxGetPr(IhcInputArray[0]);
    for (i=0;i<k;++i)
        ihcDims[i] = powerLawIn[i];
    IhcInputArray[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
    *mxGetPr(IhcInputArray[1])= 1;
    IhcInputArray[2] = mxCreateDoubleMatrix(1, 1, mxREAL);
    *mxGetPr(IhcInputArray[2])= resamp;
    mexCallMATLAB(1, IhcOutputArray, 3, IhcInputArray, "resample");
    sampIHC = mxGetPr(IhcOutputArray[0]);
    
    mxFree(powerLawIn); mxFree(mappingOut);
    /*----------------------------------------------------------*/
    /*----- Running Power-law Adaptation -----------------------*/
    /*----------------------------------------------------------*/
    k = 0;
    for (indx=0; indx<(int)floor((totalstim*nrep+2*delaypoint)*tdres*sampFreq); indx++)
    {
        sout1[k]  = __max( 0, sampIHC[indx] + randNums[indx]- alpha1*I1);
        sout2[k]  = __max( 0, sampIHC[indx] - alpha2*I2);
        
        if (implnt==1)    /* ACTUAL Implementation */
        {
            I1 = 0; I2 = 0;
            for (j=0; j<k+1; ++j)
            {
                I1 += (sout1[j])*binwidth/((k-j)*binwidth + beta1);
                I2 += (sout2[j])*binwidth/((k-j)*binwidth + beta2);
            }
        } /* end of actual */
        
        if (implnt==0)    /* APPROXIMATE Implementation */
        {
            if (k==0)
            {
                n1[k] = 1.0e-3*sout2[k];
                n2[k] = n1[k]; n3[0]= n2[k];
            }
            else if (k==1)
            {
                n1[k] = 1.992127932802320*n1[k-1]+ 1.0e-3*(sout2[k] - 0.994466986569624*sout2[k-1]);
                n2[k] = 1.999195329360981*n2[k-1]+ n1[k] - 1.997855276593802*n1[k-1];
                n3[k] = -0.798261718183851*n3[k-1]+ n2[k] + 0.798261718184977*n2[k-1];
            }
            else
            {
                n1[k] = 1.992127932802320*n1[k-1] - 0.992140616993846*n1[k-2]+ 1.0e-3*(sout2[k] - 0.994466986569624*sout2[k-1] + 0.000000000002347*sout2[k-2]);
                n2[k] = 1.999195329360981*n2[k-1] - 0.999195402928777*n2[k-2]+n1[k] - 1.997855276593802*n1[k-1] + 0.997855827934345*n1[k-2];
                n3[k] =-0.798261718183851*n3[k-1] - 0.199131619873480*n3[k-2]+n2[k] + 0.798261718184977*n2[k-1] + 0.199131619874064*n2[k-2];
            }
            I2 = n3[k];
            
            if (k==0)
            {
                m1[k] = 0.2*sout1[k];
                m2[k] = m1[k];	m3[k] = m2[k];
                m4[k] = m3[k];	m5[k] = m4[k];
            }
            else if (k==1)
            {
                m1[k] = 0.491115852967412*m1[k-1] + 0.2*(sout1[k] - 0.173492003319319*sout1[k-1]);
                m2[k] = 1.084520302502860*m2[k-1] + m1[k] - 0.803462163297112*m1[k-1];
                m3[k] = 1.588427084535629*m3[k-1] + m2[k] - 1.416084732997016*m2[k-1];
                m4[k] = 1.886287488516458*m4[k-1] + m3[k] - 1.830362725074550*m3[k-1];
                m5[k] = 1.989549282714008*m5[k-1] + m4[k] - 1.983165053215032*m4[k-1];
            }
            else
            {
                m1[k] = 0.491115852967412*m1[k-1] - 0.055050209956838*m1[k-2]+ 0.2*(sout1[k]- 0.173492003319319*sout1[k-1]+ 0.000000172983796*sout1[k-2]);
                m2[k] = 1.084520302502860*m2[k-1] - 0.288760329320566*m2[k-2] + m1[k] - 0.803462163297112*m1[k-1] + 0.154962026341513*m1[k-2];
                m3[k] = 1.588427084535629*m3[k-1] - 0.628138993662508*m3[k-2] + m2[k] - 1.416084732997016*m2[k-1] + 0.496615555008723*m2[k-2];
                m4[k] = 1.886287488516458*m4[k-1] - 0.888972875389923*m4[k-2] + m3[k] - 1.830362725074550*m3[k-1] + 0.836399964176882*m3[k-2];
                m5[k] = 1.989549282714008*m5[k-1] - 0.989558985673023*m5[k-2] + m4[k] - 1.983165053215032*m4[k-1] + 0.983193027347456*m4[k-2];
            }
            I1 = m5[k];
         } /* end of approximate implementation */
        
        synSampOut[k] = sout1[k] + sout2[k];
        k = k+1;
    }   /* end of all samples */
    mxFree(sout1); mxFree(sout2);
    mxFree(m1); mxFree(m2); mxFree(m3); mxFree(m4); mxFree(m5); mxFree(n1); mxFree(n2); mxFree(n3);
    // /*----------------------------------------------------------*/
    // /*----- Upsampling to original (High 100 kHz) sampling rate --------*/
    // /*----------------------------------------------------------*/
    for(z=0; z<k-1; ++z)
    {
        incr = (synSampOut[z+1]-synSampOut[z])/resamp;
        // Catch whether the loop will attempt to write beyond the bounds of the array
        if (z*resamp+resamp-1 > totalstim*nrep+2*delaypoint)
        {
          mexPrintf("Matrix dimensions exceeded...\n");
          break;
        }
        else
          for(b=0; b<resamp; ++b)
            TmpSyn[z*resamp+b] = synSampOut[z]+ b*incr;
    }
    for (i=0;i<totalstim*nrep;++i)
      synout[i] = TmpSyn[i+delaypoint];
    
    mxFree(synSampOut); mxFree(TmpSyn);
    mxDestroyArray(randInputArray[0]); mxDestroyArray(randOutputArray[0]);
    mxDestroyArray(IhcInputArray[0]); mxDestroyArray(IhcOutputArray[0]); mxDestroyArray(IhcInputArray[1]); mxDestroyArray(IhcInputArray[2]);
    mxDestroyArray(randInputArray[1]);mxDestroyArray(randInputArray[2]); mxDestroyArray(randInputArray[3]);
    mxDestroyArray(randInputArray[4]);
    return((long) ceil(totalstim*nrep));
}























