%Separate between saxs and waxs
%Separate by average top and bottom Grab corresponding hermdata
clear all;
run='Run 36';
if isempty(dir('output/*waxs*Avg*'))
    waxs(1)=dir('output/*Waxs*Avg*');
    waxs(2)=dir('output/*Waxs*Top*');
    waxs(3)=dir('output/*Waxs*Base*');
else
    waxs(1)=dir('output/*waxs*Avg*');
waxs(2)=dir('output/*waxs*Top*');
waxs(3)=dir('output/*waxs*Base*');
end



if isempty(dir('output/*saxs*Avg*'))
    saxs(1)=dir('output/*Saxs*Avg*');
    saxs(2)=dir('output/*Saxs*Top*');
    saxs(3)=dir('output/*Saxs*Base*');
else
    saxs(1)=dir('output/*saxs*Avg*');
saxs(2)=dir('output/*saxs*Top*');
saxs(3)=dir('output/*saxs*Base*');
end
%grab corresponding hermdata
for i=1:length(waxs)
    Waxs{i}=importdata(strcat('output/',waxs(i).name,'/hermdata.csv'));
    Saxs{i}=importdata(strcat('output/',saxs(i).name,'/hermdata.csv'));
end


%1 height    2 Hermans     3 hermans fit     5 scattering I     6 peakI     7 peaklocation

%Peak locations
for j=1:length(waxs)
    
    waxsheight{j}=Waxs{j}(:,1);
    
    waxsPeakI{j}=Waxs{j}(:,7);
    waxsScatI{j}=Waxs{j}(:,5);
    waxsPinten{j}=Waxs{j}(:,6);
    waxsherm{j}=Waxs{j}(:,2);
    waxshermfit{j}=Waxs{j}(:,3);
    
    
    saxsheight{j}=Saxs{j}(:,1);
    saxsPeakI{j}=Saxs{j}(:,7);
    saxsScatI{j}=Saxs{j}(:,5);
    saxsPinten{j}=Saxs{j}(:,6);
    saxsherm{j}=Saxs{j}(:,2);
    saxshermfit{j}=Saxs{j}(:,3);
    
end
for i=1:3
    if i==1
    maxH=max(max([waxsheight{:,i}]),max([saxsheight{:,i}]));
    minH=min(min([waxsheight{:,i}]),min([saxsheight{:,i}]));
    maxPeakI=max(max([waxsPeakI{:,i}]),max([saxsPeakI{:,i}]));
    minPeakI=min(min([waxsPeakI{:,i}]),min([saxsPeakI{:,i}]));
    maxScatI=max(max([waxsScatI{:,i}]),max([saxsScatI{:,i}]));
    minScatI=min(min([waxsScatI{:,i}]),min([saxsScatI{:,i}]));
    maxPinten=max(max([waxsPinten{:,i}]),max([saxsPinten{:,i}]));
    minPinten=min(min([waxsPinten{:,i}]),min([saxsPinten{:,i}]));
    maxHerm=max(max([waxshermfit{:,i}]),max([saxshermfit{:,i}]));
    minHerm=min(min([waxshermfit{:,i}]),min([saxshermfit{:,i}]));
    end
    maxH2=max(max([waxsheight{:,i}]),max([saxsheight{:,i}]));
    minH2=min(min([waxsheight{:,i}]),min([saxsheight{:,i}]));
    maxPeakI2=max(max([waxsPeakI{:,i}]),max([saxsPeakI{:,i}]));
    minPeakI2=min(min([waxsPeakI{:,i}]),min([saxsPeakI{:,i}]));
    maxScatI2=max(max([waxsScatI{:,i}]),max([saxsScatI{:,i}]));
    minScatI2=min(min([waxsScatI{:,i}]),min([saxsScatI{:,i}]));
    maxPinten2=max(max([waxsPinten{:,i}]),max([saxsPinten{:,i}]));
    minPinten2=min(min([waxsPinten{:,i}]),min([saxsPinten{:,i}]));
    maxHerm2=max(max([waxshermfit{:,i}]),max([saxshermfit{:,i}]));
    minHerm2=min(min([waxshermfit{:,i}]),min([saxshermfit{:,i}]));
    if maxHerm2>maxHerm
        maxHerm=maxHerm2;
    end
    if minHerm2<minHerm
        minHerm=minHerm2;
    end
    if maxPeakI2>maxPeakI
        maxPeakI=maxPeakI2;
    end
    if minPeakI2<minPeakI
        minPeakI=minPeakI2;
    end
    if maxScatI2>maxScatI
        maxScatI=maxScatI2;
    end
    if minScatI2<minScatI
        minScatI=minScatI2;
    end
    if maxPinten2>maxPinten
        maxPinten=maxPinten2;
    end
    if minPinten2<minPinten
        minPinten=minPinten2;
    end
    
