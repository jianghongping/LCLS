function [polmap, darc] = rectslice_masked_strict(mat, xc, yc, thetamin, thetamax,...
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
        polmap(i,j) = matrixave_masked_strict(mat, mask, yc - i*sin(thetaloc), xc + i*cos(thetaloc));
    end         
    darc(i) = i * dtheta;
end