function [] = single_manual_plot_fitting(storeim, imagelist, height,...
    x1, imagenum, herm, humpq, storeaz,...
    ivsqL, ivsqS, fitL, fitS, allinfo_D, allinfo_sD, allinfo_c, Elogrms, diameter_only_plot,...
    everything_plot, azimuthal_plot, fitting_plot, offset, xc, yc, prefix, dchoice)

rainbow = get_rainbow_palette();

increment=abs(height(2)-height(1));

[token,remainder]=strtok(prefix,'/');
while ~isempty(remainder)
    [token,remainder]=strtok(remainder,'/');
end
header=token;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% all images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s = 0; % s = 0 means show every image

plot_offsets(storeim, imagelist, offset, xc, yc);

title(header); 
imfname = strcat(prefix,'images-fitset');
saveas(gcf, imfname, 'tiffn');
saveas(gcf, imfname, 'fig');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% intensity vs. q
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if fitting_plot == 1

    % LARGE SPACING
    figure
    clear legends
    
    for i = 1 : imagenum
        
        % plot fits first so they go behind the data
        fitIplot = fitL(i).all;
        semilogy(ivsqL(i).data(:,1), fitIplot, 'Color', [105/255, 105/255, 105/255]);
        hold on;

        % plot of actual data
        dataIplot = ivsqL(i).data(:,2);
        semilogy(ivsqL(i).data(:,1), dataIplot, 'Color', rainbow(i,:));
        hold on;

        % make legends
        legends(2*i-1).name = ['D = ', num2str(allinfo_D(i)), ', SD = ', num2str(allinfo_sD(i))];
        legends(2*i).name = imagelist(i).name;
        
    end

    % manual axis control - should automate later
    title(header); 
    xlabel('q [nm^{-1}]'); 
    ylabel('Intensity [a.u.]');
    legend(legends.name,-1);
    axis([0 1.8 1 10^(imagenum+1)]);
    hold off;

    imfname = strcat(prefix,'Iq-yesfit');
    saveas(gcf, imfname, 'tiffn');
    saveas(gcf, imfname, 'fig');

    % SMALL SPACING
    figure
    clear legends
    
    for i = 1 : imagenum
    
        % plot fits first so they go behind the data
        fitIplot = fitS(i).all;
        semilogy(ivsqS(i).data(:,1), fitIplot, 'Color', [105/255, 105/255, 105/255]);
        hold on;

        % plot of actual data
        dataIplot = ivsqS(i).data(:,2);
        semilogy(ivsqS(i).data(:,1), dataIplot, 'Color', rainbow(i,:));
        hold on;

        % make legends
        legends(2*i-1).name = ['D = ', num2str(allinfo_D(i)), ', SD = ', num2str(allinfo_sD(i))];
        legends(2*i).name = imagelist(i).name;
        
    end

    % manual axis control - should automate later
    title(header); 
    xlabel('q [nm^{-1}]'); 
    ylabel('Intensity [a.u.]');
    legend(legends.name,-1);
    axis([(min(humpq)-0.25) (max(humpq)+0.25) 0.1 2^(imagenum+0.5)]);
    hold off;

    imfname = strcat(prefix,'Iq-yesfit-tight');
    saveas(gcf, imfname, 'tiffn');
    saveas(gcf, imfname, 'fig');
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% azimuthal scan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if azimuthal_plot == 1

    figure
    clear legends
    for i = 1 : imagenum
        plot((180/pi)*storeaz(i).theta, storeaz(i).laz, 'Color', rainbow(i,:));
        hold on;
        legends(i).name = ['height = ', num2str(height(i))];
    end

    title(header); 
    xlabel('\phi [deg]');
    ylabel('Intensity [a.u.]');
    legend(legends.name, -1);
    grid on; 
    axis tight; 
    hold off;

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Diameter and Hermans 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if everything_plot == 1

    figure
    clear legends;
    
    hermLine = line(height, herm, 'Color', 'r', 'LineStyle','s', 'LineStyle',':',...
        'Color', [1 0 0], 'LineWidth',2);
    axis tight;
    
    if imagenum == 1
        heightend = 0.2;
    else
        heightend = height(imagenum);
    end
    
    axis([min(height) max(height) (min(herm) - 0.1) (max(herm) + 0.1)]);
    set(gca,'XTick',min(height):increment:max(height))
   
    ax1 = gca;
    ylabel('Hermans Parameter', 'Color', 'r');
    xlabel(x1);

    ax2 = axes('Position',get(ax1,'Position'),'XAxisLocation','top',...
        'YAxisLocation','right', 'Color', 'none', 'XColor','k','YColor','k');
    ylabel('dia');
    
    diaLine = line(height, allinfo_D, 'Parent', ax2, 'Color','k', 'LineStyle','s',...
        'LineStyle',':', 'LineWidth', 2);
    ylabel('Diameter [nm]', 'Color', 'k');

    axis tight;
    axis([min(height) max(height) (min(allinfo_D) - 0.5) (max(allinfo_D) + 0.5)]);
    set(gca,'XTick',min(height):increment:max(height))

    title(header);
    grid on;
    
    imfname = strcat(prefix,'-DHtrends');
    saveas(gcf, imfname, 'tiffn');
    saveas(gcf, imfname, 'fig');

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Diameter only with error bars
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if diameter_only_plot == 1

    figure
    clear legends;
    errorbar(height, allinfo_D(:,1), allinfo_sD(:,1), 'o', 'LineWidth',2); hold on;
    
    grid on; 
    hold off; 

    title(header);
    xlabel('Height [mm]'); 
    ylabel('Diameter [nm]');
    axis([min(height) max(height) (min(allinfo_D - allinfo_sD) - 0.5) (max(allinfo_D + allinfo_sD) + 0.5)]);
    set(gca,'XTick',min(height):increment:max(height))

    imfname = strcat(prefix,'-Dwitherrorbars');
    saveas(gcf, imfname, 'tiffn');
    saveas(gcf, imfname, 'fig');
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sD/D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    sDnorm = allinfo_sD./allinfo_D;
    figure
    hold on
    plot(height,sDnorm,'bx-','LineWidth',2)
    xlabel('Height [mm]');
    ylabel('Diameter/Stdev');
    grid on;
    axis([min(height) max(height) (min(sDnorm) - 0.025) (max(sDnorm) + 0.025)]);
    set(gca,'XTick',min(height):increment:max(height))

    title(header); 

    imfname = strcat(prefix,'sDnorm');
    saveas(gcf, imfname, 'tiffn');
    saveas(gcf, imfname, 'fig');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% c
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    figure
    hold on
    plot(height,allinfo_c,'bx-','LineWidth',2)
    xlabel('Height [mm]');
    ylabel('c = ID/OD');
    grid on;
    axis([min(height) max(height) (min(allinfo_c) - 0.05) (max(allinfo_c) + 0.05)]);
    set(gca,'XTick',min(height):increment:max(height))

    title(header); 

    imfname = strcat(prefix,'cvals');
    saveas(gcf, imfname, 'tiffn');
    saveas(gcf, imfname, 'fig');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% error
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    figure
    hold on
    plot(height,Elogrms,'bx-','LineWidth',2)
    xlabel('Height [mm]');
    ylabel('Logarithmic RMS error [a.u.]');
    grid on;
    axis([min(height) max(height) (min(Elogrms)*0.9) (max(Elogrms)*1.1)]);
    set(gca,'XTick',min(height):increment:max(height))

    title(header); 

    imfname = strcat(prefix,'Elogrms');
    saveas(gcf, imfname, 'tiffn');
    saveas(gcf, imfname, 'fig');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pdf plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    figure
    hold on

    for k = 1:imagenum
        Dset = 0:0.1:(2*allinfo_D(k));
    
        if dchoice == 'l'
            mul = logg_mu(allinfo_D(k),2*allinfo_sD(k));
            sgl = logg_sg(allinfo_D(k),2*allinfo_sD(k));
            thisatry = loggpdf(Dset,mul,sgl);
            % atry(i,:) = atry(i,:)/max(atry(i,:));
        else
            thisatry = gpdf(Dset,allinfo_D(k),2*allinfo_sD(k));
            % atry(i,:) = atry(i,:)/max(atry(i,:));
        end
        
        plot(Dset,thisatry,'Color', rainbow(k,:));
        legendss(k).name = [imagelist(k).name, ', sD = ', num2str(allinfo_sD(k))];

    end

    grid on
    xlabel('Diameter [nm]');
    ylabel('Probability density function');
    legend(legendss.name,'Location','NorthOutside');

    imfname = strcat(prefix,'logns');
    saveas(gcf, imfname, 'tiffn');
    saveas(gcf, imfname, 'fig');