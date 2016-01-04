% hermans.m calculates hermans orientation parameter
% azimvec format is [theta, I(theta)];
% Because of the masking, azimvec is not continuous in theta, which is why
% I'm using trapz to do a trapezoidal numerical integration

function [h,az_patch] = hermans_masked_withfit(azimvec)

azimvec(:,2)=azimvec(:,2)./max(azimvec(:,2));
dtheta=abs(azimvec(2,1)-azimvec(1,1));

[A,m,s]=gaussfit([1,0,pi/6],azimvec(:,1),azimvec(:,2),[.99,-pi/180,dtheta],[1.2,pi/180,pi/2],'');

theta=[0:dtheta:pi/2]';
az_patch(:,1)=theta;
az_patch(:,2)=zeros(length(theta),1);
for i=1:length(theta)
    if ~isempty(find(azimvec(:,1)==theta(i),1))
        az_patch(i,2)=azimvec(find(azimvec(:,1)==theta(i),1),2);
    else
        az_patch(i,2)=A*exp(-(theta(i)-m)^2/(2*s^2));
    end
end

msc_num = trapz(az_patch(:,1),az_patch(:,2).*sin(az_patch(:,1)).*cos(az_patch(:,1)).^2);
msc_denom = trapz(az_patch(:,1),az_patch(:,2).*sin(az_patch(:,1)));

% figure; clf; 
% a = azimvec(:,2).*sin(azimvec(:,1)).*(cos(azimvec(:,1).^2)); 
% b = azimvec(:,2).*sin(azimvec(:,1));
% plot(a./b);
% axis tight; grid on;

% calculate hermans using mean square cosine
msc = msc_num/msc_denom;
h = 0.5*(3*msc - 1);
end