%This script parses the directory 'imagerun' and sorts all of the images
%within in accordance with the way they're sorted in imagerun. It then
%displays all of the images, subtracts darks, and takes wedge lineouts. It 
%saves all of the images in 'imagestore' and all of the plotted lineouts in
%'output', sorted the same way they're sorted in imagerun. It also
%saves the struct 'sample', which contains the images, the lineouts, and
%the information about each of the runs. The second part of this code will take 
%that struct as input. This code assumes that each sample has a separate folder, 
%and that each run is either an individual image or a folder with the images inside it.

%% Setup and file handling
clear all
close all
warning off all
clc

%Set up sample and dark structs
sample=parse_direc('imagerun','_'); %I wrote parse_direc
dark=parse_direc('Darks',' ');

%Pair up each dark image with an exposure time and import darks
for i=1:length(dark)
    if strcmp(dark(i).filetype,'.txt')
        coll=importdata(strcat('Darks/',dark(i).name)); %coll short for collection
        collid=i;                                       %collid=id of coll
        dark(i).coll=[];    %These are empty because this file isn't actually a dark (it's the collection times .txt)
        dark(i).image=[];
    end
end
I=[1:(collid-1),(collid+1):length(dark)];
for i=1:length(I)
    dark(I(i)).coll=coll(i);
    dark(I(i)).image=fliplr(flipud(fitsread(strcat('Darks/',dark(I(i)).name),'Image')));    %fliplr & flipud flip the image. .fits images need flipping
end

%Get data about runs and set up run sub-structs
Cedge_coll_times=importdata('carbon_edge_coll_time_20141221.txt');    %We'll need this when assigning darks (line 102)
for i=1:length(sample)
    J=1;
    %Okay, the next few lines are about sorting the info contained in the
    %filenames into the sample struct. The order of the elseifs is somewhat
    %important, so be careful if editing
    for j=1:length(sample(i).direc)
        sample(i).direc(j).runid=str2double(strtok(sample(i).direc(j).token{end},'-'));
        sample(i).direc(j).data=[];     %Set up things as empty if you're not sure you will fill them.
        sample(i).direc(j).runtype='';  %An entry left empty might be useful later on
        sample(i).direc(j).energy=[];
        sample(i).direc(j).pol='';
        sample(i).direc(j).coll=[];
%        sample(i).direc(j).z=[];
        sample(i).direc(j).darkid=[];
        sample(i).direc(j).SDD=[];
        for k=1:length(sample(i).direc(j).token)
            if strncmp(sample(i).direc(j).token{k},'EPU',3)
                sample(i).direc(j).pol=sample(i).direc(j).token{k};
            elseif strncmp(sample(i).direc(j).token{k},'y',1)||strncmp(sample(i).direc(j).token{k},'Y',1)...
                    ||strncmp(sample(i).direc(j).token{k},'z',1)||strncmp(sample(i).direc(j).token{k},'Z',1)
                sample(i).direc(j).runtype='Zscan';
            elseif strncmp(sample(i).direc(j).token{k},'E',1)
                token=strtok(sample(i).direc(j).token{k},'E');
                [ones,decimals]=strtok(token,'p');
                if ~isempty(decimals)
                    decimals=strtok(decimals,'p');
                else
                    [ones,decimals]=strtok(token,'.');
                    decimals=strtok(decimals,'.');
                end
                sample(i).direc(j).energy=str2double(strcat(ones,'.',decimals));
            elseif strncmp(sample(i).direc(j).token{k},'S',1)
                %This one left blank intentionally
            elseif isnan(str2double(strtok(sample(i).direc(j).token{k},'-')))
                sample(i).direc(j).runtype=sample(i).direc(j).token{k};
            end
        end
        if ~sample(i).direc(j).isdir&&isempty(sample(i).direc(j).runtype)
            sample(i).direc(j).runtype='Single';
        end
        
        if strcmp(sample(i).direc(j).filetype,'.txt')
            data=importdata(strcat('imagerun/',sample(i).name,'/',sample(i).direc(j).name),'\t');
            sample(i).direc(j).data=data.data;
        else %Notice that here it switches from being sample(i).direc to being sample(i).run. J is used as an index to set up this field
            sample(i).run(J)=sample(i).direc(j);
            sample(i).run(J).coll=input(sprintf('What was the exposure time for sample %s run %d? > ',...
                sample(i).name,sample(i).run(J).runid));
            if isempty(sample(i).run(J).energy)&&(strcmp(sample(i).run(J).runtype,'Single')||strcmp(sample(i).run(J).runtype,'Zscan'))
                sample(i).run(J).energy=input(sprintf('What is the beamline energy for sample %s run %d? > ',...
                    sample(i).name,sample(i).run(J).runid));
            end
            %The below is meant to catch stuff with an energy of 1000. I picked an
            %arbitrarily high number below 1000, because in my experience
            %asking if numbers are equal doesn't always work
