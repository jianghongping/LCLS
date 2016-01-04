function [yind, xind, k] = get_initial_guess(storeim, imagelist, center_finding)

k = 1;
num_im = length(storeim);

if k == 1 && num_im == 1
    figure(k);
    disp('Only one image available for center finding');
    imagesc(storeim(k).images); hold on;
    title(imagelist(k).name);
    set(gca,'DataAspectRatio',[1,1,1])
        
elseif k == 1 && num_im > 1
    figure(k);
    imagesc(storeim(k).images); hold on;
    title(imagelist(k).name);
    set(gca,'DataAspectRatio',[1,1,1])
    
    clc;
    disp('This is the first image');
    disp('s to select current image for center finding');
    disp('n for next image');
    selection = input('Enter your selection [s/n] > ', 's');
    while k <= num_im && k >= 1 && selection ~= 's'
        close(k);
        if selection == 'n'
            k = k + 1;
        elseif selection == 'p'
            k = k - 1;
        end

        if k < num_im && k > 1
            figure(k);
            imagesc(storeim(k).images); hold on;
            title(imagelist(k).name);
            set(gca,'DataAspectRatio',[1,1,1])
        
            clc;
            disp('p for previous image');
            disp('s to select current image');
            disp('n for next image');
            selection = input('Enter your selection [p/s/n] > ', 's');
            
        elseif k == num_im 
            figure(k);
            imagesc(storeim(k).images); hold on;
            title(imagelist(k).name);
            set(gca,'DataAspectRatio',[1,1,1])

            clc;
            disp('This is the last image');
            disp('p for previous image');
            disp('s to select current image');
            selection = input('Enter your selection [p/s] > ', 's');
            while selection ~= 'p' && selection ~= 's'
                clc;
                disp('Invalid selection, please try again');
                disp(' ');
                disp('This is the last image');
                disp('p for previous image');
                disp('s to select current image');
                selection = input('Enter your selection [p/s] > ', 's');
            end
                
            
        elseif k == 1
            figure(k);
            imagesc(storeim(k).images); hold on;
            title(imagelist(k).name);
            set(gca,'DataAspectRatio',[1,1,1])
            
            clc;
            disp('This is the first image');
            disp('s to select current image for center finding');
            disp('n for next image');
            selection = input('Enter your selection [s/n] > ', 's');
            while selection ~= 'n' && selection ~= 's'
                clc;
                disp('Invalid selection, please try again');
                disp(' ');
                disp('This is the first image');
                disp('s to select current image for center finding');
                disp('n for next image');
                selection = input('Enter your selection [s/n] > ', 's');
            end               
        end
    end
end

if center_finding == 1
    datacursormode on;
    [yind, xind] = ginput(1);
elseif center_finding == 0
    disp(' ');
    disp('1. Graphically enter the center');
    disp('2. Numerically enter the center');
    m_center_option = input('Please make a selection [1/2] > ');
    disp(' ');
    if m_center_option == 1
        
        goahead = input('Enter when ready > ');
        if isempty(goahead)
            datacursormode on;
            [yind, xind] = ginput(1);
        end
        
    elseif m_center_option == 2
        
        go_ahead = 'n';
        while ~isempty(go_ahead)
            yind = input('Please enter x [horizontal] center > ');
            xind = input('Please enter y [vertical] center > ');
            disp(['You have entered -> x = ',int2str(yind),...
                ' y = ',int2str(xind)]);
            go_ahead = input('Enter to accept or anything else to change [Enter/*] > ');
        end
    end        
end
        
        
xind = ceil(xind);  % convert into integers
yind = ceil(yind);
close(k);

return
