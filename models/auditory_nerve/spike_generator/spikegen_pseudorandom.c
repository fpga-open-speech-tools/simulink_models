/* C2ChirpFilt() - A C function created to isolate the C2 Wideband Filter
   function found in the AN Model C source code model_IHC_BEZ2018 in order to
	 verify Simulink functionality

   C2filterout = C2ChirpFilt(xx, tdres, cf, n, taumax, fcohc)

   The filter takes in either the signal output from the Middle Ear Filter,
   binsize, neuron characteristic frequency, sample number, max time constant,
   and impairment parameter and returns the C2 filter output signal.

   Inputs:
      *synout
      tdres
      t_rd_rest
      t_rd_init
      tau
      t_rd_jump
      nSites
      tabs
      trel
      spont
      totalstim
      nrep
      total_mean_rate
      MaxArraySizeSpikes 
      *sptime
      *trd_vector


   Outputs:
   C2filterout = C2 filter output signal

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

#include "complex.h"
int SpikeGenerator( double *synout, double *randNums, double tdres, double t_rd_rest, double t_rd_init, double tau,
                    double t_rd_jump, int nSites, double tabs, double trel, double spont, int totalstim, 
                    int nrep,double total_mean_rate,long MaxArraySizeSpikes, double *sptime, 
                    double *trd_vector, double unitRateInterval_init, double oneSiteRedock_init)
{
    
    /* Initializing the variables: */
    
    double*  preRelease_initialGuessTimeBins;
    int*     unitRateInterval;
    double*  elapsed_time;
    double*  previous_release_times;
    double*  current_release_times;
    double*  oneSiteRedock;
    double*  Xsum;
    
    double  MeanInterEvents;
    long    MaxArraySizeEvents;
    
    long randBufIndex;
    long randBufLen;
    
    int rand_counter = 0;
    
    
    long     spCount; /* total numebr of spikes fired */
    
    long     k;  /*the loop starts from kInit */
    
    int i, siteNo, kInit;
    double Tref, current_refractory_period, trel_k;
    int t_rd_decay, rd_first;
    
    double previous_redocking_period,  current_redocking_period;
    int oneSiteRedock_rounded, elapsed_time_rounded ;
    
    mxArray *sortInputArray[1], *sortOutputArray[1];
    double *sortDims, *preReleaseTimeBinsSorted;
    
    preRelease_initialGuessTimeBins = (double*)mxCalloc(nSites, sizeof(double));
    unitRateInterval                = (int*)mxCalloc(nSites, sizeof(double));;
    elapsed_time                    = (double*)mxCalloc(nSites, sizeof(double));
    previous_release_times          = (double*)mxCalloc(nSites, sizeof(double));
    current_release_times           = (double*)mxCalloc(nSites, sizeof(double));
    oneSiteRedock                   = (double*)mxCalloc(nSites, sizeof(double));
    Xsum                            = (double*)mxCalloc(nSites, sizeof(double));
    
    /* Estimating Max number of spikes and events (including before zero elements)  */
    MeanInterEvents = (1/total_mean_rate)+ (t_rd_init)/nSites;
    /* The sufficient array size (more than 99.7% of cases) to register event times  after zero is :/
     * /*MaxN=signalLengthInSec/meanEvents+ 3*sqrt(signalLengthInSec/MeanEvents)*/
    
    MaxArraySizeEvents= ceil ((long) (totalstim*nrep*tdres/MeanInterEvents+ 3 * sqrt(totalstim*nrep*tdres/MeanInterEvents)))+nSites;
    
    
    
    /* Max random array Size:   nSites elements for oneSiteRedock initialization, nSites elements for preRelease_initialGuessTimeBins initialization
     * 1 element for Tref initialization, MaxArraySizeSpikes elements for Tref in the loop, MaxArraySizeEvents elements one  time for redocking, another time for rate intervals
     * Also, for before zero elements, Averageley add 2nSites  events (redock-and unitRate) and add nSites (Max) for Trefs:
     * in total : 3 nSpikes  */
    randBufLen = (long) ceil( 2*nSites+ 1 + MaxArraySizeSpikes + 2*MaxArraySizeEvents + MaxArraySizeSpikes+ 3*nSites);
    
    /* mexPrintf("randBufLen: %ld\n\n", randBufLen); */
        
    /* Initial < redocking time associated to nSites release sites */
    for (i=0; i<nSites; i++)
    {
        oneSiteRedock[i]=t_rd_init/2; // Match the simulation
    }
    /* Initial  preRelease_initialGuessTimeBins  associated to nsites release sites */
    
    for (i=0; i<nSites; i++)
    {
        preRelease_initialGuessTimeBins[i]= __max(-totalstim*nrep,ceil ((nSites/__max(synout[0],0.1) + t_rd_init)*log(randNums[0] ) / tdres));
        
    }
    
    
    /* Call Sort function using  */
    sortInputArray[0] = mxCreateDoubleMatrix(1, nSites, mxREAL);
    sortDims = mxGetPr(sortInputArray[0]);
    for (i=0;i<nSites; i++)
    {
        sortDims[i] = preRelease_initialGuessTimeBins[i];
        
    }
    
    for (i = 0; i < nSites; i++)
    {
      elapsed_time[i] = 0;//elapsed_time_init;
      unitRateInterval[i] = unitRateInterval_init;
      Xsum[i] = 0;
    }
    
    
    
    mexCallMATLAB(1, sortOutputArray, 1, sortInputArray, "sort");
    
    /*Now Sort the four initial preRelease times and associate
     * the farthest to zero as the site which has also generated a spike */
    
    preReleaseTimeBinsSorted =  mxGetPr(sortOutputArray[0]);
    
    /* Consider the inital previous_release_times to be  the preReleaseTimeBinsSorted *tdres */
    for (i=0; i<nSites; i++)
    {
        previous_release_times[i] = ((double)preReleaseTimeBinsSorted[i])*tdres;
    }
    
    /* The position of first spike, also where the process is started- continued from the past */
    kInit = (int) preReleaseTimeBinsSorted[0];
    
    
    /* Current refractory time */
    Tref = tabs - trel*log( randNums[0] );
    
    /*initlal refractory regions */
    current_refractory_period = 0;//(double) kInit*tdres;
    
    spCount = 0; /* total numebr of spikes fired */
    k = 0;//kInit;  /*the loop starts from kInit */
    
    /* set dynamic mean redocking time to initial mean redocking time  */
    previous_redocking_period = t_rd_init;
    current_redocking_period = previous_redocking_period;
    t_rd_decay = 1; /* Logical "true" as to whether to decay the value of current_redocking_period at the end of the time step */
    rd_first = 1; // Assume the first redocking event already occured to match the intern assumptions
    
    /* a loop to find the spike times for all the totalstim*nrep */
    
    mexPrintf("%d\n",totalstim*nrep);
    
    mexPrintf("osr: %f\tet: %f\n",oneSiteRedock[0],elapsed_time);
    while (k < totalstim*nrep){
        
        for (siteNo = 0; siteNo<nSites; siteNo++)
        {
            
            if ( k > preReleaseTimeBinsSorted [siteNo] )
            {
            
                /* redocking times do not necessarily occur exactly at time step value - calculate the
                 * number of integer steps for the elapsed time and redocking time */
                oneSiteRedock_rounded =  (int) floor(oneSiteRedock[siteNo]/tdres);
                elapsed_time_rounded =  (int) floor(elapsed_time[siteNo]/tdres);
                

                if ( oneSiteRedock_rounded == elapsed_time_rounded)
                {
                    /* Jump  trd by t_rd_jump if a redocking event has occurred   */
                    current_redocking_period  =   previous_redocking_period  + t_rd_jump;
                    previous_redocking_period =   current_redocking_period;
                    mexPrintf("osr: %d\tet: %d\n",oneSiteRedock_rounded,elapsed_time_rounded);
                    t_rd_decay = 0; /* Don't decay the value of current_redocking_period if a jump has occurred */
                    rd_first = 1; /* Flag for when a jump has first occurred */
            
                    mexPrintf("Redocking!\n");
                }
                
                /* to be sure that for each site , the code start from its
                 * associated  previus release time :*/
                elapsed_time[siteNo] = elapsed_time[siteNo] + tdres;
                // if (siteNo == 0)
                  // mexPrintf("osr: %f\tet: %f\n",oneSiteRedock[siteNo]/tdres,elapsed_time[siteNo]/tdres);

            };

            
            
            /*the elapsed time passes  the one time redock (the redocking is finished),
             * In this case the synaptic vesicle starts sensing the input
             * for each site integration starts after the redockinging is finished for the corresponding site)*/
            if ( elapsed_time[siteNo] >= oneSiteRedock [siteNo] )
            {
                Xsum[siteNo] = Xsum[siteNo] + synout[__max(0,k)] / nSites;
                
                /* There are  nSites integrals each vesicle senses 1/nosites of  the whole rate */
            }
            
            
            
            if  ( (Xsum[siteNo]  >=  unitRateInterval[siteNo]) &&  ( k >= preReleaseTimeBinsSorted [siteNo] ) )
            {  /* An event- a release  happened for the siteNo*/
                
                oneSiteRedock[siteNo]  = -current_redocking_period*log( randNums[rand_counter]);
                current_release_times[siteNo] = previous_release_times[siteNo]  + elapsed_time[siteNo];
                elapsed_time[siteNo] = 0;               
                
                if ( (current_release_times[siteNo] >= current_refractory_period) )
                {
                    
                    /*Register only non negative spike times */
                    if (current_release_times[siteNo] >= 0)
                    {
                        sptime[spCount] = current_release_times[siteNo]; 
                        spCount = spCount + 1;
                    }
                    
                    trel_k = __min(trel*100/synout[__max(0,k)],trel);

                    Tref = tabs-trel_k*log( randNums[rand_counter] );   /*Refractory periods */
                    
                    current_refractory_period = current_release_times[siteNo] + Tref;
                    
                }
                
                previous_release_times[siteNo] = current_release_times[siteNo];
                
                Xsum[siteNo] = 0;
                unitRateInterval[siteNo] = (int) (-log(randNums[rand_counter]) / tdres);
                
            };
            /* Error Catching */
            if ( (spCount+1)>MaxArraySizeSpikes  || (randBufIndex+1 )>randBufLen  )
            {     /* mexPrintf ("\n--------Array for spike times or random Buffer length not large enough, Rerunning the function.-----\n\n"); */
                spCount = -1;
                k = totalstim*nrep;
                siteNo = nSites;
            }
            
        };
        
        /* Decay the adapative mean redocking time towards the resting value if no redocking events occurred in this time step */
        if ( (t_rd_decay==1) && (rd_first==1) )
        {
            current_redocking_period =   previous_redocking_period  - (tdres/tau)*( previous_redocking_period-t_rd_rest );
            previous_redocking_period =  current_redocking_period;
        }
        else
        {
            t_rd_decay = 1;
        }
        
        /* Store the value of the adaptive mean redocking time if it is within the simulation output period */
        if ((k>=0)&&(k<totalstim*nrep))
            trd_vector [k] = current_redocking_period;
        
        k = k+1;
        rand_counter = rand_counter + 1;
        
        
    };
    
    mxFree(preRelease_initialGuessTimeBins);
    mxFree(unitRateInterval);
    mxFree(elapsed_time);
    mxFree(previous_release_times);
    mxFree(current_release_times);
    mxFree(oneSiteRedock);
    mxFree(Xsum);
    mxDestroyArray(sortInputArray[0]); mxDestroyArray(sortOutputArray[0]);
    return (spCount);
    
}

