function [xLine xLine_A box_coord box_coord_A centers]...
    = getCenter(storeim, center_finding, imagelist, offset, beamstop)

imagenum = length(storeim);
centers = zeros(imagenum,2);
xLine_A = zeros(6,2,imagenum);
box_coord = zeros(4,2);
box_coord_A = zeros(4,2,imagenum);

start_fitting = 'n';

while start_fitting == 'n'  % n for no

    % get initial guess from user
    % s is the image index that the user...
    % has selected for finding the center
    
    [yind xind s] = get_initial_guess(storeim, imagelist, center_finding);
    %Hardcode centervalues for consistent location
    %yind=885;
    %xind=880;
    s=1;
    good_center = 'n';      % n for no
    user_I = 3; % default value

    % box_coord = [TX LY; TX RY; BX LY; BX RY];
    % xLine = [LXcoord; RXcoord; TYcoord; BYcoord; LY-lh_arm RY+rh_arm; xc yc];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if center_finding == 1  % semi-automatic center finding
        
        while good_center ~= 'y'
            [box_coord xLine] = findEdge(xind, yind, storeim(s).images, user_I);
            figure(s); clf;
            focus = 1;
            
            xLine(6,2)=xind;
            xLine(6,1)=yind;
            
            plot_center_redo(storeim, imagelist, s, box_coord, xLine, focus, offset);

            clc;
            good_center = input('Enter to accept the center or anything else to try again > ', 's');
            if ~isempty(good_center)
                user_I = input('Please enter a number between 2.5 and 3.5 > ');
            elseif isempty(good_center)
                close all;
            end
        end
        
    elseif center_finding == 0  % manual center finding
        % note that box_coord will be empty matrix
        
        xLine(6,1) = xind;
        xLine(6,2) = yind;
        
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for i = 1 : length(storeim)
        %         disp(['Finding center for ', imagelist(i).name, '.']);
        %         [box_coord_A(:,:,i) xLine_A(:,:,i)] = findEdge(xind, yind, storeim(i).images, user_I);
        %         center_A(i,:) = xLine_A(6,:,i);
        %         offset_theta_A(i) = -atan((xLine_A(6,1,i) - xLine_A(1,1,i))...
        %             / (xLine_A(6,2,i) - xLine_A(1,2,i)));
        centers(i,:) = xLine(6,:);
        box_coord_A(:,:,i) = box_coord;
        xLine_A(:,:,i) = xLine;
    end
    
    s = 0;  % set s to 0 if you want to plot all
    focus = 0;  % 1 for zoom in, 0 for zoom out

    offset = ones(length(storeim),1) * 0;
    %plot_center_redo(storeim, imagelist, s, box_coord_A, xLine_A, focus, offset);
    
    clc;
    response = input('Press Enter to continue...or anything else to start over [Enter/*] >', 's');
    if isempty(response)
        start_fitting = 'y';
    end

    clc;
    close all;

end