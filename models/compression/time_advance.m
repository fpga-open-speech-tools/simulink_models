%%%% function to delay signal, actually by just rotating buffer, and padd at end which becomes revealed
function op=time_advance(ip,msec,fs,padding);
nshift=floor(msec*fs/1000);  %% number of samples to shift
siglen=length(ip);
op = zeros(size(ip));
ip(1:siglen-nshift) = ip(nshift+1:siglen); %%%%% shift the bulk
ip(1+siglen-nshift:siglen) = padding; %%% obliterate bit at end with external fill
op = ip;
