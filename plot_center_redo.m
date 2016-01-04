function plot_center_redo(storeim, imagelist, s, box_coord, xLine, focus, offset)

% s = 0  -> plot all images with their centers
% s != 0 -> plot s-th image with its center
% close all;

figure;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if s == 0
    imagenum = length(storeim);

    xsize = floor(sqrt(imagenum));
    ysize = 1;
    if imagenum == 3
        xsize = 2;
        ysize = 2;
    end

    while (xsize * ysize < imagenum)
        ysize = ysize + 1;
    end

elseif s > 0
    imagenum = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1 : imagenum

    if s == 0
        subplot(xsize, ysize, i);
        imagesc(storeim(i).images); hold on;
        title(imagelist(i).name); hold on;
        set(gca,'DataAspectRatio',[1,1,1])

    elseif s > 0
        imagesc(storeim(s).images); hold on;
        title(imagelist(s).name); hold on;
        set(gca,'DataAspectRatio',[1,1,1])

    end
    
    if xLine(1,1,i) == 0            % if it is blank
        xLine(1,1,i) = xLine(6,1,i);
        xLine(1,2,i) = xLine(6,2,i) - 50;
        xLine(2,1,i) = xLine(6,1,i);
        xLine(2,2,i) = xLine(6,2,i) + 50;
        xLine(3,1,i) = xLine(6,1,i) - 50;
        xLine(3,2,i) = xLine(6,2,i);
        xLine(4,1,i) = xLine(6,1,i) + 50;
        xLine(4,2,i) = xLine(6,2,i);        
    end

    plot(box_coord(1,2,i), box_coord(1,1,i), 's'); hold on;
    plot(box_coord(2,2,i), box_coord(2,1,i), 's'); hold on;
    plot(box_coord(3,2,i), box_coord(3,1,i), 's'); hold on;
    plot(box_coord(4,2,i), box_coord(4,1,i), 's'); hold on;

    v1 = abs(xLine(2,2,i) - xLine(1,2,i));
    v2 = abs(xLine(2,1,i) - xLine(1,1,i)); %

    h1 = abs(xLine(4,2,i) - xLine(3,2,i)); %
    h2 = abs(xLine(4,1,i) - xLine(3,1,i));
    
    factor = 2;
    
    xLine(1,2,i) = xLine(1,2,i) - factor*v1;
    xLine(2,2,i) = xLine(2,2,i) + factor*v1;
    xLine(1,1,i) = xLine(1,1,i) + factor*v2;
    xLine(2,1,i) = xLine(2,1,i) - factor*v2;

    xLine(3,2,i) = xLine(3,2,i) - factor*h1;
    xLine(4,2,i) = xLine(4,2,i) + factor*h1;
    xLine(3,1,i) = xLine(3,1,i) - factor*h2;
    xLine(4,1,i) = xLine(4,1,i) + factor*h2;
    
    xc = xLine(6,2);
    yc = xLine(6,1);
    
    cc_rot = [1 0; 0 1];
    
    for j = 1 : 4
        t = ceil(cc_rot * [(xLine(j,2,i) - xc) (yc - xLine(j,1,i))]');
        xLine(j,:,i) = [yc + t(2) xc + t(1)];
    end

    plot(xLine(5,1,i), box_coord(1,1,i), 's'); hold on;
    plot(xLine(5,2,i), box_coord(2,1,i), 's'); hold on;
    plot(xLine(5,1,i), box_coord(3,1,i), 's'); hold on;
    plot(xLine(5,2,i), box_coord(4,1,i), 's'); hold on;

%   plots the center coordinate
    plot(xLine(6,2,i), xLine(6,1,i), 'x', 'LineWidth', 5, 'Color','r');
    
    yclinex = 1:1:size(storeim(i).images,1);
    xcliney = 1:1:size(storeim(i).images,2);

    plot(yclinex,yc*ones(1,size(storeim(i).images,1)),'k-');
    plot(xc*ones(1,size(storeim(i).images,2)),xcliney,'k-');
    
%     axis([0 1024 0 1024])     %Image with size=[1024,1024]
    

    hold off;

end



