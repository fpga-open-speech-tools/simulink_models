function [bmTaumax, bmTaumin, ratio] = Get_taubm(cf, species, taumax)

    if(species==1) % For Cat
        gain = 52.0/2.0*(tanh(2.2*log10(cf/0.6e3)+0.15)+1.0);
    elseif(species>1) % For Human
        gain = 52.0/2.0*(tanh(2.2*log10(cf/0.6e3)+0.15)+1.0);
    end
    
    if(gain > 60.0) 
        gain = 60.0;  
    end
    
    if(gain < 15.0) 
        gain = 15.0;
    end
    
    bwfactor = 0.7;
    factor   = 2.5;
    
    ratio    = 10^(-gain/(20.0*factor)); 
    bmTaumax = taumax/bwfactor;
    bmTaumin = bmTaumax*ratio;   
end
