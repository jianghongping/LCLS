function [ output_args ] = testerHerm(azimvec)
%replicate hermans calculation with patched and unpatched data
theta=azimvec(:,1);
dtheta=abs(azimvec(2,1)-azimvec(1,1));

%Eliminate zeros for the fitting

I=find(azimvec(:,2));
azimvec=azimvec(I,:);


end