/* The gateway function */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  
  // Define the inputs and outputs
  double *synout, *randNums, tdres, *synout_pntr, t_rd_rest, t_rd_init, tau, t_rd_jump, tabs, trel, spont, total_mean_rate, *sptime, *trd_vector;
  int nSites, totalstim, nrep, n_synout, spcount, ii;
  long MaxArraySizeSpikes;
  double elapsed_time, unitRateInterval, oneSiteRedock;
  
  mwSize  outsize[2];
  
  // Initialize the inputs
  n_synout = (int)mxGetN(prhs[0]);
  
  
  synout_pntr         = mxGetPr(prhs[0]);
  randNums            = mxGetPr(prhs[1]);
  
  tdres               = mxGetScalar(prhs[2]);
  t_rd_rest           = mxGetScalar(prhs[3]);
  t_rd_init           = mxGetScalar(prhs[4]);
  tau                 = mxGetScalar(prhs[5]);
  t_rd_jump           = mxGetScalar(prhs[6]);
  nSites              = (int)mxGetScalar(prhs[7]);
  tabs                = mxGetScalar(prhs[8]);
  trel                = mxGetScalar(prhs[9]);
  spont               = mxGetScalar(prhs[10]);
  totalstim           = (int)mxGetScalar(prhs[11]);
  nrep                = (int)mxGetScalar(prhs[12]);
  total_mean_rate     = mxGetScalar(prhs[13]);
  MaxArraySizeSpikes  = (long)mxGetScalar(prhs[14]);
  unitRateInterval    = mxGetScalar(prhs[15]);
  oneSiteRedock       = mxGetScalar(prhs[16]);
  
  // Calculate the repetition time
  totalstim = (int)floor(n_synout/nrep);
  
  // Define the input array
  synout = (double*)mxCalloc(totalstim*nrep,sizeof(double));

   for (ii = 0; ii < n_synout; ii++)
      synout[ii] = synout_pntr[ii]; 
    
  
    
  // Define the size of the output arrays
  
    outsize[0] = 1;
    outsize[1] = totalstim*nrep;
    
    plhs[1] = mxCreateNumericArray(2, outsize, mxDOUBLE_CLASS, mxREAL);
    plhs[2] = mxCreateNumericArray(2, outsize, mxDOUBLE_CLASS, mxREAL);
    
    

    // Assign the pointer values
    sptime = mxGetPr(plhs[1]);
    trd_vector = mxGetPr(plhs[2]);

    /* call the computational routine */
    spcount = SpikeGenerator( synout, randNums, tdres, t_rd_rest, t_rd_init, tau, t_rd_jump, nSites, tabs, 
                              trel, spont, totalstim, nrep, total_mean_rate, MaxArraySizeSpikes, sptime, 
                              trd_vector, unitRateInterval, oneSiteRedock);
    
    plhs[0] = mxCreateDoubleScalar(spcount);
    
}



















