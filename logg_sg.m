% loggaussian sigma parameter

function lsg = logg_sg(mn,sd)
        lsg = sqrt( log(sd.^2./mn.^2 + 1 ));
end