function [A] = OpenEDF(filename)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[fileID,errmsg] = fopen(filename);
fseek(fileID, 1024, 'bof');
[A, count] = fread(fileID,[981,1043],'*int32','l'); % 1M
% [A, count] = fread(fileID,[487,195],'*int32','l'); % 100k
A=fliplr(A);
A=rot90(A);
clims = [0 10000];
colormap(hot);
imagesc(A,clims);
end

