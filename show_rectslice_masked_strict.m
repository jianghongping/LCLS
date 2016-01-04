function [polmap, darc] = show_rectslice_masked_strict(mat, xc, yc, thetamin, thetamax,...
    thetasteps, rmax, offset_theta)

% rectslice.m converts a region of a rectangular matrix to a polar map
% thetasteps = steps in theta in half of the total integrated angle

rlength = rmax;
mask=mat==0;

dtheta = (thetamax - thetamin) / (2 * thetasteps);
thetamaxr = thetamax - dtheta / 2;
polmap = zeros(rlength, (2*thetasteps));
darc = zeros(rlength,1);

for i = 1 : rlength
    for j = 1 : (2 * thetasteps)
        thetaloc = thetamaxr - dtheta*(j - 1) + offset_theta;
        xy = showmatrixave(mat, yc - i*sin(thetaloc), xc + i*cos(thetaloc));
        value=mat(floor(xy(1)),floor(xy(2)));
        mat(floor(xy(1)),floor(xy(2)))=50.3453;
    end         
    darc(i) = i * dtheta;
end

figure
imagesc(mat)
set(gca,'DataAspectRatio',[1,1,1])
title('Show Rectslice')
hold on

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