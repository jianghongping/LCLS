function f=f_cpara(q)
%Atomic scattering factor of C. Function taken from SI of Faber, Smarsly, 
%et al. J Phys. Chem. C 2014 paper on CDC WAXS.

f=0.289677+1.05075*exp(-2.43905*(q/2/pi).^2)+1.56165*exp(-1.64166*(q/2/pi).^2)...
    +3.09995*exp(-28*(q/8/pi).^2);
end