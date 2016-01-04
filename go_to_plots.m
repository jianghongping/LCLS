function [] = go_to_plots(storeim, imagelist, box_coord_A, xLine_A,...
    start, increment, plot_title, x1, imagenum, herm, humpq, storeaz,...
    ivsq, fit, allinfo_D, allinfo_sD, diameter_only_plot,...
    everything_plot, azimuthal_plot, fitting_plot, offset)

% Rainbow color palette
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rainbow = get_rainbow_palette();
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if imagenum > 1
    height = (start : increment : (start + increment * (imagenum-1)));
else
    height = increment;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% color map
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s = 0; % s = 0 means show every image
focus = 0;
plot_center(storeim, imagelist, s, box_coord_A, xLine_A, focus, offset);
% saveas(gcf, 'SaxsImages.tiff', 'tiffn');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% intensity vs. q
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if fitting_plot == 1

    figure
    clear legends
    for i = 1 : imagenum
        % plot fits first so they go behind the data
        fitIplot = 10.^(log10(fit(i).all) + ((i-1) * 0.2));
        semilogy(ivsq(i).data(:,1), fitIplot, 'Color', [105/255, 105/255, 105/255]);
        hold on;

        % plot of actual data
        dataIplot = 10.^(log10(ivsq(i).data(:,2)) + ((i-1) * 0.2));
        semilogy(ivsq(i).data(:,1), dataIplot, 'Color', rainbow(i,:));
        hold on;

        % make legends
        legends(2*i-1).name = ['D = ', num2str(allinfo_D(i)), ', SD = ', num2str(allinfo_sD(i))];
        legends(2*i).name = imagelist(i).name;
    end

    % manual axis control - should automate later
    title('Intensity vs. q'); xlabel('q [nm^{-1}]'); ylabel('Intensity [a.u.]');
    legend(legends.name, -1);
    axis([0.6 1.2 1e4 1e6]);
    axis tight;
    hold off;
%     saveas(gcf, 'Intensity_&_Fitting.tiff', 'tiffn');

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
        legends(i).name = ['height = ', int2str(i), '    q = ',...
            num2str(humpq(i),2), ' nm^{-1}'];
    end
    title('Azimuthal scan'); xlabel(' \phi [deg]'); ylabel('Intensity [a.u.]');
    legend(legends.name, 1);
    grid on; axis tight; hold off;
%     saveas(gcf, 'AzimuthalScanPlot.tiff', 'tiffn');

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hermans parameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if everything_plot == 1

    figure
    clear legends;
    hermLine = line(height, herm, 'Color', 'r', 'LineStyle','s', 'LineStyle',':',...
        'Color', [1 0 0], 'LineWidth',2);
    ax1 = gca;
    
    if imagenum > 1
        axis([start height(end) 0 0.6]);
    end
       
    ylabel('Hermans Parameter', 'Color', 'r');
    xlabel(x1);

    ax2 = axes('Position',get(ax1,'Position'),'XAxisLocation','top',...
        'YAxisLocation','right', 'Color', 'none', 'XColor','k','YColor','k');
    ylabel('dia');
    diaLine = line(height, allinfo_D, 'Parent', ax2, 'Color','k', 'LineStyle','s',...
        'LineStyle',':', 'LineWidth', 2);
    ylabel('Diameter [nm]', 'Color', 'k');
    axis tight;
    title(plot_title);
    grid on;
%     saveas(gcf, 'Hermans_&_Diameter.tiff', 'tiffn');
end


%
% figure
% clear legends;
%
% herm = flip_data(herm);
% allinfo_D = flip_data(allinfo_D);
%
%
% height = (0 : 0.1 : 0.1*(imagenum-1));
%
%
% hermLine = line(height, herm, 'Color', 'r', 'LineStyle','s', 'LineStyle',':',...
%     'Color', [1 0 0], 'LineWidth',2);
% ax1 = gca;
% axis([0 height(end) 0 0.6]);
% ylabel('Hermans Parameter', 'Color', 'r');
% xlabel('Height [mm]');
%
% ax2 = axes('Position',get(ax1,'Position'),'XAxisLocation','top',...
%            'YAxisLocation','right', 'Color', 'none', 'XColor','k','YColor','k');
% ylabel('dia');
% diaLine = line(height, allinfo_D, 'Parent', ax2, 'Color','k', 'LineStyle','s',...
%     'LineStyle',':', 'LineWidth', 2);
% ylabel('Diameter [nm]', 'Color', 'k');
%
% title(plot_title);
% grid on;
% axis tight;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Diameter vs Height with Error Bar at Selected Window Size
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if diameter_only_plot == 1

    figure
    clear legends;
    errorbar(height, allinfo_D, allinfo_sD, 'o', 'LineWidth',2); hold on;
    grid on; hold off; title(['Diameter vs. Height']);
    xlabel('Height [mm]'); ylabel('Diameter [nm]');
%     saveas(gcf, 'Diameter_&_StdDev.tiff', 'tiffn');

end
