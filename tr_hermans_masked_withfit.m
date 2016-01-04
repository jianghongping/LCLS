% hermans.m calculates hermans orientation parameter
% azimvec format is [theta, I(theta)];
% Because of the masking, azimvec is not continuous in theta, which is why
% I'm using trapz to do a trapezoidal numerical integration

function [hpatch,hfit,az_patch,az_fit] = tr_hermans_masked_withfit(azimvec)
%provide separate normalized vector nazimvec
nazimvec(:,2)=azimvec(:,2)./max(azimvec(:,2));
theta=azimvec(:,1);
dtheta=abs(azimvec(2,1)-azimvec(1,1));

%Eliminate zeros for the fitting

I=find(azimvec(:,2));
azimvec=azimvec(I,:);
%FITTING
%[A,m,s]=gaussfit([1,0,pi/6],azimvec(:,1),azimvec(:,2),[.99,-pi/180,dtheta],[1.2,pi/180,pi/2],'');
[A,m,s,b]=tr_lorentzfit([1,0,pi/6,-1],azimvec(:,1),azimvec(:,2),[.99,-pi/180,dtheta,-10],[100,pi/180,pi/2,20],'');

%Tom Riis: Used theta directly from az1: getting poor match otherwise
%theta=[0:dtheta:pi/2]';
az_fit(:,1)=theta;
az_fit(:,2)=zeros(length(theta),1);
az_patch(:,1)=theta;
az_patch(:,2)=zeros(length(theta),1);
%TEST COUNTING filled


for i=1:length(theta)
    az_fit(i,2)=(A*0.5*s./((((theta(i)-m).^2)+((0.5*s)^2))))+b;
      if ~isempty(find(azimvec(:,1)==theta(i),1))
          az_patch(i,2)=azimvec(find(azimvec(:,1)==theta(i),1),2);
          
      else
        %Correct pixels around zero value point as well
        if i-20>0 && i+20<length(theta)
            for k=i-20:i+20
            az_patch(k,2)=(A*0.5*s./((((theta(k)-m).^2)+((0.5*s)^2))))+b;
            end 
        else
            az_patch(i,2)=(A*0.5*s./((((theta(i)-m).^2)+((0.5*s)^2))))+b;
        end
      
      end
end
%end
% disp('**********')
% count/length(theta)
% disp('**********')
%Calculate herman value from both the raw data and the fitted data
msc_num_fit=trapz(az_fit(:,1),az_fit(:,2).*sin(az_fit(:,1)).*cos(az_fit(:,1)).^2);
msc_denom_fit = trapz(az_fit(:,1),az_fit(:,2).*sin(az_fit(:,1)));

msc_num_patch = trapz(az_patch(:,1),az_patch(:,2).*sin(az_patch(:,1)).*cos(az_patch(:,1)).^2);
msc_denom_patch = trapz(az_patch(:,1),az_patch(:,2).*sin(az_patch(:,1)));

% figure; clf; 
% a = azimvec(:,2).*sin(azimvec(:,1)).*(cos(azimvec(:,1).^2)); 
% b = azimvec(:,2).*sin(azimvec(:,1));
% plot(a./b);
% axis tight; grid on;
%OUTPUT azimuthal is fitted data

% calculate hermans using mean square cosine
msc_fit=msc_num_fit/msc_denom_fit;

msc_patch = msc_num_patch/msc_denom_patch;

hfit = 0.5*(3*msc_fit - 1);
hpatch = 0.5*(3*msc_patch - 1);
end