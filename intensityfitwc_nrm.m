% CSFF+PD fit to SAXS intensity data, gaussian diameter distribution

function fitint = intensityfitwc_nrm(q, Dcnt, sigDcnt, c)

    Ro = Dcnt/2;
    sigRo = sigDcnt/2;

    dR = max([sigRo/10 0.1]);
    Romin = max([0.1*Ro (Ro - 3*sigRo)]);
    Romax = Ro + 3*sigRo;
    Rnow = Romin;
    
    Rnow = Romin;
    Icnum = 0;
    
    while Rnow <= Romax
         Icnum = Icnum + dR*gpdf(Rnow,Ro,sigRo)...
             * (2*(besselj(1,q*Rnow) - c*besselj(1,c*q*Rnow)) ./ (q*Rnow*(1-c^2))).^2;             
         Rnow = Rnow + dR;
    end

    fitint = (Icnum ./ q);

end