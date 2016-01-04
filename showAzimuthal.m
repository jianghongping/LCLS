function [xy] = showAzimuthal(mat,xc,yc,dtheta,r,window,theta,theta_end)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
i = 1;
crow = yc;
ccol = xc;
counter=0;
counter2=0;
if (theta <= theta_end)

count=1;
while (theta <= theta_end)
    laz = 0;
    for j = 1:(window * 2 + 1);
        rloc = r - window + j - 1;
        xloc = crow - rloc * sin(theta);
        yloc = ccol + rloc * cos(theta);
        holder=showmatrixave(mat, xloc, yloc);
        xy(count,1)=floor(holder(1));
        xy(count,2)=floor(holder(2));
        count=count+1;
%         value=mat(floor(xy(1)),floor(xy(2)));
%         if (value==50.3453)
%             counter=counter+1;
%         end
%         counter2=counter2+1;
%         mat(floor(xy(1)),floor(xy(2)))=50.3453;
    end
    laz = mean(laz);
    azv(i,:) = [theta, laz]; 
    theta = theta + dtheta;
    i = i + 1;
end

end

if (theta >= theta_end)

dtheta = -1*dtheta;
    
count=1;
while (theta <= theta_end)
    laz = 0;
    for j = 1:(window * 2 + 1);
        rloc = r - window + j - 1;
        xloc = crow - rloc * sin(theta);
        yloc = ccol + rloc * cos(theta);
        holder=showmatrixave(mat, xloc, yloc);
        xy(count,1)=floor(holder(1));
        xy(count,2)=floor(holder(2));
        count=count+1;
%         value=mat(floor(xy(1)),floor(xy(2)));
%         if (value==50.3453)
%             counter=counter+1;
%         end
%         counter2=counter2+1;
%         mat(floor(xy(1)),floor(xy(2)))=50.3453;
    end
    laz = mean(laz);
    azv(i,:) = [theta, laz]; 
    theta = theta + dtheta;
    i = i + 1;
end


end

function b = showmatrixave(mat, x, y)
%gets indicies that matrixave calls

if and(mod(x, 1) == 0, mod(y, 1) == 0)
    b = [x, y];
%elseif and(not(mod(x, 1) == 0), not(mod(y, 1) == 0))
 %   b = (floor(x+1) - x)*showmatrixave(mat, floor(x), y) + (x-floor(x))*showmatrixave(mat, floor(x + 1), y);
elseif not(mod(x, 1) == 0)
        b = [floor(x),y];    
elseif not(mod(y, 1) == 0)
        b = [x,floor(y)];
end





