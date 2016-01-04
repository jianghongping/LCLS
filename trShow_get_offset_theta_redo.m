function [offset_theta,xy] = trShow_get_offset_theta_redo(simage, imagename, saxsi, xc, yc, raz, dtheta,...
    window, box_coord, xLine, offchoice, beamstop, thetamin, thetamax)

% azimuthal scans for finding theta offset
mthwin = 10;
mthavg = 0;

% figure
% imagesc(storeim(k).images)
% set(gca,'DataAspectRatio',[1,1,1])
% title(imagelist(k).name)
% hold on
% x=linspace(-raz(k),raz(k),201)+xc;
% yup=sqrt((raz(k))^2-(x-xc).^2)+yc;
% ydn=-sqrt((raz(k))^2-(x-xc).^2)+yc;
% plot(x,yup,'k-')
% plot(x,ydn,'k-')

if beamstop == 1
    
    th_st1 = -pi/6+(thetamin+thetamax)/2;
%    th_st1 = -5*pi/180; % for beamcenter close to detector's bottom
    th_ed1 = pi/6+(thetamin+thetamax)/2;
 
    th_st2 = 5*pi/6+(thetamin+thetamax)/2;
    th_ed2 = 7*pi/6+(thetamin+thetamax)/2;
%    th_ed2 = 185*pi/180; % for beamcenter close to detector's bottom

    az_1= azimuthal_masked(saxsi, xc, yc, dtheta, raz, window, th_st1, th_ed1);
    az_1(:,1)=az_1(:,1)-(thetamin+thetamax)/2;
    mth1 = findavesymmax(az_1(:,2),mthwin);
    xy=showAzimuthal(saxsi, xc, yc, dtheta, raz, window, th_st1, th_ed1);
    az_2 = azimuthal_masked(saxsi, xc, yc, dtheta, raz, window, th_st2, th_ed2);
    xy2=showAzimuthal(saxsi, xc, yc, dtheta, raz, window, th_st2, th_ed2);
    az_2(:,1)=az_2(:,1)-(thetamin+thetamax)/2;
    mth2 = findavesymmax(az_2(:,2),mthwin);

    mthavg = mean([az_1(mth1,1),az_2(mth2,1) - pi]);

    
  
%  figure
%  plot(az_1(:,1),az_1(:,2));
%  figure
%  plot(az_2(:,1),az_2(:,2));
%  pause

elseif beamstop == 0
    
    th_st1 = 11*pi/24;
    th_ed1 = 25*pi/24;
    az_1 = azimuthal_masked_strict(saxsi, xc, yc, dtheta, raz, window, th_st1, th_ed1);
    az_1(:,1)=az_1(:,1)-(thetamin+thetamax)/2;
    mth1 = findavesymmax(az_1(:,2),mthwin);

    mthavg = az_1(mth1,1) - pi;
    
%    plot(az_1(:,1),az_1(:,2));
%    pause

elseif beamstop == 2
    
    th_st1 = -12*pi/24;
    th_ed1 = 12*pi/24;
    
    th_st2 = -12*pi/24;
    th_ed2 = 12*pi/24;
    
    az_1 = azimuthal_masked_strict(saxsi, xc, yc, dtheta, raz, window, th_st1, th_ed1);
    az_1(:,1)=az_1(:,1)-(thetamin+thetamax)/2;
    mth1 = findavesymmax(az_1(:,2),mthwin);

    mthavg = az_1(mth1,1);
    
%    plot(az_1(:,1),az_1(:,2));
%    pause

end

offset_theta = mthavg;
offset_theta*180/pi;
focus = 0;

if offchoice ~= '1'

auto_offset = '1';

    while ~isempty(auto_offset);    

        az_display1 = azimuthal_masked(saxsi, xc, yc, dtheta, raz, window, th_st1, th_ed1);
        az_display2 = azimuthal_masked(saxsi, xc, yc, dtheta, raz, window, th_st2, th_ed2);
        %Comment out for speed
        %display_offset_redo(simage, imagename, xLine, xc, yc, offset_theta+(thetamin+thetamax)/2, az_display1, az_display2, focus);

        % offset_theta*180/pi
        %Automate Enter by substituting ''
        auto_offset = '';%input('Press Enter to accept offset angle, or press anything else for manual input [Enter/*] > ','s');

        if ~isempty(auto_offset)
            offset_store = input('Enter new offset angle [deg] > ');
            if isempty(offset_store)
                [xp,yp]=ginput(1);
                offset_store=atand((yc-yp)/(xp-xc))-(thetamin+thetamax)/2*180/pi;
                if offset_store>90
                    offset_store=offset_store-180;
                elseif offset_store<-90
                    offset_store=offset_store+180;
                else
                    offset_store;
                end
            end
            offset_theta = offset_store*pi/180;
        end

    end

end

close all
disp(' ');

return