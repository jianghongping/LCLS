function [] = single_manual_plot_hermans(storeim, imagelist,height,...
    x1, imagenum, humpqs, storeaz, herm,hermfit,...
    ivsq, offset,ScatteringI,peakIntensity,saxsi, xc, yc, prefix,raz)

rainbow = get_rainbow_palette();
if length(height)>1
    increment=(abs(max(height)-min(height)))/(length(height)/3);
else
    increment=1;
end

[token,remainder]=strtok(prefix,'/');
while ~isempty(remainder)
    [token,remainder]=strtok(remainder,'/');
end
header=token;







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% all images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%plot_offsets(storeim, imagelist, offset, xc, yc);
trShow_plot_offsets(storeim,imagelist,offset,xc,yc,saxsi,raz,prefix)
imfname = strcat(prefix,'images-nofitset');
% saveas(gcf, imfname, 'tiffn');
% disp('madeit')
% saveas(gcf, imfname, 'fig');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% intensity vs. q
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fitting_plot = 1;

if fitting_plot == 1

    maxtrack = 0;
    figure
    for i = 1 : imagenum

        % plot of actual data
        dataIplot = ivsq(i).data(:,2);
        semilogy(ivsq(i).data(:,1), dataIplot, '.', 'Color', rainbow(i,:));
        hold on;

        % make legends
        legends(i).name = imagelist(i).name;

        maxtrack = max([maxtrack max(dataIplot)]);
        
    end

    % manual axis control - should automate later
    title(header); 
    xlabel('q [A^{-1}]'); %Changed from nm to A
    ylabel('Intensity [a.u.]');
    legend(legends.name,-1);
    axis([0 max(ivsq(1).data(:,1)) 0.1 maxtrack]);
    hold off;

    imfname = strcat(prefix,'Iq-nofit');
    saveas(gcf, imfname, 'tiffn');
    saveas(gcf, imfname, 'fig');

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Normalized Peak Intensity vs. Height
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fitting_plot = 1;

if fitting_plot == 1

for i=1:imagenum
    indexHolder= find(ivsq(i).dataNoNorm(:,1)>humpqs(i));
    index=indexHolder(1);
    disp(num2str(index))
    %average over nearest 9 values
    peakIntNorm(i)=0;
    for k=index-4:index+4
        peakIntNorm(i)=peakIntNorm(i)+ivsq(i).dataNoNorm(k,2);
    end
    peakIntNorm(i)=peakIntNorm(i)/length(index-4:index+4);
end
    figure
    

        % plot of actual data
        
    PeakILine = line(height, peakIntNorm, 'Color', 'b', 'LineStyle','s', 'LineStyle',':',...
        'Color', [0 0 1], 'LineWidth',2);
    hold on;
    % Scale axis as neccessary
    title(header); 
    xlabel('Height'); 
    ylabel('Peak Intensity');
    
    hold off;

    imfname = strcat(prefix,'PeakIvsHeight');
    saveas(gcf, imfname, 'tiffn');
    saveas(gcf, imfname, 'fig');

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Peak Intensity vs. Pulse Energy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fitting_plot = 1;

if fitting_plot == 1

    maxtrack = 0;
    figure
    

        % plot of actual data
        
    semilogy([saxsi.energy],ScatteringI,'*','Color','bl')
    hold on;
    % Scale axis as neccessary
    title(header); 
    xlabel('Pulse Energy'); 
    ylabel('Scattering Intesity');
    
    hold off;

    imfname = strcat(prefix,'ScatIvsE');
    saveas(gcf, imfname, 'tiffn');
    saveas(gcf, imfname, 'fig');

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hermans 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

everything_plot = 1;

if everything_plot == 1

    figure
    
    hermLine = line(height, herm, 'Color', 'r', 'LineStyle','s', 'LineStyle',':',...
        'Color', [1 0 0], 'LineWidth',2);
    hermfitLine = line(height, hermfit, 'Color', 'y', 'LineStyle','s', 'LineStyle',':',...
        'Color', [1 1 0], 'LineWidth',2);
    axis tight;
    
