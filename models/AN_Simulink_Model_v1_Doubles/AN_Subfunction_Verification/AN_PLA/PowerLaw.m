%    PowerLaw() - A function created to isolate the Power Law Adaptation
%    function found in the Synapse function of the AN Model C source code 
%    model_IHC_BEZ2018 in order to verify Simulink functionality
% 
%    synout = PowerLaw(ihcout, totalstim, randNums)
% 
%    The function takes in the IHC Output signal,
%    which will just be declared for testing purposes, along witht the length 
%    of the signal in number of samples and a ffGn vector.
%    Then, the output is simply the sum of the Slow and Fast Power Law functions.
% 
%    Inputs:
%    ihcout = IHC output signal
%    totalstim = length of IHC output signal in number of samples
%    randNums = Fast Fractional Gaussian Noise (ffGn) vector
%
%    Outputs:
%    synout = sum of the fast and slow power law outputs
% 
%  ------------------------------------------------------------------------
% 
%    Copyright 2019 Audio Logic
% 
%    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
%    INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
%    PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
%    FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
%    ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
% 
%    Matthew Blunt
%    Audio Logic
%    985 Technology Blvd
%    Bozeman, MT 59718
%    openspeech@flatearthinc.com
% 
%    Auditory Nerve Simulink Model Code
%    PowerLaw.m Function
%    07/24/2019 

% ---------------------------------------------------------------------- %

%    Function copied from AN model C source code, with a few minor adjustments
%    in order for the function to operate in MATLAB

function synout = PowerLaw(ihcout, totalstim, randNums, Fs)

    %alpha1 = 1.5e-6*100e3; 
    alpha1 = 1.5e-6*100e3;
    beta1 = 5e-4; 
    I1 = 0;
    %alpha2 = 1e-2*100e3; 
    alpha2 = 1e-2*100e3;
    beta2 = 1e-1; 
    I2 = 0;

    k = 0;
    
    n1 = zeros(totalstim,1);
    n2 = zeros(totalstim,1);
    n3 = zeros(totalstim,1);
    
    m1 = zeros(totalstim,1);
    m2 = zeros(totalstim,1);
    m3 = zeros(totalstim,1);
    m4 = zeros(totalstim,1);
    m5 = zeros(totalstim,1);
    
    sout1 = zeros(totalstim,1);
    sout2 = zeros(totalstim,1);
    
    synout = zeros(totalstim,1);
    
    for indx=0:totalstim-1
    
        sout1(k+1)  = max( 0, ihcout(indx+1) + randNums(indx+1) - alpha1*I1(k+1));
        sout2(k+1)  = max( 0, ihcout(indx+1) - alpha2*I2);

            if k==0
            
                n1(k+1) = 1.0e-3*sout2(k+1);
                n2(k+1) = n1(k+1); 
                n3(1)= n2(k+1);
            
            elseif k==1
            
                n1(k+1) = 1.992127932802320*n1(k)+ 1.0e-3*(sout2(k+1) - 0.994466986569624*sout2(k));
                n2(k+1) = 1.999195329360981*n2(k)+ n1(k+1) - 1.997855276593802*n1(k);
                n3(k+1) = -0.798261718183851*n3(k)+ n2(k+1) + 0.798261718184977*n2(k);
            
            else
            
                n1(k+1) = 1.992127932802320*n1(k) - 0.992140616993846*n1(k-1)+ 1.0e-3*(sout2(k+1) - 0.994466986569624*sout2(k) + 0.000000000002347*sout2(k-1));
                n2(k+1) = 1.999195329360981*n2(k) - 0.999195402928777*n2(k-1)+n1(k+1) - 1.997855276593802*n1(k) + 0.997855827934345*n1(k-1);
                n3(k+1) =-0.798261718183851*n3(k) - 0.199131619873480*n3(k-1)+n2(k+1) + 0.798261718184977*n2(k) + 0.199131619874064*n2(k-1);
            
            end
            
            I2 = n3(k+1);

            if k==0
            
                m1(k+1) = 0.2*sout1(k+1);
                m2(k+1) = m1(k+1);	
                m3(k+1) = m2(k+1);
                m4(k+1) = m3(k+1);	
                m5(k+1) = m4(k+1);
            
            elseif k==1
            
                m1(k+1) = 0.491115852967412*m1(k) + 0.2*(sout1(k+1) - 0.173492003319319*sout1(k));
                m2(k+1) = 1.084520302502860*m2(k) + m1(k+1) - 0.803462163297112*m1(k);
                m3(k+1) = 1.588427084535629*m3(k) + m2(k+1) - 1.416084732997016*m2(k);
                m4(k+1) = 1.886287488516458*m4(k) + m3(k+1) - 1.830362725074550*m3(k);
                m5(k+1) = 1.989549282714008*m5(k) + m4(k+1) - 1.983165053215032*m4(k);
            
            else
            
                m1(k+1) = 0.491115852967412*m1(k) - 0.055050209956838*m1(k-1)+ 0.2*(sout1(k+1)- 0.173492003319319*sout1(k)+ 0.000000172983796*sout1(k-1));
                m2(k+1) = 1.084520302502860*m2(k) - 0.288760329320566*m2(k-1) + m1(k+1) - 0.803462163297112*m1(k) + 0.154962026341513*m1(k-1);
                m3(k+1) = 1.588427084535629*m3(k) - 0.628138993662508*m3(k-1) + m2(k+1) - 1.416084732997016*m2(k) + 0.496615555008723*m2(k-1);
                m4(k+1) = 1.886287488516458*m4(k) - 0.888972875389923*m4(k-1) + m3(k+1) - 1.830362725074550*m3(k) + 0.836399964176882*m3(k-1);
                m5(k+1) = 1.989549282714008*m5(k) - 0.989558985673023*m5(k-1) + m4(k+1) - 1.983165053215032*m4(k) + 0.983193027347456*m4(k-1);
            
            end
            
            I1(k+2) = m5(k+1);

        
        synout(k+1) = sout1(k+1) + sout2(k+1);
        k = k+1;
        
    end