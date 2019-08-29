function N = JMAP_noiseSup(ensig, frameMag)

PR = sum(abs(ensig.^2))/(sum(abs(frameMag.^2))+eps);
    
if(PR>=0.4)
    PRT = 1;
else
    PRT = PR;
end
    
if(PRT == 1)
    N=1;
else
    N = 2*round((1-PRT/0.4))+1;
end



end