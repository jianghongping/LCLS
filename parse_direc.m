function [direc]=parse_direc(dirname,del)
D=dir(dirname);
I=zeros(1,length(D));
J=1;
for i=1:length(D)
    if ~(strncmp(D(i).name,'.',1)||strncmp(D(i).name,'Icon',4))
        I(J)=i;
        J=J+1;
    end
end
K=find(I);
I1=zeros(1,length(K));
for i=1:length(K)
    I1(i)=I(K(i));
end
clear I
I=I1;
clear I1
for i=1:length(I)
    [direc(i).token,direc(i).filetype]=read_filename(D(I(i)).name,del);
    direc(i).name=D(I(i)).name;
    direc(i).isdir=D(I(i)).isdir;
    if D(I(i)).isdir
        direc(i).direc=parse_direc(strcat(dirname,'/',D(I(i)).name),del);
    end
end