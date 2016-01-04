% CSFF processing of transmission SAXS images

% FLICAM WITH CAPILLARY CHESS MAY 08
% SUBTRACTS BACKGROUND FROM TOP LEFT ONLY: [50:100,50:100]

clear all; format long; close all; clc;

sampprefix = 'run14waxs-test';
fpath = 'output';
mkdir(fpath,sampprefix)
fpath=strcat(fpath,'/',sampprefix,'/');
sampprefix = strcat(fpath,'/',sampprefix,'-');
mask=dir('Masks/*waxs*');
mask.mask=importdata(strcat('Masks/',mask.name));
SDD=2043;       %LCLS CXI SAXS detector
%SDD=90;         %LCLS CXI WAXS detector
pix=.10992;     %LCLS CXI PAD detectors

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
center_finding = 0;

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
    herm_start=pi/2;
    herm_end=0;             %LCLS CXI (7/22/14)
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
end
%sort saxsi by y coordinate
[~,I]=sort([saxsi.index]);
Saxsi=saxsi(I);
Storeim=storeim(I);
Imagelist=imagelist(I);
clear saxsi storeim imagelist
saxsi=Saxsi;
storeim=Storeim;
imagelist=Imagelist;
clear Saxsi Storeim Imagelist

%heights (last image coordinate = 0)
height=[saxsi.y]-saxsi(end).y;


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
% xc = 554
% yc = 741

% Integrated intensity scans - first pass for finding offset angles
 for k = 1 : imagenum
    