%     if imagenum == 1
%         heightend = 0.2;
%     else
%         heightend = height(imagenum);
%     end
%     
%     if length(height)>1
%         axis([min(height) max(height) (min(min(herm),min(hermfit)) - increment) (max(max(herm),max(hermfit)) + increment)]);
%         set(gca,'XTick',min(height):increment:max(height))
%     end
   
    ax1 = gca;
    ylabel('Hermans (R) and Hermans Fit (Y) Parameter', 'Color', 'black');
    
    xlabel(x1);

    title(header);
    grid on;
    
    imfname = strcat(prefix,'-Htrends');
    saveas(gcf, imfname, 'tiffn');
    saveas(gcf, imfname, 'fig');
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Height vs Scattering Intensity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

everything_plot = 1;

if everything_plot == 1

    figure
    
    hermLine = line(height, ScatteringI, 'Color', 'bl', 'LineStyle','s', 'LineStyle',':',...
        'Color', [1 0 0], 'LineWidth',2);
    
    axis tight;
    
%     if imagenum == 1
%         heightend = 0.2;
%     else
%         heightend = height(imagenum);
%     end
%     
%     if length(height)>1
%         axis([min(height) max(height) (min(ScatteringI) - increment) (max(ScatteringI) + increment)]);
%         set(gca,'XTick',min(height):increment:max(height))
%     end
   
    ax1 = gca;
    ylabel('Scattering Intensity', 'Color', 'black');
    
    xlabel(x1);

    title(header);
    grid on;
    
    imfname = strcat(prefix,'-ScatI');
    saveas(gcf, imfname, 'tiffn');
    saveas(gcf, imfname, 'fig');
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Offset theta
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

everything_plot = 1;

if everything_plot == 1

    off_deg = offset*180/pi;

    figure
    hold on
    plot(height,off_deg,'bx-','LineWidth',2)
    
%     if imagenum == 1
%         heightend = 0.2;
%     else
%         heightend = height(imagenum);
%     end
%     
%     if length(height)>1
%         axis([min(height) max(height) (min(off_deg) - 5) (max(off_deg) + 5)]);
%         set(gca,'XTick',min(height):increment:max(height))
%     end
   
    ax1 = gca;
    ylabel('Offset theta [deg]');
    xlabel(x1);

    title(header);
    grid on;
    
    imfname = strcat(prefix,'-OffThtrends');
    saveas(gcf, imfname, 'tiffn');
    saveas(gcf, imfname, 'fig');
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% maximum locations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    dapprox = 2*pi./humpqs;

    figure
    hold on
    subplot(2,1,1);
    plot(height,humpqs,'bx-','LineWidth',2)
    ylabel('q of maxI [A^-1]');
    grid on;
    
    heightmax = height(imagenum);
    if imagenum == 1
        heightmax = height(1) + increment;
    end
    
%     if length(height)>1
%         axis([min(height) max(height) (min(humpq) - 0.1) (max(humpq) + 0.1)]);
%         set(gca,'XTick',min(height):increment:max(height))
%     end

    subplot(2,1,2);
    plot(height,dapprox,'bx-.','LineWidth',2)
    xlabel('Height [mm]');
    ylabel('d = 2*pi/q [A^-1]');
    grid on
%     if length(height)>1
%         axis([min(height) max(height) (min(dapprox) - 0.5) (max(dapprox) + 0.5)]);
%         set(gca,'XTick',min(height):increment:max(height))
%     end

    title(header); 

    imfname = strcat(prefix,'dapprox');
    saveas(gcf, imfname, 'tiffn');
    saveas(gcf, imfname, 'fig');

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% azimuthal scan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

azimuthal_plot = 1;

rainbow = get_rainbow_palette();

if azimuthal_plot == 1

    figure
    minth = 1e10;
    maxth = 0;
    maxI = 0;
    
    for i = 1 : imagenum
        plot((180/pi)*storeaz(i).theta, storeaz(i).laz, '.', 'Color', rainbow(i,:));
        minth = min(minth,180/pi*min(storeaz(i).theta));
        maxth = max(maxth,180/pi*max(storeaz(i).theta));
        maxI = max(maxI,1.1*max(storeaz(i).laz));
        hold on;
    end
    
    title(header);
    xlabel(' \phi [deg]'); 
    ylabel('Intensity [a.u.]');
    legend(legends.name, -1);
    grid on; 
%   axis tight; 
    axis([minth maxth 0 maxI])

    imfname = strcat(prefix,'azscans-nofit');
    saveas(gcf, imfname, 'tiffn');
    saveas(gcf, imfname, 'fig');

end