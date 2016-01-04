function []=average_image_stack(direc,outdirec,n,delim,prefix,isint)
%average_image_stack takes every n images from direc, averages
%them, and saves them in outdirec. The images should have an index in the 
%file name in order to guarantee that they show up in the right order. The 
%index should be separated from the rest of the file name by the delimiter 
%delim. There can be other things separated from each other by delim, but 
%the index will be a number preceded by prefix. If you specify isint=1, the
%filename it returns will have an integer index attached, if isint=0, it
%won't necessarily return an integer index.

%Convert input n (whole range to average over) to functional n (how many
%images on each side to reach)
n=(n-1)/2;

imagelist=parse_direc(direc,delim);

%find index
for i=1:length(imagelist)
    imagelist(i).index=str2double(strtok(imagelist(i).token{find(~isnan(str2double(strtok(imagelist(i).token,prefix))))},prefix));
end
fileprefix='';
for i=find(isnan(str2double(strtok(imagelist(1).token,prefix))))
    if isempty(fileprefix)
        fileprefix=imagelist(1).token{i};
    else
        fileprefix=strcat(fileprefix,delim,imagelist(1).token{i});
    end
end

%sort
[~,I]=sort([imagelist.index]);
Imagelist=imagelist(I);
clear imagelist
imagelist=Imagelist;
clear Imagelist

%divide list into increments
numgroups=floor(length(imagelist)/(2*n+1));
offset=0;
if numgroups==0 %Implies trying to average more images than there are
    numgroups=1;
    n=(length(imagelist)-1)/2;
elseif numgroups*(2*n+1)~=length(imagelist) %length(imagelist) not a multiple of 2n+1
    offset=ceil(length(imagelist)-numgroups*(2*n+1));
end
offset=offset+1;

%process
for i=1:numgroups
    group=[offset:(offset+2*n)]+(i-1)*(2*n+1);
    imout=im_avg(direc,imagelist(group));
    index=mean([imagelist(group).index]);
    if isint
        index=floor(index);
    end
    save(strcat(outdirec,'/',fileprefix,delim,'averaged',delim,prefix,num2str(index),'.mat'),'imout')
    clear imout
end

end