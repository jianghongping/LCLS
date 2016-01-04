% Last updated on 24-OCT-2011

%Created to optimize the incidance angle hen doing GISAXS, by loading a
%;list of miages for a scan of GI angles, and finiding the one with maximum
%total intensity.

%This approach is aimed at finding a quantitative criteria for finding the
%GI angle to use, and is aimed at replacing the sample alignment procedure
%that is necessary for GI.



clear all; format long; close all; clc;

%Specify the angles
DATAchoice = input('Do you want to input new values? [1], OR use default values(-0.4 0.4 0.02)? [else]> ','s'); % in degrees
disp(' ');
disp(' ');
if isempty(DATAchoice)
    offchoice = '0';
end
if DATAchoice ~= '1'
    minGI = input('First GI-angle scanned (in degrees)> ','s'); % in degrees
    disp(' ');
    maxGI = input('Last GI-angle scanned (in degrees)> ','s'); % in degrees
    disp(' ');
    stepGI = input('Increment of GI-angle scan (in degrees)> ','s'); % in degrees
    disp(' ');
    disp(' ');
    disp(' ');
    
    minGI = str2num(minGI);
    maxGI = str2num(maxGI);
    stepGI = str2num(stepGI);
else
    minGI = -.4;
    maxGI = .4;
    stepGI = 0.02;
end



rangeGI = [minGI: stepGI: maxGI];


% get list of images to read

imagelist = dir('imagerun/*.tif*');  % CHESS


% Defining number of images at a given holder
imagenum = size(imagelist, 1);

%read images
for k = 1 : imagenum
    
    % read images one by one
    imagepath = strcat('imagerun/',imagelist(k).name);
    images(k).name = imread(imagepath);
    
    % image named as saxsi
    saxsi = images(k).name;
    
    % cast from integer to double
    saxsi = double(saxsi);
    %saxsi = im2double(saxsi);
    saxsi = 65536 * saxsi;
    
    
    saxsi = fliplr(saxsi);
    
    saxsia = abs(saxsi);
    saxsiaa = abs(saxsia);
    saxsiaaf = (max(saxsiaa)/min(saxsiaa))*saxsiaa;
    
    warning off MATLAB:log:logOfZero
    
    saxsial = log(saxsiaaf);
    
    % store image info for later plots
    saxs(k).images = saxsi;
    storeim(k).images = saxsial;
    
end




for k = 1: imagenum
    TOTALintensity (k) = sum(sum(saxs(k).images));
end

%plot it
figure

hold on
plot(rangeGI,TOTALintensity ,'bx-','LineWidth',2)
xlabel('Incidence angle [degrees]');
ylabel('Total scattering intensity [a.u.]');
grid on;
%FIND OPTIMUM GI angle

[MAXintens MAXintens_I] = max(TOTALintensity);



disp('Optimum incidence angle is');disp(rangeGI(MAXintens_I));
disp(' ');
disp('File number is'); disp(MAXintens_I-1);

plot(rangeGI(MAXintens_I),TOTALintensity (MAXintens_I),'ro','LineWidth',2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

