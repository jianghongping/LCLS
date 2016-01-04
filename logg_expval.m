% loggaussian expected value

function ev = logg_expval(mu_lg,sg_lg)
        ev = exp(mu_lg+sg_lg^2/2);
end   