%   display which image is being read
    disp(['Reading ', imagelist(k).name, '.']);
        
    rmax=find_rmax_v2([size(saxsi(k).images,2),size(saxsi(k).images,1)],[xc,yc],offset_theta(k)+(thetamax+thetamin)/2,(thetamax-thetamin)/2);
    [qvec, sliceint10, darclengths, gaps]=wedge_lineout_masked_strict(saxsi(k).images,saxsi(k).energy,SDD,pix, [xc, yc], thetamin,...
        thetamax, thetasteps, rmax, offset_theta(k));
    
    J=1;
    while (gaps(J+1)-gaps(J))==1 & J < length(gaps) %Tom Riis: added j<len(gaps)
        beamstop_edge_index(k)=J;
        J=J+1;
    end

    %sliceint10 = sum(sliceforint',1)';
    raz(k) = get_peak_index(sliceint10)+beamstop_edge_index(k);

%     if( (raz(k) <=50) | (raz(k) >= (length(sliceint10)-50) ) )
%         raz(k) = floor(length(sliceint10)*1/3);
%     end
    
    badring=0;
    while badring==0
        figure
        imagesc(storeim(k).images)
        set(gca,'DataAspectRatio',[1,1,1])
        title(imagelist(k).name)
        hold on
        x=linspace(-raz(k),raz(k),201)+xc;
        yup=sqrt((raz(k))^2-(x-xc).^2)+yc;
        ydn=-sqrt((raz(k))^2-(x-xc).^2)+yc;
        plot(x,yup,'k-')
        plot(x,ydn,'k-')
        badring=str2double(input('Are you satisfied with the radius chosen for azimuthal integration? [0] to retry, [else] to accept > ','s'));
        if badring==0
            [xp,yp]=ginput(1);
            raz(k)=sqrt((xc-xp)^2+(yc-yp)^2);
        end
        close
    end
    

end
 
disp(' ');   

for k = 1 : imagenum
    %offset_theta(k) = get_offset_theta_redo(storeim(k).images, imagelist(k).name, saxsi(k).images,...
        %xc, yc, raz(k), dtheta, window, ...
        %box_coord, xLine, offchoice, beamstop_position, thetamin, thetamax);

     offset_theta(k)=0; % to override auto offset
    
%     offset_theta(k)=offset_theta(k)+deg2rad(5); % to override auto offset
    
end

disp(' ');

% Integrated intensity scans - second pass for fitting after correct offset
% angle is found
 for k = 1 : imagenum

%   display which image is being read
    disp(['Integrating ', imagelist(k).name, ' at correct orientation.']);
    
    rmax=find_rmax_v2([size(saxsi(k).images,2),size(saxsi(k).images,1)],[xc,yc],offset_theta(k)+(thetamin+thetamax)/2,(thetamax-thetamin)/2);
    [qvec, sliceint10, darclengths, gaps]=wedge_lineout_masked_strict(saxsi(k).images,saxsi(k).energy,SDD,pix, [xc, yc], thetamin,...
        thetamax, thetasteps, rmax, offset_theta(k));

    J=1;
    while (gaps(J+1)-gaps(J))==1 & J < length(gaps) %Tom Riis: added j<len(gaps)
        beamstop_edge_index(k)=J;
        J=J+1;
    end

    %sliceint10 = sum(sliceforint',1)';
    raz(k) = get_peak_index(sliceint10)+beamstop_edge_index(k);

%     if((raz(k) <=50) | (raz(k) >= (length(sliceint10)- 50)))
%        raz(k) = floor(length(sliceint10)*1/3);
%     end
    
%     badring=0;
%     while badring==0
%         figure
%         imagesc(storeim(k).images)
%         set(gca,'DataAspectRatio',[1,1,1])
%         title(imagelist(k).name)
%         hold on
%         x=linspace(-raz(k),raz(k),201)+xc;
%         yup=sqrt((raz(k))^2-(x-xc).^2)+yc;
%         ydn=-sqrt((raz(k))^2-(x-xc).^2)+yc;
%         plot(x,yup,'k-')
%         plot(x,ydn,'k-')
%         badring=str2double(input('Are you satisfied with the radius chosen for azimuthal integration? [0] to retry, [else] to accept > ','s'));
%         if badring==0
%             [xp,yp]=ginput(1);
%             raz(k)=sqrt((xc-xp)^2+(yc-yp)^2);
%         end
%         close
%     end

    humpqs(k) = qvec(floor(raz(k)-beamstop_edge_index(k)));
    ivsq(k).data = [qvec', sliceint10];

 end

% HERMANS, HERMANS+FITTING, OR SCREENING

if fitchoice == 'h'

    for k = 1 : imagenum

    imagelist(k).name
    
    dataq = ivsq(k).data(:,1);

    % scalenorm_q = 2*(dataq(end)-dataq(1))/3 + dataq(1);
    scalenorm_q = dataq(end - 1);
    save scalenorm_q scalenorm_q
    scalenorm_pix = length(dataq)-1;
    ivsq(k).data(:,2) = ivsq(k).data(:,2)/ivsq(k).data(scalenorm_pix,2);
    dataI = ivsq(k).data(:,2);
    qvec = ivsq(k).data(:,1);

    peakloc(k) = get_peak_pos(dataq, dataI, raz(k)-beamstop_edge_index(k));
%     peakloc(k) = 355;
    humpqs(k) = qvec(peakloc(k));

    theta_start = herm_start + offset_theta(k);
    theta_end = herm_end + offset_theta(k);
    az1 = azimuthal_subtract(saxsi(k).images, xc, yc, dtheta, peakloc(k), window, theta_start, theta_end); %Tom Riis: changed function from masked_strict version
    az1(:,1)=az1(:,1)-offset_theta(k);
    if ((thetamin+thetamax)/2)==pi/2
        az1(:,1)=abs(az1(:,1)-pi/2);
    end
    [hermhere,~] = hermans_masked_withfit(az1)
    herm(k) = hermhere;
    storeaz(k).theta = az1(:,1);
    storeaz(k).laz = az1(:,2);
    
    end

    % normalize raw intensities
    for k = 1:imagenum;
        sepfact = 2;
        scaleloc_pix=find(ivsq(k).data(:,1)<=scaleloc,1,'last');
        intmax(k) = ivsq(k).data(scaleloc_pix,2);
        intscale(k) = sepfact^k/intmax(k);
        ivsq(k).data(:,2) = ivsq(k).data(:,2)*intscale(k);
    end

    % plot all results (no fitting)
    single_manual_plot_hermans(storeim, imagelist,height,...
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
        scalenorm_pix = length(dataq)-1;
        ivsq(k).data(:,2) = ivsq(k).data(:,2)/ivsq(k).data(scalenorm_pix,2);
        dataI = ivsq(k).data(:,2);

        [low high peak] = get_fitting_range(dataq, dataI, fitdn, fitup, manchoice, raz(k)-beamstop_edge_index(k));

        dataq = ivsq(k).data(low:high,1);
        dataI = ivsq(k).data(low:high,2);
       
        theta_start = herm_start + offset_theta(k);
        theta_end = herm_end + offset_theta(k);
        az1 = azimuthal(saxsi(k).images, xc, yc, dtheta, peak, window, theta_start, theta_end); %Tom Riis: changed function from maxked_strict version
        [herm(k),~] = hermans_masked_withfit(az1);
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
    scaleloc_pix=find(ivsq(k).data(:,1)<=scaleloc,1,'last');
    intmax(k) = ivsq(k).data(scaleloc_pix,2);
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

% allcurvesL(:,1) = qvec;
% allcurvesS(:,1) = qvec;
%Now that qvec is different for every image, the repeat unit is 3: q1;
%data1; fit1
for k = 1:imagenum
    allcurvesL(:,3*k-2)=ivsq(k).data(:,1);
    allcurvesL(:,3*k-1) = ivsqL(k).data(:,2);
    allcurvesL(:,3*k) = fitL(k).all;
    allcurvesS(:,3*k-2)=ivsq(k).data(:,1);
    allcurvesS(:,3*k-1) = ivsqS(k).data(:,2);
    allcurvesS(:,3*k) = fitS(k).all;
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

    az1 = azimuthal(saxsi(k).images, xc, yc, dtheta, raz(k)-beamstop_edge_index(k), window, theta_start, theta_end); %Tom Riis: changed function from version azimutal masked_strict
    storeaz(k).theta = az1(:,1);
    storeaz(k).laz = az1(:,2);

end    
    
% normalize raw intensities
for k = 1:imagenum;
    sepfact = 2;
    scaleloc_pix=find(ivsq(k).data(:,1)<=scaleloc,1,'last');
    intmax(k) = ivsq(k).data(scaleloc_pix,2);
    intscale(k) = sepfact^k/intmax(k);
    ivsq(k).data(:,2) = ivsq(k).data(:,2)*intscale(k);
end

% plot all results (no fitting)
single_manual_plot_nofitting(storeim, imagelist,height,...
     imagenum, humpqs, storeaz, ivsq, offset_theta, xc, yc, sampprefix);

end

findfigs