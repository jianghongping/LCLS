function [azv] = azimuthal_masked(mat,xc,yc,dtheta,r,window,theta,theta_end)

% azimuthal.m generates a full azimuthal scan around a desired center point
% of a matrix

% window is window size in pixels +/- from center radius

% r is "center" radius in pixels; value is taken at this radius and at each
% pixel "distance" across the window
% dtheta is azimuthal increment in radians
% does a full azimuthal scan

i = 1;
crow = yc;
ccol = xc;
mask=mat==0;

if (theta <= theta_end)

while (theta <= theta_end)
    laz = 0;
    for j = 1:(window * 2 + 1);
        rloc = r - window + j - 1;
        xloc = crow - rloc * sin(theta);
        yloc = ccol + rloc * cos(theta);
        
        laz(j) = matrixave_masked(mat, mask, xloc, yloc);
    end
%Tom Riis: added conditional to overide laz(find(laz))=NaN when Laz is
%zeros
    if isempty(find(laz,1))
        laz=0;
    else
        laz = mean(laz(find(laz)));
    end
    azv(i,:) = [theta, laz]; 
    theta = theta + dtheta;
    i = i + 1;
end
%Tom Riis: moving these to herm
%I=find(azv(:,2));
%azv=azv(I,:);

end

if (theta >= theta_end)

dtheta = -1*dtheta;
    
while (theta >= theta_end)
    laz = 0;
    for j = 1:(window * 2 + 1);
        rloc = r - window + j - 1;
        xloc = crow - rloc * sin(theta);
        yloc = ccol + rloc * cos(theta);
        
        laz(j) = matrixave_masked(mat, mask, xloc, yloc);
    end
    if isempty(find(laz,1))
        laz=0;
    else
        laz = mean(laz(find(laz)));
    end
    azv(i,:) = [theta, laz]; 
    theta = theta + dtheta;
    i = i + 1;
end
%Tom Riis: moving these to herm
%I=find(azv(:,2));
%azv=azv(I,:);

end