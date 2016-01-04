function g=g(q,Q,hk,lcc)
%g is a function that takes into account preferential orientation in the
%Ruland and Smarsly model for WAXS scattering of graphene

s=size(q);
if s(1)==1
    g=zeros(1,length(q));
else
    g=zeros(length(q),1);
end

for i=1:length(q)
    qhk=2/3/lcc*sqrt(hk(1,1)^2+hk(1,2)^2+hk(1,1)*hk(1,2));
    if q(i)<qhk
        g(i)=(1+Q)*sqrt(Q)/atanh(sqrt(Q))/((1-Q)^2+4*Q*qhk^2/q(i)^2);
    else
        g(i)=sqrt(Q)/atanh(sqrt(Q))/(1+Q);
    end
end
end