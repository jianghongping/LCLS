function [imout]=im_avg(direc,imagelist)
%im_avg takes the images specified by imagelist and averages them to make a 
%single image imout. This only works if all of the images in imagelist are 
%the same size.

%load images
for i=1:length(imagelist)
    if strcmp(imagelist(i).filetype,'.mat') %only works if the image is the only thing in the .mat file
        imagelist(i).image=double(importdata(strcat(direc,'/',imagelist(i).name)));
    elseif strcmp(imagelist(i).filetype,'.fits')
        imagelist(i)=fliplr(flipud(fitsread(strcat(direc,'/',imagelist(i).name),'image')));
    elseif strcmp(imagelist(i).filetype,'.gb')
        fid=fopen(strcat(direc,'/',imagelist(i).name));
        imagelist(i).image=fread(fid);
    end
end
imout=zeros(size(imagelist(1).image));

%Final averaging
for i=1:length(imagelist)
    imout=imout+imagelist(i).image;
end
imout=imout/length(imagelist);
clear imagelist

end