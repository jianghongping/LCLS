% CSFF processing of transmission SAXS images

% FLICAM WITH CAPILLARY CHESS MAY 08
% SUBTRACTS BACKGROUND FROM TOP LEFT ONLY: [50:100,50:100]
function [out]=Total_Intesities()
clear all; format long; close all; clc;

sampprefix = 'run14waxs-test';
fpath = 'output';
mkdir(fpath,sampprefix)
fpath=strcat(fpath,'/',sampprefix,'/');
sampprefix = strcat(fpath,'/',sampprefix,'-');
mask=dir('Masks/*waxs*');
mask.mask=importdata(strcat('Masks/',mask.name));
%SDD=2043;       %LCLS CXI SAXS detector
SDD=93;         %LCLS CXI WAXS detector
pix=.10992;     %LCLS CXI PAD detectors

dark=dir('Dark/*dark*');
dark.dark=double(importdata(strcat('Dark/',dark.name)));
dark.dark=dark.dark.*~mask.mask.mask;
dark.dark = rot90(dark.dark);
dark.dark = rot90(dark.dark);
% ALS P-CAM 1M jan/14
% pixel_conversion = 1; % uncalibrated
% pixel_conversion = ; % 4*pi/12.3984*sin(atan(x*172e-3/174.63)) calibrated 3/4/14

% ALS P-CAM 1M jan/14
% pixel_conversion = 1; % uncalibrated
% pixel_conversion = 1.0763/234.405; % calibrated 1/29/14
% pixel_conversion = 4/981; % estimated from aug/13

% P-CAM oct/11
% pixel_conversion = 0.0072;
% pixel_conversion = 0.0042;

% % FLICAM may/09
% pixel_conversion = 0.0068;


% Fitting range
% Fractions of distance measured from valley to peak
fitdn = 6/3;
fitup = 9/3;

% Fitting parameter range
limit.A = [0.98 1.02];

limit.D = [7 8];
limit.sD = [1.0 2.0];
limit.c = [0.6 0.7]; % c applies only if t is not specified

stv.A = mean(limit.A);
stv.D = min(limit.D);
stv.sD = min(limit.sD);
stv.c = mean(limit.c);

% Location used for spacing I-q scans on graphical output
scaleloc = 10; % [nm^-1]
%scaleloc = 100;
%scaleloc = floor(scaleloc/pixel_conversion);

% Center finding choice: semi-automatic [1] or graphical/manual [0]
center_finding = 1;

% CCD type choice: circular @ brookhaven [1] or square @ CHESS (flicam) [0]
% determines type of background subtraction
ccd_type = 0;

% Beamstop position choice: 
% right (quadrant 3 only) [0]
% center (symmetric) [1]
% left (quadrant 1 only) [2]
beamstop_position = 1;

% % Scanning arm length [pixels]
% if beamstop_position == 1
% %     rmax = 150;
%     rmax = 1730/2;      %LCLS
% else
%     rmax = 900;
% end

% get list of images to read
if ccd_type == 0; 
%     imagelist = dir('imagerun/*.tif*');  % CHESS
%     imagelist = dir('imagerun/*.edf*');  % ALS
%     imagelist = dir('imagerun/*.gb*');  % ALS
    imagelist = dir('imagerun/*.mat*');  % LCLS
else
    imagelist = dir('imagerun/*.00*');   % Brookhaven
end

% Defining number of images at a given holder
imagenum = size(imagelist, 1);

offset_theta=zeros(1,imagenum);
allinfo_A = zeros(imagenum,1);
allinfo_D = zeros(imagenum,1);
allinfo_sD = zeros(imagenum,1);
allinfo_c = zeros(imagenum,1);
R2_ = zeros(imagenum,2);
SSE = zeros(imagenum,2);
scanning_angle_profile = zeros(imagenum, 2);
start_fitting = 'n';

% Save a copy of original limits
orig_limit = limit;

% Integration scanning angle; CONFINE THESE LIMITS IF SCANNER IS RUNNING OUT OF BOUNDS

if beamstop_position == 0 % right
    thetamin = 170*pi/180;
    thetamax = 190*pi/180;
    herm_start = pi/2;
    herm_end = pi;
elseif beamstop_position == 1 % center
    thetamin=-10*pi/180;     
    thetamax=10*pi/180;    
    herm_start=0;
    herm_end=pi/2;
else % left
    thetamin = -10*pi/180;
    thetamax = 10*pi/180;
    herm_start = pi/2;
    herm_end = 0;
end

thetasteps = 50;

% Scanning angle step size
dtheta = 0.25*pi/360;
window = 10;

% X-axis scale either in Height or Time
% x1 = ['Image #'];
% x1 = ['Height [mm]'];   % ex situ
x1 = 'Distance from base of VACNT [mm]';   % ex situ
% x1 = ['Time [s]'];      % in situ

% % Starting time or height
% start = 5;
% % Increment (uniform), later we could give non-uniform increments
% increment = 5;
% 
% height = (start : increment : (start + increment * (imagenum-1)));

% read all images that are in the designated folder
[storeim, saxsi] = read_all_images_LCLSmat_masked(imagelist,imagenum,mask.mask.mask);
logdata_path=dir('imagerun/*.txt');
logdata=importdata(strcat('imagerun/',logdata_path.name));
for k=1:length(saxsi)
    [~,remainder]=strtok(imagelist(k).name,'_');
    while ~isempty(remainder)
        [token,remainder]=strtok(remainder,'_');
    end
    index=strtok(token,'_');
    saxsi(k).index=str2double(strtok(index,'.'));
    saxsi(k).energy=logdata(saxsi(k).index,10);
    saxsi(k).x=logdata(saxsi(k).index,5);
    saxsi(k).y=logdata(saxsi(k).index,6);
    saxsi(k).z=logdata(saxsi(k).index,7);
    %NORMALIZING image by pulse energy * transmission. saxsi.raw is
    %original image
    sumout{1}{k}=imagelist(k).name;
    saxsi(k).images=saxsi(k).images-dark.dark;
    sumout{2}{k}=sum(sum(saxsi(k).images));
    sumout{3}{k}=saxsi(k).images;
    saxsi(k).raw=saxsi(k).images;
    transmission=logdata(saxsi(k).index,11);
    pulseEnergy=logdata(saxsi(k).index,9);
    saxsi(k).images=saxsi(k).images/(transmission*pulseEnergy);
end

out(:,1)=sumout{1};
out(:,2)=sumout{2};

end






