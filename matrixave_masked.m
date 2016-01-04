%gets the average of cells around a non-integer point in a matrix. If any
%or all of the cells around the point (x,y) are masked, the code does not
%include them in the average. If all of the cells around the point are
%masked, the function returns 0. Hopefully all of the functions and scripts 
%that call this one know what that means and handle it appropriately.

function a = matrixave_masked(mat, mask, x, y)

if and(mod(x, 1) == 0, mod(y, 1) == 0)
    b = ~mask(x,y)*mat(x,y);
elseif and(not(mod(x, 1) == 0), not(mod(y, 1) == 0))
    b = ((floor(x+1)-x)*(matrixave_masked(mat,mask,floor(x),y)+(mask(floor(x),floor(y))&&mask(floor(x),floor(y+1)))*matrixave_masked(mat,mask,floor(x+1),y))...
        +(x-floor(x))*(matrixave_masked(mat,mask,floor(x+1),y)+(mask(floor(x+1),floor(y))&&mask(floor(x+1),floor(y+1)))*matrixave_masked(mat,mask,floor(x),y)))...
        *~(mask(floor(x),floor(y))&&mask(floor(x),floor(y+1))&&mask(floor(x+1),floor(y))&&mask(floor(x+1),floor(y+1)));
elseif not(mod(x, 1) == 0)
        b = ((floor(x+1)-x)*(~mask(floor(x),y)*mat(floor(x),y)+mask(floor(x),y)*mat(floor(x+1),y))...
            +(x-floor(x))*(~mask(floor(x+1),y)*mat(floor(x+1),y)+mask(floor(x+1),y)*mat(floor(x),y)))*~(mask(floor(x),y)&&mask(floor(x+1),y));    
elseif not(mod(y, 1) == 0)
        b = ((floor(y+1)-y)*(~mask(x,floor(y))*mat(x,floor(y))+mask(x,floor(y))*mat(x,floor(y+1)))...
            +(y-floor(y))*(~mask(x,floor(y+1))*mat(x,floor(y+1))+mask(x,floor(y+1))*mat(x,floor(y))))*~(mask(x,floor(y))&&mask(x,floor(y+1)));
end

a = b;