function [wb_gain, grdelay, x] = gain_groupdelay(tdres, centerfreq, cf, tau)
  TWOPI = 6.28318530717959;
  tmpcos = cos(TWOPI*(centerfreq-cf)*tdres);
  dtmp2 = tau*2.0/tdres;
  c1LP = (dtmp2-1)/(dtmp2+1);
  c2LP = 1.0/(dtmp2+1);
  tmp1 = 1+c1LP*c1LP-2*c1LP*tmpcos;
  tmp2 = 2*c2LP*c2LP*(1+tmpcos);
  
  wb_gain = (tmp1/tmp2)^( 1.0/2.0);
  
  grdelay = floor((0.5-(c1LP*c1LP-c1LP*tmpcos)/(1+c1LP*c1LP-2*c1LP*tmpcos)));
  x = grdelay;
end