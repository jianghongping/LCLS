% loggaussian variance

function vr = logg_var(mu_lg,sg_lg)
        vr = (exp(sg_lg^2) - 1)*(exp(2*mu_lg+sg_lg^2));
    end
    
    