end
    figure
    subplot(3,2,1)
    plot(waxsheight{1},waxsPeakI{1},'bx-','LineWidth',2)
    ylabel('q of maxI [A^-1]');
    grid on;
    axis([-inf inf minPeakI maxPeakI])
    title('Waxs Avg')

    subplot(3,2,2)
    plot(saxsheight{1},saxsPeakI{1},'bx-','LineWidth',2)
    ylabel('q of maxI [A^-1]');
    grid on;
    axis([-inf inf minPeakI maxPeakI])
    title('Saxs Avg')
   
    subplot(3,2,3)
    plot(waxsheight{2},waxsPeakI{2},'bx-','LineWidth',2)
    ylabel('q of maxI [A^-1]');
    grid on;
    axis([-inf inf minPeakI maxPeakI])
    title('Waxs Top')

    subplot(3,2,4)
    plot(saxsheight{2},saxsPeakI{2},'bx-','LineWidth',2)
    ylabel('q of maxI [A^-1]');
    axis([-inf inf minPeakI maxPeakI])
    grid on;
    title('Saxs Top')

subplot(3,2,5)
plot(waxsheight{3},waxsPeakI{3},'bx-','LineWidth',2)
ylabel('q of maxI [A^-1]');
    grid on;
    title('Waxs Base')
    axis([-inf inf minPeakI maxPeakI])
    
    subplot(3,2,6)
    plot(saxsheight{3},saxsPeakI{3},'bx-','LineWidth',2)
    axis([-inf inf minPeakI maxPeakI])
    ylabel('q of maxI [A^-1]');
    grid on;
    title('Saxs Base')
    hold on
    jisuptitle(strcat(run,' dapprox'));
    
    
    x1 = 'Distance from base of VACNT [mm]';
    %%%%%%%%%%%%%%%%%%%%%%%%%%SCATTERING Int%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\\
    figure;
    subplot(3,2,1)
    maxScatI=5*10E7
    hermLine = line(waxsheight{1}, waxsScatI{1}, 'Color', 'bl', 'LineStyle','s', 'LineStyle',':',...
        'Color', [1 0 0], 'LineWidth',2);
    axis tight;   
    ax1 = gca;
    ylabel('Scattering Intensity', 'Color', 'black');
    xlabel(x1);
    axis([-inf inf 0 maxScatI])
    title('Waxs Avg')
    
    subplot(3,2,2)
    hermLine = line(saxsheight{1}, saxsScatI{1}, 'Color', 'bl', 'LineStyle','s', 'LineStyle',':',...
        'Color', [1 0 0], 'LineWidth',2);
    axis tight;   
    ax1 = gca;
    ylabel('Scattering Intensity', 'Color', 'black');
    xlabel(x1);
    axis([-inf inf 0 maxScatI])
    title('Saxs Avg')
    
    subplot(3,2,3)
    hermLine = line(waxsheight{2}, waxsScatI{2}, 'Color', 'bl', 'LineStyle','s', 'LineStyle',':',...
        'Color', [1 0 0], 'LineWidth',2);
    axis tight;   
    ax1 = gca;
    ylabel('Scattering Intensity', 'Color', 'black');
    xlabel(x1);
    axis([-inf inf 0 maxScatI])
    title('Waxs Top')
    
    subplot(3,2,4)
    hermLine = line(saxsheight{2}, saxsScatI{2}, 'Color', 'bl', 'LineStyle','s', 'LineStyle',':',...
        'Color', [1 0 0], 'LineWidth',2);
    axis tight;   
    ax1 = gca;
    ylabel('Scattering Intensity', 'Color', 'black');
    xlabel(x1);
    axis([-inf inf 0 maxScatI])
    title('Saxs Top')
    
    subplot(3,2,5)
    hermLine = line(waxsheight{3}, waxsScatI{3}, 'Color', 'bl', 'LineStyle','s', 'LineStyle',':',...
        'Color', [1 0 0], 'LineWidth',2);
    axis tight;   
    ax1 = gca;
    ylabel('Scattering Intensity', 'Color', 'black');
    xlabel(x1);
    axis([-inf inf 0 maxScatI])
    title('Waxs Base')
    
    subplot(3,2,6)
    hermLine = line(saxsheight{3}, saxsScatI{3}, 'Color', 'bl', 'LineStyle','s', 'LineStyle',':',...
        'Color', [1 0 0], 'LineWidth',2);
    axis tight;   
    ax1 = gca;
    ylabel('Scattering Intensity', 'Color', 'black');
    xlabel(x1);
    axis([-inf inf 0 maxScatI])
    title('Waxs Base')
    jisuptitle(strcat(run,' Scattering Intensity'));
    
    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%% PEAK I %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   figure
   subplot(3,2,1)
   minPinten=1100;
   PeakILine = line(waxsheight{1}, waxsPinten{1}, 'Color', 'b', 'LineStyle','s', 'LineStyle',':',...
        'Color', [0 0 1], 'LineWidth',2);
    hold on;
    % Scale axis as neccessary
    xlabel('Height'); 
    ylabel('Peak Intensity');
    axis([-inf inf minPinten maxPinten])
    title('Waxs Avg')
    
    subplot(3,2,2)
   PeakILine = line(saxsheight{1}, saxsPinten{1}, 'Color', 'b', 'LineStyle','s', 'LineStyle',':',...
        'Color', [0 0 1], 'LineWidth',2);
    hold on;
    % Scale axis as neccessary
    xlabel('Height'); 
    ylabel('Peak Intensity');
    axis([-inf inf minPinten maxPinten])
    title('Saxs Avg')
    
    subplot(3,2,3)
   PeakILine = line(waxsheight{2}, waxsPinten{2}, 'Color', 'b', 'LineStyle','s', 'LineStyle',':',...
        'Color', [0 0 1], 'LineWidth',2);
    hold on;
    % Scale axis as neccessary
    xlabel('Height'); 
    ylabel('Peak Intensity');
    axis([-inf inf minPinten maxPinten])
    title('Waxs Top')
    
    subplot(3,2,4)
   PeakILine = line(saxsheight{2}, saxsPinten{2}, 'Color', 'b', 'LineStyle','s', 'LineStyle',':',...
        'Color', [0 0 1], 'LineWidth',2);
    hold on;
    % Scale axis as neccessary
    xlabel('Height'); 
    ylabel('Peak Intensity');
    axis([-inf inf minPinten maxPinten])
    title('Saxs Top')
    
    subplot(3,2,5)
   PeakILine = line(waxsheight{3}, waxsPinten{3}, 'Color', 'b', 'LineStyle','s', 'LineStyle',':',...
        'Color', [0 0 1], 'LineWidth',2);
    hold on;
    % Scale axis as neccessary
    xlabel('Height'); 
    ylabel('Peak Intensity');
    axis([-inf inf minPinten maxPinten])
    title('Waxs Base')
    
    subplot(3,2,6)
   PeakILine = line(saxsheight{3}, saxsPinten{3}, 'Color', 'b', 'LineStyle','s', 'LineStyle',':',...
        'Color', [0 0 1], 'LineWidth',2);
    hold on;
    % Scale axis as neccessary
    xlabel('Height'); 
    ylabel('Peak Intensity');
    axis([-inf inf minPinten maxPinten])
    title('Saxs Base')
    jisuptitle(strcat(run,' Raw Peak Intensity'))
    
    %%%%%%%%%%%%%%%%%% HERMANS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure
    minHerm=-0.05;
    subplot(3,2,1)
    hermLine = line(waxsheight{1}, waxsherm{1}, 'Color', 'r', 'LineStyle','s', 'LineStyle',':',...
        'Color', [1 0 0], 'LineWidth',2);
    hermfitLine = line(waxsheight{1}, waxshermfit{1}, 'Color', 'y', 'LineStyle','s', 'LineStyle',':',...
        'Color', [1 1 0], 'LineWidth',2);
    axis tight;
    ax1 = gca;
    ylabel('Herm (R) and HFit (Y)', 'Color', 'black');
    xlabel(x1);
    axis([-inf inf minHerm maxHerm])
    title('Waxs Avg')
    
    subplot(3,2,2)
    hermLine = line(saxsheight{1}, saxsherm{1}, 'Color', 'r', 'LineStyle','s', 'LineStyle',':',...
        'Color', [1 0 0], 'LineWidth',2);
    hermfitLine = line(saxsheight{1}, saxshermfit{1}, 'Color', 'y', 'LineStyle','s', 'LineStyle',':',...
        'Color', [1 1 0], 'LineWidth',2);
    axis tight;
    ax1 = gca;
    ylabel('Herm(R) and HFit(Y)', 'Color', 'black');
    xlabel(x1);
    axis([-inf inf minHerm maxHerm])
    title('Saxs Avg')
    
    subplot(3,2,3)
    hermLine = line(waxsheight{2}, waxsherm{2}, 'Color', 'r', 'LineStyle','s', 'LineStyle',':',...
        'Color', [1 0 0], 'LineWidth',2);
    hermfitLine = line(waxsheight{2}, waxshermfit{2}, 'Color', 'y', 'LineStyle','s', 'LineStyle',':',...
        'Color', [1 1 0], 'LineWidth',2);
    axis tight;
    ax1 = gca;
    ylabel('Herm(R) and HFit(Y)', 'Color', 'black');
    xlabel(x1);
     axis([-inf inf minHerm maxHerm])
    title('Waxs Top')
    
    subplot(3,2,4)
    hermLine = line(saxsheight{2}, saxsherm{2}, 'Color', 'r', 'LineStyle','s', 'LineStyle',':',...
        'Color', [1 0 0], 'LineWidth',2);
    hermfitLine = line(saxsheight{2}, saxshermfit{2}, 'Color', 'y', 'LineStyle','s', 'LineStyle',':',...
        'Color', [1 1 0], 'LineWidth',2);
    axis tight;
    ax1 = gca;
    ylabel('Herm(R) and HFit(Y)', 'Color', 'black');
    xlabel(x1);
     axis([-inf inf minHerm maxHerm])
    title('Saxs Top')
    
    
    subplot(3,2,5)
    hermLine = line(waxsheight{3}, waxsherm{3}, 'Color', 'r', 'LineStyle','s', 'LineStyle',':',...
        'Color', [1 0 0], 'LineWidth',2);
    hermfitLine = line(waxsheight{3}, waxshermfit{3}, 'Color', 'y', 'LineStyle','s', 'LineStyle',':',...
        'Color', [1 1 0], 'LineWidth',2);
    axis tight;
    ax1 = gca;
    ylabel('Herm(R) and HFit (Y)', 'Color', 'black');
    xlabel(x1);
     axis([-inf inf minHerm maxHerm])
    title('Waxs Base')
    
    subplot(3,2,6)
    hermLine = line(saxsheight{3}, saxsherm{3}, 'Color', 'r', 'LineStyle','s', 'LineStyle',':',...
        'Color', [1 0 0], 'LineWidth',2);
    hermfitLine = line(saxsheight{3}, saxshermfit{3}, 'Color', 'y', 'LineStyle','s', 'LineStyle',':',...
        'Color', [1 1 0], 'LineWidth',2);
    axis tight;
    ax1 = gca;
    ylabel('Herm(R) and HFit(Y)', 'Color', 'black');
    xlabel(x1);
     axis([-inf inf minHerm maxHerm])
    title('Saxs Base')
    jisuptitle(strcat(run,' Hermans'))
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    