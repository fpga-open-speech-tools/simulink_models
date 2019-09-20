%%savewavfile : put eq+compressed signal out to file
function [opwav, stop_ok] = ...
    savewavfile ...
        (opfiledigrms, ipfiledigrms, proc_sig, Fs, nbits, NStreams) 
    
[opfile, oppath] = uiputfile('*.wav','Save Processed Signal As.....');
if isequal(opfile,0) || isequal(oppath,0)
    fprintf(1,'File not found'); stop_ok = 0;
else  %% apply same scaling as would be applied on playout
    digital_scaling = 10.^(.05*(opfiledigrms - ipfiledigrms ));
    opwav = (proc_sig * digital_scaling);
    maxproc = 0;
    for ix_NStr = 1:NStreams
        maxch = max(abs(opwav(:, ix_NStr)));
        maxproc = max(maxch, maxproc);
    end
    audiowrite(strcat(oppath,opfile), opwav, Fs, 'BitsPerSample', nbits);
    headroom_dB = 20*log10(maxproc);  stop_ok = 1;
    if(headroom_dB > 0)
        fprintf(1,'\nFile %s%s written \nRequires extra %5.1fdB of headroom to avoid clipping',oppath,opfile, headroom_dB);
        stop_ok = 0;
    end
end

end

