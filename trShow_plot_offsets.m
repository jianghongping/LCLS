function trShow_plot_offsets(storeim, imagelist, offset, xc, yc,saxsi,raz,prefix)
mkdir('output','OffsetFiles')
s = 1;
% s = 0  -> plot all images with their centers
% s != 0 -> plot s-th image with its center
% close all;
window=10;
dtheta=0.002181661564993;
 th_st1 = -pi/6;
%    th_st1 = -5*pi/180; % for beamcenter close to detector's bottom
    th_ed1 = pi/6;
 
    th_st2 = 5*pi/6;
    th_ed2 = 7*pi/6;
%    th_ed2 = 185*pi/180; % for beamcenter close to detector's bottom

for k=1:length(imagelist)
    xy{k}=showAzimuthal(saxsi(k).images, xc, yc, dtheta, raz(k), window, th_st1, th_ed1);
    
    xy2{k}=showAzimuthal(saxsi(k).images, xc, yc, dtheta, raz(k), window, th_st2, th_ed2);
end





figure;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if s == 1
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

    
% if s == 0
%     for i=1:length(imagelist)
%         
%         xxvals = 1:1:size(storeim(i).images,2);
%         yxvals = 1:1:size(storeim(i).images,2);
% 
%         subplot(xsize, ysize, i);
%         imagesc(storeim(i).images); hold on;
% 
%         xyvals = yc - (xxvals - xc)*tan(offset(i));
%         plot(xxvals,xyvals,'k-');
%         yyvals = yc - (xc - xxvals)/tan(offset(i));
%         plot(yxvals,yyvals,'k-');
% 
%         title(imagelist(i).name); hold on;
%         
%     end
% elseif s > 0
%     imagesc(storeim(s).images); hold on;
%     title(imagelist(s).name); hold on;
% end
for s=1:length(imagelist)
    figure;
    xxvals = 1:1:size(storeim(s).images,2);
    yxvals = 1:1:size(storeim(s).images,2);
    imagesc(storeim(s).images); hold on;
    xyvals = yc - (xxvals - xc)*tan(offset(s));
    plot(xxvals,xyvals,'k-');
    yyvals = yc - (xc - xxvals)/tan(offset(s));
    plot(yxvals,yyvals,'k-');
    plot(xy{s}(:,2),xy{s}(:,1),'b*')
    plot(xy2{s}(:,2),xy2{s}(:,1),'b*') 
    title(imagelist(s).name); hold on;
    caxis([0 200]);
    imfname = strcat('output/OffsetFiles/',num2str(s));
    saveas(gcf, imfname, 'tiffn');
    hold off;
    close
end

end