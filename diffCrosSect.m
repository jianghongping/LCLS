function [ Io,F ] = diffCrosSect(R,I)
%calculation of differential cross section
%density of gold scatter 19.3 g/cm^2
%I = peak counting rate from beam profile 
slitHeight=0.15875;
h=0.1;
lDetect=3.1;
rDetect=5.0;
I=2449.4;

N=(0.026/6.4516)*((6.022E23)/(197));

%Io (peak counting rate from beam profile)/(Fraction of incident beam that
%reaches detector)
F=(h/slitHeight)*(rDetect/(rDetect+lDetect);
Io=I/(F);

omega=0.005723204994797;

dcross=R/(omega*Io*N);

end

