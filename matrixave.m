% gets the average of cells around a non-integer point in a matrix

function a = matrixave(mat, x, y)

if and(mod(x, 1) == 0, mod(y, 1) == 0)
    b = mat(x, y);
elseif and(not(mod(x, 1) == 0), not(mod(y, 1) == 0))
    b = (floor(x+1) - x)*matrixave(mat, floor(x), y) + (x-floor(x))*matrixave(mat, floor(x + 1), y);
elseif not(mod(x, 1) == 0)
        b = (floor(x+1) - x)*mat(floor(x), y) + (x-floor(x))*mat(floor(x + 1), y);    
elseif not(mod(y, 1) == 0)
        b = (floor(y+1) - y)*mat(x, floor(y)) + (y-floor(y))*mat(x, floor(y+1));
end

a = b;