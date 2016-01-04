function [box_coord_A xLine_A] = get_center_all(storeim, imagelist, xind, yind, user_I)

for i = 1 : length(storeim)
    [box_coord_A(:,:,i) xLine_A(:,:,i)] = findEdge(xind, yind, storeim(i).images, user_I);
plot_center_redo(storeim(s).images, imagelist(s).name, box_coord, xLine);
end
