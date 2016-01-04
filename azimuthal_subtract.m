function azv = azimuthal_subtract(mat,xc,yc,dtheta,r,window,theta,theta_end)

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

if (theta <= theta_end)

while (theta <= theta_end)
    laz = 0;
    for j = 1:(window * 2 + 1);
        rloc = r - window + j - 1;
        xloc = crow - rloc * sin(theta);
        yloc = ccol + rloc * cos(theta);
        laz(j) = matrixave(mat, xloc, yloc);
    end
    laz = mean(laz);
    azv(i,:) = [theta, laz]; 
    theta = theta + dtheta;
    i = i + 1;
end

end

if (theta >= theta_end)

dtheta = -1*dtheta;
    
while (theta >= theta_end)
    laz = 0;
    for j = 1:(window * 2 + 1);
        rloc = r - window + j - 1;
        xloc = crow - rloc * sin(theta);
        yloc = ccol + rloc * cos(theta);
        laz(j) = matrixave(mat, xloc, yloc);
    end
    laz = mean(laz);
    azv(i,:) = [theta, laz]; 
    theta = theta + dtheta;
    i = i + 1;
end

end

azv(:,2) = azv(:,2) - min(azv(:,2));  % substract trough value at pi/2