% hermans.m calculates hermans orientation parameter
% azimvec format is [theta, I(theta)];
% Because of the masking, azimvec is not continuous in theta, which is why
% I'm using trapz to do a trapezoidal numerical integration

function h = hermans_masked(azimvec)

msc_num = trapz(azimvec(:,1),azimvec(:,2).*sin(azimvec(:,1)).*cos(azimvec(:,1)).^2);
msc_denom = trapz(azimvec(:,1),azimvec(:,2).*sin(azimvec(:,1)));

% figure; clf; 
% a = azimvec(:,2).*sin(azimvec(:,1)).*(cos(azimvec(:,1).^2)); 
% b = azimvec(:,2).*sin(azimvec(:,1));
% plot(a./b);
% axis tight; grid on;

% calculate hermans using mean square cosine
msc = msc_num/msc_denom;
h = 0.5*(3*msc - 1);
end