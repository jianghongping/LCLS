function I=RandS(q,cu,Dan,Q,h,a3,s3,u3,m,b,lcc,n,a,s1,e1,n0,S0)
%This is the complete Ruland and Smarsly model for WAXS scattering of
%graphene. 

I_inter=RandS_interlayer(q,Q,h,a3,s3,u3,m,b,n0,S0);

I_intra=RandS_intralayer(q,Q,lcc,n,a,s1,e1,n0,S0);

I=(1-cu)*(f_cperp(q,Dan).^2.*I_inter+f_cpara(q).^2.*I_intra)+cu*f_cpara(q).^2;

end