% CSFF processing of transmission SAXS images

% FLICAM WITH CAPILLARY CHESS MAY 08
% SUBTRACTS BACKGROUND FROM TOP LEFT ONLY: [50:100,50:100]

clear all; format long; close all; clc;

sampprefix = 'TF0110b1B-FMES109-';
fpath = 'output/';
sampprefix = strcat(fpath,sampprefix);

% ALS P-CAM 1M jan/14
pixel_conversion = 1.0763/234.405; % calibrated 1/29/14
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
scaleloc = 0.4; % [nm^-1]
scaleloc = floor(scaleloc/pixel_conversion);

% Center finding choice: semi-automatic [1] or graphical/manual [0]
center_finding = 0;

% CCD type choice: circular @ brookhaven [1] or square @ CHESS (flicam) [0]
% determines type of background subtraction
ccd_type = 0;

% Beamstop position choice: 
% right (quadrant 3 only) [0]
% center (symmetric) [1]
% left (quadrant 1 only) [2]
beamstop_position = 1;

% Scanning arm length [pixels]
if beamstop_position == 1
%     rmax = 150;
    rmax = 425;
else
    rmax = 90;
end

% get list of images to read
if ccd_type == 0; 
%     imagelist = dir('imagerun/*.tif*');  % CHESS
    imagelist = dir('imagerun/*.gb*');  % ALS
else
    imagelist = dir('imagerun/*.00*');   % Brookhaven
end

% Defining number of images at a given holder
imagenum = size(imagelist, 1);

offset_theta = zeros(1,imagenum);
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
    thetamin = 170*pi/180;
    thetamax = 190*pi/180;
    herm_start = pi/2;
    herm_end = 0;
else % left
    thetamin = -10*pi/180;
    thetamax = 10*pi/180;
    herm_start = pi/2;
    herm_end = 0;
end

thetasteps = 50;

% Scanning angle step size
dtheta = 0.25*pi/360;
window = 2;

% X-axis scale either in Height or Time
x1 = ['Height [mm]'];   % ex situ
% x1 = ['Time [s]'];      % in situ

% Starting time or height
start = 0.1;
% Increment (uniform), later we could give non-uniform increments
increment = 0.1;

height = (start : increment : (start + increment * (imagenum-1)));

% read all images that are in the designated folder
[storeim saxsi] = read_all_images_gb(imagelist,imagenum,ccd_type,beamstop_position);


% Options prompted at start of code
%_________________________________________________________________________%

% Plot options: 0. Do not show, 1. Show plot
image_plot = 1;
azimuthal_plot = 1;
fitting_plot = 1;
everything_plot = 1;
hermans_only_plot = 1;
diameter_only_plot = 1;

warning off all;

fitchoice = input('Diameter and hermans [d], hermans only [h], or screening [else]? > ','s');
disp(' ');

tchoice = '0';
if fitchoice == 'd'

    dchoice = input('Lognormal [l/other] or Gaussian distribution [g]? > ','s');
    disp(' ');

% WALL THICKNESS OPTION DISABLED
%    tchoice = input('Specify wall thickness [1] or use built-in c [other]? > ','s');
%    disp(' ');

    cchoice = input('Different c value [1] or same for each image [other]? > ','s');
    disp(' ');
end

%tvalue = 0.1;
%if tchoice == '1'
%    tvalue = input('Enter wall thickness found using WAXS fit or TEM [nm] > ');
%    limit.t = [tvalue (tvalue + 0.001)];
%    disp(' ');
%end

    offchoice = input('Auto theta-offset [1] or auto [0/else]? > ','s');
    
    if isempty(offchoice)
        offchoice = '0';
    end
       
    disp(' ');

% Processing
%_________________________________________________________________________%

[xLine xLine_A box_coord box_coord_A centers]...
    = getCenter(storeim, center_finding, imagelist, 0, beamstop_position);

% Extracting center from above information
clc;
xc = xLine(6,2)
yc = xLine(6,1)

