function [storeim, saxs] = read_all_images_LCLSmat_masked(imagelist, imagenum, mask,fpath)
%Tom Riis: Added fpath to deal with separate run folders
for k = 1 : imagenum
    
    % read images one by one
    imagepath = strcat(fpath,imagelist(k).name);
    images(k).data = importdata(imagepath);

    % image named as saxsi
    intint = images(k).data;
    saxsi = intint;
%     saxsi = intint.single;

    % cast from integer to double
    saxsi = double(saxsi);
    %saxsi = im2double(saxsi);
    %saxsi = 65536 * saxsi;
    %saxsi = rot90(saxsi);
    %saxsi = rot90(saxsi);
    %saxsi = rot90(saxsi);
    %saxsi = fliplr(saxsi);
    
    %Masking
    saxsi=saxsi.*~mask;
    saxsi = rot90(saxsi);
    saxsi = rot90(saxsi);

    % calculate background
%     if ccd_type == 1; % Brookhaven
%         backg = background_azimuthal(saxsi);
%     else % CHESS
%         if beamstop_position == 0;
%             backg = background_topleft(saxsi);
%         elseif beamstop_position == 1;
%             backg = background_topleft(saxsi);
%             % backg = (background_topleft(saxsi) + background_topright(saxsi))/2;
%         elseif beamstop_position == 2;
%             backg = background_topright(saxsi);
%         end
%     end
% 
%     % substract background
%     saxsi = saxsi - backg;
      
    % plot image with logarithimic intensity scale (as in polar)
    saxsia = abs(saxsi)+1;
    saxsiaa = abs(saxsia);
    %saxsiaaf = (max(saxsiaa)/min(saxsiaa))*saxsiaa;
    saxsiaaf=saxsiaa;

    warning off MATLAB:log:logOfZero

    saxsial = log(saxsiaaf);
      
    % store image info for later plots
    saxs(k).images = saxsi;
    storeim(k).images = saxsial;
    
end

return