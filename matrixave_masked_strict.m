% gets the average of cells around a non-integer point in a matrix. If any
% of the cells around the non-integer point are masked, the code returns 0

function a = matrixave_masked_strict(mat, mask, x, y)

if and(mod(x, 1) == 0, mod(y, 1) == 0)
    b = ~mask(x,y)*mat(x, y);
elseif and(not(mod(x, 1) == 0), not(mod(y, 1) == 0))
    b = ~(mask(floor(x),floor(y))||mask(floor(x),floor(y+1))||mask(floor(x+1),floor(y))||mask(floor(x+1),floor(y+1)))...
        *((floor(x+1) - x)*matrixave_masked_strict(mat, mask, floor(x), y) + (x-floor(x))*matrixave_masked_strict(mat, mask, floor(x + 1), y));
elseif not(mod(x, 1) == 0)
        b = ~(mask(floor(x),y)||mask(floor(x+1),y))*((floor(x+1) - x)*mat(floor(x), y) + (x-floor(x))*mat(floor(x + 1), y));    
elseif not(mod(y, 1) == 0)
        b = ~(mask(x,floor(y))||mask(x,floor(y+1)))*((floor(y+1) - y)*mat(x, floor(y)) + (y-floor(y))*mat(x, floor(y+1)));
end

a = b;