function [hraw,hfit,az] = testerHerm(azimvec)
%replicate hermans calculation with patched and unpatched data
theta=azimvec(:,1);
dtheta=abs(azimvec(2,1)-azimvec(1,1));

%Eliminate zeros for the fitting

I=find(azimvec(:,2));
azimvec=azimvec(I,:);
disp(strcat('Az length ',num2str(length(azimvec(:,2)))))
disp(strcat('AzPatch length ',num2str(length(theta))))
az_patch(:,1)=theta;
az_patch(:,2)=zeros(length(theta),1);
for i = 1:length(theta)
    az_patch(i,2)=4;
end
for i=1:length(azimvec(:,2))
    azimvec(i,2)=4;
end
msc_num_raw=trapz(azimvec(:,1),azimvec(:,2).*sin(azimvec(:,1)).*cos(azimvec(:,1)).^2);
msc_denom_raw = trapz(azimvec(:,1),azimvec(:,2).*sin(azimvec(:,1)));

msc_num = trapz(az_patch(:,1),az_patch(:,2).*sin(az_patch(:,1)).*cos(az_patch(:,1)).^2);
msc_denom = trapz(az_patch(:,1),az_patch(:,2).*sin(az_patch(:,1)));

% figure; clf; 
% a = azimvec(:,2).*sin(azimvec(:,1)).*(cos(azimvec(:,1).^2)); 
% b = azimvec(:,2).*sin(azimvec(:,1));
% plot(a./b);
% axis tight; grid on;
%OUTPUT azimuthal is fitted data
az=az_patch;
% calculate hermans using mean square cosine
msc_raw=msc_num_raw/msc_denom_raw;

msc = msc_num/msc_denom;

hfit = 0.5*(3*msc - 1);
hraw = 0.5*(3*msc_raw-1);
    

end

