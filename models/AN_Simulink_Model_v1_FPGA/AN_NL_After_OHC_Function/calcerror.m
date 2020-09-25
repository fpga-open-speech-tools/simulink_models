function [avgpercerror, maxpercerror, normerror] = calcerror(outref, out)
    normerror = norm(outref - out);
    % Because percent error requires that outref be nonzero, we must check
    % before calculating. If zero, omit during percent error calculations.
    zeros = find(outref == 0);
    outref(zeros) = [];
    out(zeros) = [];
    % Now calculating percent errors
    errordist = 100*(outref - out)./(outref);
    abserror = abs(outref - out);
    percerror = abs(100*abserror./outref);
    avgpercerror = sum(percerror)/(length(percerror)+1);
    maxpercerror = max(percerror);
    figure()
    nbins = 100;
    histogram(errordist,nbins)
    title('Percent Error Distribution');
    xlabel('Percent Error');
    ylabel('Instances');
end