%             if sample(i).run(J).energy>700
%                 sample(i).run(J).SDD=input(sprintf('What is the SDD for sample %s run %d? > ',sample(i).name,sample(i).direc(j).runid));
%             else
%                 sample(i).run(J).SDD=150;     %Default SDD when CCD y=100 (Cheng says this is more accurate than doing a PS calibration)
%             end
             sample(i).run(J).SDD=150;  %Default SDD when CCD y=100 (Cheng says this is more accurate than doing a PS calibration)
%             if ~strcmp(sample(i).run(J).runtype,'Zscan')
%                  sample(i).run(J).z=input(sprintf('What is the vertical position of the sample holder for sample %s run %d? > ',...
%                      sample(i).name,sample(i).run(J).runid));
%             end
            %Assign a dark
            if ~isempty(sample(i).run(J).coll)
                for l=1:length(dark)
                    if dark(l).coll==sample(i).run(J).coll
                        sample(i).run(J).darkid=l;
                        if sample(i).run(J).isdir
                            for k=1:length(sample(i).run(J).direc)
                                sample(i).run(J).direc(k).darkid=sample(i).run(J).darkid;
                            end
                        end
                    end
                end
            else
                for k=1:length(sample(i).run(J).direc)
                    [~,frame]=strtok(sample(i).run(j).direc(k).token{end},'-');
                    frame=str2double(strtok(frame,'-'));
                    sample(i).run(J).direc(k).coll=Cedge_coll_times(frame,2);
                    for l=1:length(dark)
                        if dark(l).coll==sample(i).run(J).direc(k).coll
                            sample(i).run(J).direc(k).darkid=l;
                        end
                    end
                end
            end
            J=J+1;
        end
    end
    %Attach the entry in sample(i) that has the same run id as
    %sample(i).run(j) for each index j.
    for j=1:length(sample(i).run)
        for k=1:length(sample(i).direc)
            if (sample(i).run(j).runid==sample(i).direc(k).runid)&&strcmp(sample(i).direc(k).filetype,'.txt')
                sample(i).run(j).data=sample(i).direc(k).data;
            end
        end
    end
end

%Import data, subtract darks, and assign energies for Escans
for i=1:length(sample)
    for j=1:length(sample(i).run)
        if strcmp(sample(i).run(j).filetype,'.fits')
            sample(i).run(j).image=fliplr(flipud(fitsread(strcat('imagerun/',sample(i).name,'/',sample(i).run(j).name),'Image')));
            sample(i).run(j).image=sample(i).run(j).image-dark(sample(i).run(j).darkid).image;
        else %At this point, if the filetype isn't .fits, that means it's a set of images in a folder
            for k=1:length(sample(i).run(j).direc)
                sample(i).run(j).direc(k).image=fliplr(flipud(fitsread(strcat('imagerun/',sample(i).name,'/',...
                    sample(i).run(j).name,'/',sample(i).run(j).direc(k).name),'Image')));
                sample(i).run(j).direc(k).image=sample(i).run(j).direc(k).image...
                    -dark(sample(i).run(j).direc(k).darkid).image;
            end
            if ~strcmp(sample(i).run(j).runtype,'Zscan') %if it's a scan, but not a Zscan => Escan
                for k=1:length(sample(i).run(j).direc)
                    [~,frame]=strtok(sample(i).run(j).direc(k).token{end},'-');
                    frame=str2double(strtok(frame,'-'));
                    sample(i).run(j).direc(k).energy=.1*round(10*sample(i).run(j).data(frame,2));   %Rounded to nearest 0.1eV
