function I=RandS_intralayer(q,Q,lcc,n,a,s1,e1,n0,S0)
%This is the intralayer scattering component of the Ruland and Smarsly WAXS
%scattering model. hk is a n x 2 array of hk indices to sum over.

hk=[0 0; 1 0];
s=size(q);
if s(1)==1
    I=zeros(1,length(q));
else
    I=zeros(length(q),1);
end

syms z
for i=1:size(hk,1)
    qhk=2/3/lcc*sqrt(hk(i,1)^2+hk(i,2)^2+hk(i,1)*hk(i,2));
    if hk(i,1)==0 && hk(i,2)==0
        mhk=1;
    elseif hk(i,1)==hk(i,2) || hk(i,2)==0
        mhk=6;
    else
        mhk=12;
    end
    if (hk(i,1)-hk(i,2))==3*round((hk(i,1)-hk(i,2))/3)
        F2hk=4;
    else
        F2hk=1;
    end
    I=I+4*sqrt(pi)*mhk*F2hk*g(q,Q,hk(i,:),lcc)./(n0*S0*q.*sqrt(q+qhk)).*...
        int((gammainc(a*z.^2,n+1,'upper')*gamma(n+1)-a*z.^2*gammainc(a*z.^2,n,'upper')*gamma(n))/gamma(n+1).*...
        exp(-.5*qhk^2*(s1^2*2/3/lcc.*z.^2+e1.*z.^4)).*...
        sin(z.^2.*(q-qhk)-pi/4),z,0,5*n/a);
end
end