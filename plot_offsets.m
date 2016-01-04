function plot_offsets(storeim, imagelist, offset, xc, yc)

s = 0;
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

    
if s == 0
    for i=1:length(imagelist)
        
        xxvals = 1:1:size(storeim(i).images,2);
        yxvals = 1:1:size(storeim(i).images,2);

        subplot(xsize, ysize, i);
        imagesc(storeim(i).images); hold on;

        xyvals = yc - (xxvals - xc)*tan(offset(i));
        plot(xxvals,xyvals,'k-');
        yyvals = yc - (xc - xxvals)/tan(offset(i));
        plot(yxvals,yyvals,'k-');

        title(imagelist(i).name); hold on;
        
    end
elseif s > 0
    imagesc(storeim(s).images); hold on;
    title(imagelist(s).name); hold on;
end

hold off;

end