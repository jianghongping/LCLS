function I=RandS_interlayer(q,Q,h,a3,s3,u3,m,b,n0,S0)
%This is the interlayer component of the Ruland and Smarsly model for WAXS
%scattering of graphene. Note: u3 is <u_3^2>.

H=exp(-.5*s3^2*q.^2+1i*a3*q);

I=2*n0*(1+Q)*sqrt(Q)/atanh(sqrt(Q))/(1-Q)^2./q.^2/S0.*(1+h*exp(-u3*q.^2).*...
    (real((1+H)./(1-H)-(2*H.*(1-(1-log(H)/b).^-m))./(m/b*(1-H)))-...
    2*b./(m*q.^2*a3^2).*(1-cos(m*atan(a3*q/b))./(1+q.^2*a3^2/b^2))-1));

end