% loggaussian mu parameter

function lmu = logg_mu(mn,sd)
        lmu = log(mn) - 0.5*log(1 + sd^2/mn^2);
end
    
    