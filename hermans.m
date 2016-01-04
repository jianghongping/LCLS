% hermans.m calculates hermans orientation parameter
% azimvec format is [theta, I(theta)];

function h = hermans(azimvec)

msc_num = 0;
msc_denom = 0;
dtheta = azimvec(2,1) - azimvec(1,1);



for i = 1 : size(azimvec,1)
    msc_num = msc_num + azimvec(i,2)*sin(azimvec(i,1))*cos(azimvec(i,1))^2*dtheta;
    msc_denom = msc_denom + azimvec(i,2)*sin(azimvec(i,1))*dtheta;
end

% figure; clf; 
% a = azimvec(:,2).*sin(azimvec(:,1)).*(cos(azimvec(:,1).^2)); 
% b = azimvec(:,2).*sin(azimvec(:,1));
% plot(a./b);
% axis tight; grid on;

% calculate hermans using mean square cosine
msc = msc_num/msc_denom;
h = 0.5*(3*msc - 1);