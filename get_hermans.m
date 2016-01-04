function [az h_ave q1 q2 q3 q4] = get_hermans(simage, xc, yc,...
    dtheta, radius, window, offset)

[row col] = size(simage);
sf = 100;    % safety factor
counter = 0;
theta_ = (0:dtheta:2*pi)';
az = zeros(length(theta_),2);
az(:,1) = theta_;
mark = ceil((2*pi)/(dtheta)) / 4;
h1 = 0;
h2 = 0;
h3 = 0;
h4 = 0;

% check quadrant # 1

if (xc + radius + sf) < col && (yc - radius - sf) > 0
    theta_start = 0 + offset;
    theta_end = pi/2 + offset;
    az1 = azimuthal(simage, xc, yc, dtheta, radius,...
        window, theta_start, theta_end);
    h1 = hermans(az1);
    az(1:size(az1,1),:) = az1;
    counter = counter + 1;
    q1 = 1;
end

% check quadrant # 2
if (yc - radius - sf) > 0 && (xc - radius - sf) > 0
    theta_start = pi/2 + offset;
    theta_end = pi + offset;
    az2 = azimuthal(simage, xc, yc, dtheta, radius,...
        window, theta_start, theta_end);
    h2 = hermans(az2);
    az(mark+1:mark+size(az2,1),:) = az2;
    counter = counter + 1;
    q2 = 1;
end

% check quadrant # 3
if (xc - radius - sf) > 0 && (yc + radius + sf) < row
    theta_start = pi + offset;
    theta_end = 3/2*pi + offset;
    az3 = azimuthal(simage, xc, yc, dtheta, radius,...
        window, theta_start, theta_end);
    h3 = hermans(az3);
    az((2*mark+1):(2*mark+size(az3,1)),:) = az3;
    counter = counter + 1;
    q3 = 1;
end

% check quadrant # 4
if (yc + radius + sf) < col && (xc + radius + sf) < row    
    theta_start = 3/2*pi + offset;
    theta_end = 2*pi + offset;
    az4 = azimuthal(simage, xc, yc, dtheta, radius,...
        window, theta_start, theta_end);
    h4 = hermans(az4);
    az(3*mark+1:3*mark+size(az4,1),:) = az4;
    counter = counter + 1;
    q4 = 1;
end


h_ave = (h1 + h2 + h3 + h4) / counter;