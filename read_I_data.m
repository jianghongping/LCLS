% CSFF curvefitting calibration

clear all; format long; 
clc; close all;

imagelist = dir('*.tif');
imagenum = size(imagelist, 1);

for k = 1 : imagenum
    % read images one by one
    images(k).name = imread(imagelist(k).name);
    
    % display which image is being read
    disp(['Processing ', imagelist(k).name, '.'])
    
    % image named as saxsi
    saxsi = images(k).name;
    
    % cast from integer to double
    saxsi = im2double(saxsi);
    saxsi = 65536*saxsi;
    
    % subtract background (four [bgwin x bgwin] corners)
    backg = background(saxsi);
    
    % substract background
    saxsi = saxsi - backg;
    
    % plot image with logarithimic intensity scale (as in polar)
    saxsi = abs(saxsi);
    saxsia = abs(saxsi);
    saxsia = (max(saxsia)/min(saxsia))*saxsia;
    
    warning off MATLAB:log:logOfZero
    
    saxsial = log(saxsia);
    
    % store image info for later plots
    storeim(k).images = saxsial;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% manually defined center & fit limits
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    yc = 584;
    xc = 815; 
    
    % scan +/- 10 deg off x-axis
%     thetamin = -10*pi/180;
%     thetamax = 10*pi/180;
    
    thetamin = -10*pi/180;
    thetamax = 10*pi/180;
    
    thetasteps = 50;    % (thetamax - thetamin) / (2 * thetasteps)
    [sliceforint, darclengths] = GIrectslice(saxsi,xc,yc,thetamin,...
        thetamax,thetasteps);

    sliceint10 = sum(sliceforint',1).*darclengths;
    startpos = findavemin(sliceint10, 100, 5) + 20; % start searching for maximum here
    maxwin = 5;     % window for finding moving average maximum
    
    raz(k) = findavemax(sliceint10, startpos, maxwin);
    
    % azimuthal scan
    dtheta = 2*pi/360;
    window = 1;
    
    % az1 contains [theta, laz];
    az1 = GIazimuthal(saxsi, xc, yc, dtheta, raz(k), window);
    storeaz(k).theta = az1(:,1);
    storeaz(k).laz = az1(:,2);
    az1
        
    % calculate hermans orientation parameters for each image
    % convert x-axis to q-space based on set sample-detector distance
    % (this is different each time we change the SAXS setup)
    herm(k) = hermans(az1,dtheta);   
    
    qvec = (1:length(sliceint10))*1.856/500;
    humpq = qvec(raz);

    ivsq(k).data = [qvec', sliceint10'];
        
end

xc
yc
herm'
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Rainbow color palette
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rainbow = [1 0 0; 1 140/255 0; 1 1 0; 0 1 0; 0 205/255 0;...
    0 191/255 1; 0 0 238/255; 148/255 0 211/255;...
    1 0 0; 1 140/255 0; 1 1 0; 0 1 0; 0 205/255 0;...
    0 191/255 1; 0 0 238/255; 148/255 0 211/255;...
    1 0 0; 1 140/255 0; 1 1 0; 0 1 0; 0 205/255 0;...
    0 191/255 1; 0 0 238/255; 148/255 0 211/255;...
    1 0 0; 1 140/255 0; 1 1 0; 0 1 0; 0 205/255 0;...
    0 191/255 1; 0 0 238/255; 148/255 0 211/255;...
    1 0 0; 1 140/255 0; 1 1 0; 0 1 0; 0 205/255 0;...
    0 191/255 1; 0 0 238/255; 148/255 0 211/255;...
    1 0 0; 1 140/255 0; 1 1 0; 0 1 0; 0 205/255 0;...
    0 191/255 1; 0 0 238/255; 148/255 0 211/255;...
    1 0 0; 1 140/255 0; 1 1 0; 0 1 0; 0 205/255 0;...
    0 191/255 1; 0 0 238/255; 148/255 0 211/255;...
    1 0 0; 1 140/255 0; 1 1 0; 0 1 0; 0 205/255 0;...
    0 191/255 1; 0 0 238/255; 148/255 0 211/255;...
    1 0 0; 1 140/255 0; 1 1 0; 0 1 0; 0 205/255 0;...
    0 191/255 1; 0 0 238/255; 148/255 0 211/255;...
    1 0 0; 1 140/255 0; 1 1 0; 0 1 0; 0 205/255 0;...
    0 191/255 1; 0 0 238/255; 148/255 0 211/255;...
    1 0 0; 1 140/255 0; 1 1 0; 0 1 0; 0 205/255 0;...
    0 191/255 1; 0 0 238/255; 148/255 0 211/255;...
    1 0 0; 1 140/255 0; 1 1 0; 0 1 0; 0 205/255 0;...
    0 191/255 1; 0 0 238/255; 148/255 0 211/255;...
    1 0 0; 1 140/255 0; 1 1 0; 0 1 0; 0 205/255 0;...
    0 191/255 1; 0 0 238/255; 148/255 0 211/255;...
    1 0 0; 1 140/255 0; 1 1 0; 0 1 0; 0 205/255 0;...
    0 191/255 1; 0 0 238/255; 148/255 0 211/255;...
    1 0 0; 1 140/255 0; 1 1 0; 0 1 0; 0 205/255 0;...
    0 191/255 1; 0 0 238/255; 148/255 0 211/255;...
    1 0 0; 1 140/255 0; 1 1 0; 0 1 0; 0 205/255 0;...
    0 191/255 1; 0 0 238/255; 148/255 0 211/255;...
    1 0 0; 1 140/255 0; 1 1 0; 0 1 0; 0 205/255 0;...
    0 191/255 1; 0 0 238/255; 148/255 0 211/255;...
    1 0 0; 1 140/255 0; 1 1 0; 0 1 0; 0 205/255 0;...
    0 191/255 1; 0 0 238/255; 148/255 0 211/255;...
    1 0 0; 1 140/255 0; 1 1 0; 0 1 0; 0 205/255 0;...
    0 191/255 1; 0 0 238/255; 148/255 0 211/255;...
    1 0 0; 1 140/255 0; 1 1 0; 0 1 0; 0 205/255 0;...
    0 191/255 1; 0 0 238/255; 148/255 0 211/255;...
    1 0 0; 1 140/255 0; 1 1 0; 0 1 0; 0 205/255 0;...
    0 191/255 1; 0 0 238/255; 148/255 0 211/255];


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % color map
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure 
xsize = floor(sqrt(imagenum));
ysize = 1;
if imagenum == 3
    xsize = 2;
    ysize = 2;
end

while (xsize * ysize < imagenum)
    ysize = ysize + 1;
end

for i = 1 : imagenum
    subplot(xsize, ysize, i)
    imagesc(storeim(i).images);
    title([imagelist(i).name]);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% intensity vs. q
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
clear legends
for i = 1 : imagenum
    
    dataIplot = 10.^(log10(ivsq(i).data(:,2)) + ((i-1) * 0.0));
    semilogy(ivsq(i).data(:,1), dataIplot, 'Color', rainbow(i,:));
    hold on;
    
    % make legends
    legends(i).name = [imagelist(i).name];
end

% manual axis control - should automate later
title('Intensity vs. q'); xlabel('q [nm^{-1}]'); ylabel('Intensity [a.u.]');
legend(legends.name, -1); 
% axis([0.6 1.2 1e4 1e6]);
axis tight;
hold off;


% figure
% clear legends
% for i = 1 : imagenum
%     
%     dataIplot = 10.^(log10(ivsq(i).data(:,2)) + ((i-1) * 0.0));
% %     semilogy(ivsq(i).data(:,1), dataIplot, 'Color', rainbow(i,:));
%     plot(ivsq(i).data(:,1), dataIplot, 'Color', rainbow(i,:));
%     hold on;
%     
%     % make legends
%     legends(i).name = [imagelist(i).name];
% end
% 
% % manual axis control - should automate later
% title('Intensity vs. q'); xlabel('q [nm^{-1}]'); ylabel('Intensity [a.u.]');
% legend(legends.name, -1); 
% % axis([0.6 1.2 1e4 1e6]);
% axis tight;
% hold off;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% azimuthal scan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure
% clear legends
% for i = 1 : imagenum
%     plot((180/pi)*storeaz(1).theta, storeaz(i).laz, 'Color', rainbow(i,:));
%     hold on;
%     legends(i).name = ['height = ', int2str(i), '    q = ',...
%         num2str(humpq(i),2), ' nm^{-1}'];
% end
% title('Azimuthal scan'); xlabel(' \phi [deg]'); ylabel('Intensity [a.u.]');
% legend(legends.name, 1);
% grid on; axis tight; hold off;


