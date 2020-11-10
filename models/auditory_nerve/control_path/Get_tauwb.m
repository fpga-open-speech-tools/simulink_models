function [taumax, taumin] = Get_tauwb( cf, species, order)
  TWOPI = 6.28318530717959;
  if(species==1) 
      gain = 52.0/2.0*(tanh(2.2*log10(cf/0.6e3)+0.15)+1.0); %/* for cat */
  end
  if(species>1) 
      gain = 52.0/2.0*(tanh(2.2*log10(cf/0.6e3)+0.15)+1.0); %/* for human */
    %/*gain = 52/2*(tanh(2.2*log10(cf/1e3)+0.15)+1);*/ /* older values */
  end
  if(gain>60.0) 
      gain = 60.0;  
  end
  if(gain<15.0) 
      gain = 15.0;
  end
  ratio = 10^(-gain/(20.0*order));       %/* ratio of TauMin/TauMax according to the gain, order */
%   if (species==1) %/* cat Q10 values */
%     Q10 = pow(10,0.4708*log10(cf/1e3)+0.4664);
%   end
  if (species==2) %/* human Q10 values from Shera et al. (PNAS 2002) */
    Q10 = (cf/1000)^(0.3)*12.7*0.505+0.2085;
  end
  if (species==3) %/* human Q10 values from Glasberg & Moore (Hear. Res. 1990) */
    Q10 = cf/24.7/(4.37*(cf/1000)+1)*0.505+0.2085;
  end
  bw     = cf/Q10;
  taumax = 2.0/(TWOPI*bw);
  taumin   = taumax*ratio;
end