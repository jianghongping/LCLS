function [] = single_manual_plot_nofitting(storeim, imagelist,height,...
    imagenum, humpq, storeaz, ivsq, offset, xc, yc, prefix)

rainbow = get_rainbow_palette();

[token,remainder]=strtok(prefix,'/');
while ~isempty(remainder)
    [token,remainder]=strtok(remainder,'/');
end
runname=token;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% all images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plot_offsets(storeim, imagelist, offset, xc, yc);

imfname = strcat(prefix,'images-nofitset');
saveas(gcf, imfname, 'tiffn');
saveas(gcf, imfname, 'fig');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% intensity vs. q
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fitting_plot = 1;

if fitting_plot == 1

    maxtrack = 0;
    figure
    clear legends
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
    title(runname); 
    xlabel('q [nm^{-1}]'); 
    ylabel('Intensity [a.u.]');
    legend(legends.name,-1);
    axis([0 max(ivsq(1).data(:,1)) 0.01 maxtrack]);
    hold off;

    imfname = strcat(prefix,'Iq-nofit');
    saveas(gcf, imfname, 'tiffn');
    saveas(gcf, imfname, 'fig');

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% maximum locations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    dapprox = 2*pi./humpq;

    figure
    hold on
    subplot(2,1,1);
    plot(height,humpq,'bx-','LineWidth',2)
    ylabel('q of maxI [nm^-1]');
    grid on;
    
    heightmax = height(imagenum);
    increment=height(2)-height(1);
    
    axis([min(height) max(height) (min(humpq) - 0.1) (max(humpq) + 0.1)]);
    set(gca,'XTick',min(height):increment:max(height))

    subplot(2,1,2);
    plot(height,dapprox,'bx-.','LineWidth',2)
    xlabel('Height [mm]');
    ylabel('d = 2*pi/q [nm]');
    grid on

    axis([min(height) max(height) (min(dapprox) - 0.5) (max(dapprox) + 0.5)]);
    set(gca,'XTick',min(height):increment:max(height))

    title(runname); 

    imfname = strcat(prefix,'dapprox');
    saveas(gcf, imfname, 'tiffn');
    saveas(gcf, imfname, 'fig');

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% azimuthal scan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

azimuthal_plot = 1;

if azimuthal_plot == 1

    figure
    for i = 1 : imagenum
        plot((180/pi)*storeaz(i).theta, storeaz(i).laz, '.', 'Color', rainbow(i,:));
        hold on;
%        legends(i).name = ['height = ', int2str(i), '    q = ',...
%            num2str(humpq(i),2), ' nm^{-1}'];
    end
    title(runname); 
    xlabel(' \phi [deg]'); 
    ylabel('Intensity [a.u.]');
    legend(legends.name, -1);
    grid on; 
    axis tight; 
    hold off;

    imfname = strcat(prefix,'azscans-nofit');
    saveas(gcf, imfname, 'tiffn');
    saveas(gcf, imfname, 'fig');

end