%This code guides the user through the process of making a mask using the
%one and only image in imagerun as a guide. I don't have enough time to 
%teach it to do anything as fancier than rectangles, but you can compose a 
%mask out of multiple rectangles
% clear all
% close all
% warning off all
% clc

sample=parse_direc('imagerun','_');

mkdir('Masks')

%Display image from imagerun
if strcmp(sample.filetype,'.mat')
    I=importdata(strcat('imagerun/',sample.name));
    f1=figure;
    imagesc(I)
    set(gca,'DataAspectRatio',[1,1,1])
elseif strcmp(sample.filetype,'.fits')
    I=fliplr(flipud(fitsread(strcat('imagerun/',sample.name),'Image')));
    f1=figure;
    imagesc(I)
    set(gca,'DataAspectRatio',[1,1,1])
end

loadprevmask=input('Would you like to add to an existing mask? [1=yes] > ');

if loadprevmask
    prevmasklist=parse_direc('Masks/*.mat','_');
    prevmasklist.name
    prevmaskid=input('Which of these masks would you like to add to? Please use its position in the above list > ');
    mask=importdata(strcat('Masks/',prevmasklist(prevmaskid).name));
else
    mask=zeros(size(I));
    f2=figure;
end

on=[];
while isempty(on)
    commandwindow
    disp(' ')
    disp('Please resize the window as you wish, then indicate two opposite corners of a rectangle')
    figure(f1)
    imagesc(I, [0 15])
    set(gca,'DataAspectRatio',[1,1,1])
    x=zeros(1,2);
    y=zeros(1,2);
    a=input('> ');
    [x(1),y(1)]=ginput(1);
    a=input('> ');
    [x(2),y(2)]=ginput(1);
    %add new rectangle to mask
    Mask=mask;
    J=I;
    if (x(1)>x(2))&&(y(1)>y(2))
        x(1)=ceil(x(1));
        x(2)=floor(x(2));
        y(1)=ceil(y(1));
        y(2)=floor(y(2));
        Mask(y(2):y(1),x(2):x(1))=ones(y(1)-y(2)+1,x(1)-x(2)+1);
    elseif (x(1)<x(2))&&(y(1)>y(2))
        x(1)=floor(x(1));
        x(2)=ceil(x(2));
        y(1)=ceil(y(1));
        y(2)=floor(y(2));
        Mask(y(2):y(1),x(1):x(2))=ones(y(1)-y(2)+1,x(1)-x(2)+1);
    elseif (x(1)>x(2))&&(y(1)<y(2))
        x(1)=ceil(x(1));
        x(2)=floor(x(2));
        y(1)=floor(y(1));
        y(2)=ceil(y(2));
        Mask(y(1):y(2),x(2):x(1))=ones(y(2)-y(1)+1,x(1)-x(2)+1);
    elseif (x(1)<x(2))&&(y(1)<y(2))
        x(1)=floor(x(1));
        x(2)=ceil(x(2));
        y(1)=floor(y(1));
        y(2)=ceil(y(2));
        Mask(y(1):y(2),x(1):x(2))=ones(y(2)-y(1)+1,x(2)-x(1)+1);
    end
    
    for i=1:size(J,1)
        for j=1:size(J,2)
            if Mask(i,j)
                J(i,j)=0;
            end
        end
    end
    figure(f2)
    imagesc(J,[0 15])
    set(gca,'DataAspectRatio',[1,1,1])
    a=input('> ');
    goodbox=input('Are you satisfied with the rectangle you just added? [1=yes] > ');
    if goodbox
        mask=Mask;
        I=J;
        save(strcat('Masks/',strtok(sample.name,'.'),'-mask.mat'),'mask','I')
    end
    clear Mask
    clear J
    
    commandwindow
    on=input('[enter] to include another rectangle, anything else to finish > ');
end

