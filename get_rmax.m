function rmax = get_rmax(mat, xc, yc, thetamin, thetamax)

[rows cols] = size(mat);

factor = 200;
thetamax = max(thetamin, thetamax);
% rmax = scanning radius; min used to avoid out of index
% rmax = min([cols - xc, rows - yc, xc, yc])

if xc > cols - xc
    
    rmax.direction = 'l';
    length1 = abs([yc xc] - [1 1]);
    length1 = floor(sqrt(length1(1)^2 + length1(2)^2));
    length1 = floor(length1 * cos(abs(thetamax)));
    length2 = abs([yc xc] - [rows 1]);
    length2 = floor(sqrt(length2(1)^2 + length2(2)^2));
    length2 = floor(length2 * cos(abs(thetamax)));
    rmax_temp = min(length1, length2);
    
    if length(rmax_temp) > 1
        rmax.length = rmax_temp(1) - factor;
    else
        rmax.length = rmax_temp - factor;
    end
    
else
    
    rmax.direction = 'r';
    length1 = abs([yc xc] - [1 cols]);
    length1 = floor(sqrt(length1(1)^2 + length1(2)^2));
    length1 = floor(length1 * cos(abs(thetamax)));
    length2 = abs([yc xc] - [rows cols]);
    length2 = floor(sqrt(length2(1)^2 + length2(2)^2));
    length2 = floor(length2 * cos(abs(thetamax)));
    rmax_temp = min(length1, length2);
    
    if length(rmax_temp) > 1
        rmax.length = rmax_temp(1) - factor;
    else
        rmax.length = rmax_temp - factor;
    end
    
end