%                    sample(i).run(j).direc(k).z=sample(i).run(j).z;                                 %Same across run
                end
            else %NOT NOT a Zscan => IS a Zscan
                for k=1:length(sample(i).run(j).direc)
                    sample(i).run(j).direc(k).energy=sample(i).run(j).energy;   %Same across run
                    [~,frame]=strtok(sample(i).run(j).direc(k).token{end},'-');
                    frame=str2double(strtok(frame,'-'));
                    sample(i).run(j).direc(k).z=sample(i).run(j).data(frame,2);
                end
            end
        end
    end
end

%% Imaging, generating lineouts, plotting, and saving

%Image, generate lineouts, and plot lineouts individually

pix=.027;           %in mm, CCD at BL 11.0.1.2 at ALS
window=[1024,1024]; %in pixels, CCD at BL 11.0.1.2 at ALS
thetamax=pi/18;     %=10 degrees
thetamin=-pi/18;    %=-10 degrees
thetasteps=40;
Center=[];          %[x,y] x=from left, y=from top
mkdir('imagestore')
mkdir('output')
for i=1:length(sample)
    mkdir('imagestore',sample(i).name)  %Create directory for the sample
    mkdir('output',sample(i).name)
    for j=1:length(sample(i).run)
        clc
        sprintf('Now beginning processing for sample %s run %s. Press [enter] to proceed',sample(i).name,sample(i).run(j).name)
        pause
        if sample(i).run(j).isdir
            mkdir(strcat('imagestore/',sample(i).name),sample(i).run(j).name)   %Create directory for the run
            mkdir(strcat('output/',sample(i).name),sample(i).run(j).name)
            %Choose the center once for each run. The center can be jostled
            %from run to run (though not by much). I rewrote it so that it
            %goes through the images until you find one with a good center
            %for you to pick, then goes back to the beginning so you can
            %process with a good center
            if isempty(Center)
                center=zeros(1,2);
                k=1;
                while ~center
                    figure
                    imagesc(log(abs(sample(i).run(j).direc(k).image)+1))
                    k=k+1;
                    set(gca,'DataAspectRatio',[1,1,1])
                    disp(' ')
                    disp('Please select the beam center')
                    [xc,yc]=ginput(1);
                    if ~isempty(xc)
                        center=[xc,yc];
                        sample(i).run(j).center=center;
                    end
                    close %Close because this window will open again in the following for loop
                end
            else
                center=Center;
            end
            for k=1:length(sample(i).run(j).direc)
                %Choose the offset for each image. The pattern has been
                %known to shift from image to image, especially in Zscans
                figure
                imagesc(log(abs(sample(i).run(j).direc(k).image)+1))
                set(gca,'DataAspectRatio',[1,1,1])
                disp(' ')
                disp('Please select the peak you want to include in the wedge')
                [xp,yp]=ginput(1);
                if xp>=center(1)
                    sample(i).run(j).direc(k).offset=atan((center(2)-yp)/(xp-center(1)));
                else
                    sample(i).run(j).direc(k).offset=atan((center(2)-yp)/(xp-center(1)))+pi;
                end
                rmax=find_rmax_v2(window,center,sample(i).run(j).direc(k).offset,thetamax);
                %Format the image some more, then save in imagestore
                header=strcat(sample(i).name,'-',sample(i).run(j).runtype);
                if strcmp(sample(i).run(j).runtype,'Zscan')
                    header=strcat(header,'-',num2str(sample(i).run(j).energy),'-',sample(i).run(j).pol,'-',num2str(sample(i).run(j).runid),'-',num2str(sample(i).run(j).direc(k).z));
                else
                    header=strcat(header,'-',sample(i).run(j).pol,'-',num2str(sample(i).run(j).runid),'-',num2str(sample(i).run(j).direc(k).energy));
                end
                title(header)
                Header=strcat('imagestore/',sample(i).name,'/',strtok(sample(i).run(j).name,'.'),'/',header);
                saveas(gcf, strcat(Header,'.tif'));
                saveas(gcf, strcat(Header,'.fig'));
                close
                %Actually make the lineout
                [qvec,I,darc]=wedge_lineout(sample(i).run(j).direc(k).image,sample(i).run(j).direc(k).energy,...
                    sample(i).run(j).SDD,pix,center,thetamin,thetamax,thetasteps,rmax,sample(i).run(j).direc(k).offset);
                sample(i).run(j).direc(k).lineout=[qvec',mean(I,2)];
                %Semilog
                figure
                semilogy(qvec',mean(I,2))
                title(header);
                xlabel('q [nm^{-1}]');
                ylabel('Intensity [a.u.]');
                Header=strcat('output/',sample(i).name,'/',strtok(sample(i).run(j).name,'.'),'/',header);
                saveas(gcf, strcat(Header, '.tif'));
                saveas(gcf, strcat(Header, '.fig'));
                close
                %loglog
                figure
                loglog(qvec',mean(I,2))
                title(header);
                xlabel('q [nm^{-1}]');
                ylabel('Intensity [a.u.]');
                saveas(gcf, strcat(Header,'-log', '.tif'));
                saveas(gcf, strcat(Header,'-log', '.fig'));
                close
            end
        else
            if isempty(Center)
                figure
                imagesc(log(abs(sample(i).run(j).image)+1))
                set(gca,'DataAspectRatio',[1,1,1])
                center=zeros(1,2);
                disp(' ')
                disp('Please select the beam center')
                [center(1),center(2)]=ginput(1);
                sample(i).run(j).center=center;
                close
            else
                center=Center;
            end
            figure
            imagesc(log(abs(sample(i).run(j).image)+1))
            set(gca,'DataAspectRatio',[1,1,1])
            disp(' ')
            disp('Please select the peak you want to include in the wedge')
            [xp,yp]=ginput(1);
            if xp>=center(1)
                sample(i).run(j).offset=atan((center(2)-yp)/(xp-center(1)));
            else
                sample(i).run(j).offset=atan((center(2)-yp)/(xp-center(1)))+pi;
            end
            rmax=find_rmax_v2(window,center,sample(i).run(j).offset,thetamax);
            %Format the image some more, then save in imagestore
            header=strcat(sample(i).name,'-',sample(i).run(j).runtype,'-',num2str(sample(i).run(j).energy),'-',sample(i).run(j).pol,'-',num2str(sample(i).run(j).runid));
            title(header)
            Header=strcat('imagestore/',sample(i).name,'/',header);
            saveas(gcf, strcat(Header,'.tif'));
            saveas(gcf, strcat(Header,'.fig'));
            close
            %Actually make the lineout
            [qvec,I,darc]=wedge_lineout(sample(i).run(j).image,sample(i).run(j).energy,...
                sample(i).run(j).SDD,pix,center,thetamin,thetamax,thetasteps,rmax,sample(i).run(j).offset);
            sample(i).run(j).lineout=[qvec',mean(I,2)];
            %Semilog
            figure
            semilogy(qvec',mean(I,2))
            title(header);
            xlabel('q [nm^{-1}]');
            ylabel('Intensity [a.u.]');
            Header=strcat('output/',sample(i).name,'/',header);
            saveas(gcf, strcat(Header, '.tif'));
            saveas(gcf, strcat(Header, '.fig'));
            close
            %loglog
            figure
            loglog(qvec',mean(I,2))
            title(header);
            xlabel('q [nm^{-1}]');
            ylabel('Intensity [a.u.]');
            saveas(gcf, strcat(Header,'-log', '.tif'));
            saveas(gcf, strcat(Header,'-log', '.fig'));
            close
        end
    end
end
name=datestr(now);
[token,remainder]=strtok(name,':');
[token1,remainder]=strtok(remainder,':');
token2=strtok(remainder,':');
name=strcat(token,'-',token1,'-',token2);

save(strcat('output/',name),'sample')