% Integrated intensity scans - first pass for finding offset angles
 for k = 1 : imagenum
    
%   display which image is being read
    disp(['Reading ', imagelist(k).name, '.']);
        
    [sliceforint, darclengths] = rectslice(saxsi(k).images, xc, yc, thetamin,...
        thetamax, thetasteps, rmax, offset_theta(k));

    sliceint10 = sum(sliceforint',1)';
    qvec = (1:length(sliceint10))'*pixel_conversion;
    raz(k) = get_peak_index(sliceint10);

    if( (raz(k) <=50) | (raz(k) >= (length(sliceint10)-50) ) )
        raz(k) = floor(length(sliceint10)*1/3);
    end

end
 
disp(' ');   

for k = 1 : imagenum
%     offset_theta(k) = get_offset_theta_redo(storeim(k).images, imagelist(k).name, saxsi(k).images,...
%         xc, yc, raz(k), dtheta, window, ...
%         box_coord, xLine, offchoice, beamstop_position);
    offset_theta(k)=0;
end

disp(' ');

% Integrated intensity scans - second pass for fitting after correct offset
% angle is found
 for k = 1 : imagenum

%   display which image is being read
    disp(['Integrating ', imagelist(k).name, ' at correct orientation.']);
    
    [sliceforint, darclengths] = rectslice(saxsi(k).images, xc, yc, thetamin,...
        thetamax, thetasteps, rmax, offset_theta(k));

    sliceint10 = sum(sliceforint',1)';
    qvec = (1:length(sliceint10))'*pixel_conversion;
    raz(k) = get_peak_index(sliceint10);

    if((raz(k) <=50) | (raz(k) >= (length(sliceint10)- 50)))
       raz(k) = floor(length(sliceint10)*1/3);
    end

    humpqs(k) = qvec(raz(k));
    ivsq(k).data = [qvec, sliceint10];

 end

% HERMANS, HERMANS+FITTING, OR SCREENING

if fitchoice == 'h'

    for k = 1 : imagenum

    imagelist(k).name
    
    dataq = ivsq(k).data(:,1);

    % scalenorm_q = 2*(dataq(end)-dataq(1))/3 + dataq(1);
    scalenorm_q = dataq(end - 1);
    save scalenorm_q scalenorm_q
    scalenorm_pix = floor(scalenorm_q/pixel_conversion);
    ivsq(k).data(:,2) = ivsq(k).data(:,2)/ivsq(k).data(scalenorm_pix,2);
    dataI = ivsq(k).data(:,2);

    peakloc(k) = get_peak_pos(dataq, dataI, raz(k));

    theta_start = herm_start + offset_theta(k);
    theta_end = herm_end + offset_theta(k);
    az1 = azimuthal(saxsi(k).images, xc, yc, dtheta, peakloc(k), window, theta_start, theta_end);
    hermhere = hermans(az1)
    herm(k) = hermhere;
    storeaz(k).theta = az1(:,1);
    storeaz(k).laz = az1(:,2);
    
    end

    % normalize raw intensities
    for k = 1:imagenum;
        sepfact = 2;
        intmax(k) = ivsq(k).data(scaleloc,2);
        intscale(k) = sepfact^k/intmax(k);
        ivsq(k).data(:,2) = ivsq(k).data(:,2)*intscale(k);
    end

    % plot all results (no fitting)
    single_manual_plot_hermans(storeim, imagelist, start, increment,...
         x1, imagenum, humpqs, storeaz, herm,...
         ivsq, offset_theta, xc, yc, sampprefix);
    
    % save fit parameters
    % columns
    % h H peakloc
    allfits = [height', herm', peakloc'];    
    txtfilename = strcat(sampprefix,'hermdata.txt');
    save(txtfilename,'allfits','-ascii','-tabs');
    
    k = k + 1;

elseif fitchoice == 'd'
    
disp(' ');
disp('All-fit [1] or One-by-one [0]?');
manchoice = input('Enter your selection: ','s');

for k = 1 : imagenum
    
    go = 'y';
    choice = 0;
        
    while ~isempty(go)

        imagelist(k).name
        
        dataq = ivsq(k).data(:,1);
        
        % scalenorm_q = 2*(dataq(end)-dataq(1))/3 + dataq(1);
        scalenorm_q = dataq(end - 1);
        save scalenorm_q scalenorm_q
        scalenorm_pix = floor(scalenorm_q/pixel_conversion);
        ivsq(k).data(:,2) = ivsq(k).data(:,2)/ivsq(k).data(scalenorm_pix,2);
        dataI = ivsq(k).data(:,2);

        [low high peak] = get_fitting_range(dataq, dataI, fitdn, fitup, manchoice, pixel_conversion, raz(k));

        dataq = ivsq(k).data(low:high,1);
        dataI = ivsq(k).data(low:high,2);
       
        theta_start = herm_start + offset_theta(k);
        theta_end = herm_end + offset_theta(k);
        az1 = azimuthal(saxsi(k).images, xc, yc, dtheta, peak, window, theta_start, theta_end);
        herm(k) = hermans(az1);
        storeaz(k).theta = az1(:,1);
        storeaz(k).laz = az1(:,2);
                
        if cchoice == '1'
            cspec = input('Enter c value for this image > ');
            limit.c = [(cspec-0.0005) (cspec + 0.0005)]
            disp(' ');
        end

        % establish limits - note t is varied even if it is specified
        if tchoice == '1'
            st_ = [stv.A stv.D stv.sD min(limit.t)];            
            [fitstats extrastats] = besselfit1wc_waxs(dataq, dataI, limit, st_);
            ics.A = fitstats(1);    allinfo_A(k) = ics.A;
            ics.D = fitstats(2);    allinfo_D(k) = ics.D;
            ics.sD = fitstats(3);   allinfo_sD(k) = ics.sD;
            ics.t = fitstats(4);    allinfo_t(k) = ics.t;
            ics.c = (ics.D - 2*ics.t)/ics.D;    allinfo_c(k) = ics.c;

        else
            st_ = [stv.A stv.D stv.sD stv.c];            

        if dchoice == 'g';
            [fitstats extrastats] = besselfit1wc(dataq, dataI, limit, st_);
        else
            [fitstats extrastats] = besselfit1wc_lognormal(dataq, dataI, limit, st_);
        end
            ics.A = fitstats(1);    allinfo_A(k) = ics.A;
            ics.D = fitstats(2);    allinfo_D(k) = ics.D;
            ics.sD = fitstats(3);   allinfo_sD(k) = ics.sD;
            ics.c = fitstats(4);    allinfo_c(k) = ics.c;
            ics.t = (ics.D - ics.c*ics.D)/2;    allinfo_t(k) = ics.t;
        end
        
        ics.qmin = min(dataq);    allinfo_qmin(k) = ics.qmin;
        ics.qmax = max(dataq);    allinfo_qmax(k) = ics.qmax;
                
        R2_(k) = extrastats.rsquare;
        R2 = R2_(k);
        SSE(k) = extrastats.sse;
        disp(' ');
        ics
        
        if dchoice == 'g';
            fit(k).all = ics.A*intensityfitwc(ivsq(k).data(:,1), ics.D, ics.sD, ics.c);
        else
            fit(k).all = ics.A*intensityfitwc_lognormal(ivsq(k).data(:,1), ics.D, ics.sD, ics.c);
        end
        
        figure(10);
        semilogy(ivsq(k).data(:,1), fit(k).all, 'Color', [105/255, 105/255, 105/255]); hold on;
        semilogy(ivsq(k).data(:,1), ivsq(k).data(:,2), 'Color', 'r'); hold on;        
        title('Intensity vs. q'); xlabel('q [nm^{-1}]'); ylabel('Intensity [a.u.]');
        axis tight;
        hold off;
        findfigs
        
        % calculate logarithmic RMS error over fitting range, and normalize
        % by mean log intensity
        Elogrms(k) = sqrt(sum(((log(intensityfitwc(dataq, ics.D, ics.sD, ics.c)) - log(dataI)).^2)))/mean(log(dataI));
        
        if manchoice ~='1'
            
        disp(' ');
        disp('0 for try fitting again with different fitting range');
        disp('Enter to continue with next image');
        disp(' ');

        choice = input('Please select an option [0/Enter] -> ');
        
        if isempty(choice)
            go = '';
        end
        
        else
            go = '';
        end
        
        close(10);
    end
end

close all;

% normalize raw intensities - small and large spacings

sepfactL = 10;
sepfactS = 2;

ivsqL = ivsq;
ivsqS = ivsq;

% large spacing
for k = 1:imagenum;
    intmax(k) = ivsq(k).data(scaleloc,2);
    intscaleL(k) = sepfactL^k/intmax(k);
    ivsqL(k).data(:,2) = ivsq(k).data(:,2)*intscaleL(k);
end

% small spacing
for k = 1:imagenum;
    intscaleS(k) = sepfactS^k/intmax(k);
    ivsqS(k).data(:,2) = ivsq(k).data(:,2)*intscaleS(k);
end

% normalize fit intensities
for k = 1:imagenum;
    fitL(k).all = intscaleL(k)*fit(k).all;
    fitS(k).all = intscaleS(k)*fit(k).all;
end

% plot all results (with fitting)
single_manual_plot_fitting(storeim, imagelist, start, increment,...
    x1, imagenum, herm, humpqs, storeaz,...
    ivsqL, ivsqS, fitL, fitS, allinfo_D, allinfo_sD, allinfo_c, Elogrms, diameter_only_plot,...
    everything_plot, azimuthal_plot, fitting_plot, offset_theta, xc, yc, sampprefix, dchoice)

% save fit parameters
% columns
% h A D sD c t qmin qmax
allfits = [height', herm', allinfo_A, allinfo_D, allinfo_sD, allinfo_c, allinfo_t', allinfo_qmin', allinfo_qmax' Elogrms'];    
txtfilename = strcat(sampprefix,'fitdata.txt');
save(txtfilename,'allfits','-ascii','-tabs');

% save data and fits
% format (rows)
% first text file, spaced by sepfactL: q; data1; fit1; data2; fit2; ...
% second text file, spaced by sepfactS: q; data1; fit1; data2; fit2; ...

allcurvesL(:,1) = qvec;
allcurvesS(:,1) = qvec;
for k = 1:imagenum
    allcurvesL(:,2*k) = ivsqL(k).data(:,2);
    allcurvesL(:,2*k+1) = fitL(k).all;
    allcurvesS(:,2*k) = ivsqS(k).data(:,2);
    allcurvesS(:,2*k+1) = fitS(k).all;
end

txtfilename = strcat(sampprefix,'fitcurvesL.txt');
save(txtfilename,'allcurvesL','-ascii','-tabs');

txtfilename = strcat(sampprefix,'fitcurvesS.txt');
save(txtfilename,'allcurvesS','-ascii','-tabs');

mean(allinfo_D)

% IF SCREENING: Azimuthal scans, and save/plot output only
else

% azimuthal scans
for k = 1: imagenum
     
    theta_start = herm_start + offset_theta(k);
    theta_end = herm_end + offset_theta(k);

    az1 = azimuthal(saxsi(k).images, xc, yc, dtheta, raz(k), window, theta_start, theta_end); 
    storeaz(k).theta = az1(:,1);
    storeaz(k).laz = az1(:,2);

end    
    
% normalize raw intensities
for k = 1:imagenum;
    sepfact = 2;
    intmax(k) = ivsq(k).data(scaleloc,2);
    intscale(k) = sepfact^k/intmax(k);
    ivsq(k).data(:,2) = ivsq(k).data(:,2)*intscale(k);
end

% plot all results (no fitting)
single_manual_plot_nofitting(storeim, imagelist, start, increment,...
     x1, imagenum, humpqs, storeaz,...
     ivsq, offset_theta, xc, yc, sampprefix);

end

findfigs