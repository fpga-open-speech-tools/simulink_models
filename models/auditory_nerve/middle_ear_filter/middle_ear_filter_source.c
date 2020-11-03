/* 

 ------------------------------------------------------------------------

   Copyright 2020 AudioLogic Inc

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
   INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
   PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
   FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
   ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

   Connor Dack
   AudioLogic Inc
   985 Technology Blvd
   Bozeman, MT 59718

   Auditory Nerve Simulink Model Code
   middle_ear_filter_source.c Function
   11/03/2020 */

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

// Middle Ear Filter from model_IHC_BEZ2018.c - Lines 265-312
void middle_ear_filter(double px, double px1, double px2, double tdres, int n, double *middle_ear_filter_out)
{
    double fp,C;
    double m11,m12,m13,m14,m15,m16;
    double m21,m22,m23,m24,m25,m26;
    double m31,m32,m33,m34,m35,m36;
    double megainmax;
    double *mey1, *mey2, *mey3, meout;

    fp = 1e3;                            // Line 265 - Constant 
    C  = TWOPI*fp/tan(TWOPI/2*fp*tdres); // Line 266
    
    m11=1/(pow(C,2)+5.9761e+003*C+2.5255e+007);    m12=(-2*pow(C,2)+2*2.5255e+007);    m13=(pow(C,2)-5.9761e+003*C+2.5255e+007);   m14=(pow(C,2)+5.6665e+003*C);             m15=-2*pow(C,2);					m16=(pow(C,2)-5.6665e+003*C);
    m21=1/(pow(C,2)+6.4255e+003*C+1.3975e+008);    m22=(-2*pow(C,2)+2*1.3975e+008);    m23=(pow(C,2)-6.4255e+003*C+1.3975e+008);   m24=(pow(C,2)+5.8934e+003*C+1.7926e+008); m25=(-2*pow(C,2)+2*1.7926e+008);	m26=(pow(C,2)-5.8934e+003*C+1.7926e+008);
    m31=1/(pow(C,2)+2.4891e+004*C+1.2700e+009);    m32=(-2*pow(C,2)+2*1.2700e+009);    m33=(pow(C,2)-2.4891e+004*C+1.2700e+009);   m34=(3.1137e+003*C+6.9768e+008);          m35=2*6.9768e+008;				m36=(-3.1137e+003*C+6.9768e+008);
    megainmax=2;

    if (n==0)  /* Start of the middle-ear filtering section  */
    {
        mey1[0]  = m11*m14*px;
        mey2[0]  = mey1[0]*m24*m21;
        mey3[0]  = mey2[0]*m34*m31;
        meout    = mey3[0]/megainmax ;
    }
        
    else if (n==1)
    {
        mey1[1]  = m11*(-m12*mey1[0] + m14*px      + m15*px1);
        mey2[1]  = m21*(-m22*mey2[0] + m24*mey1[1] + m25*mey1[0]);
        mey3[1]  = m31*(-m32*mey3[0] + m34*mey2[1] + m35*mey2[0]);
        meout    = mey3[1]/megainmax;
    }
    else 
    {
        mey1[n]  = m11*(-m12*mey1[n-1] - m13*mey1[n-2] + m14*px      + m15*px1       + m16*px2);
        mey2[n]  = m21*(-m22*mey2[n-1] - m23*mey2[n-2] + m24*mey1[n] + m25*mey1[n-1] + m26*mey1[n-2]);
        mey3[n]  = m31*(-m32*mey3[n-1] - m33*mey3[n-2] + m34*mey2[n] + m35*mey2[n-1] + m36*mey2[n-2]);
        meout    = mey3[n]/megainmax;
    };
    *middle_ear_filter_out = meout;
}

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{

    double px, px1, px2, tdres, *ntmp, *middle_ear_filter_out;
    int n;

    /* get the value of the scalar input  */
    px    = mxGetScalar(prhs[0]);
    px1   = mxGetScalar(prhs[1]);
    px2   = mxGetScalar(prhs[2]);
    tdres = mxGetScalar(prhs[3]);
    ntmp  = mxGetPr(prhs[4]);

    /* convert to integer */
    n = (int) ntmp[0];

    /* get pointer to the data in the output */
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    middle_ear_filter_out = mxGetPr(plhs[0]);

    /* call the computational routine */
    middle_ear_filter(px, px1, px2, tdres, n, middle_ear_filter_out);
}
