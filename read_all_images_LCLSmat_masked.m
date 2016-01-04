function [storeim, saxs] = read_all_images_LCLSmat_masked(imagelist, imagenum, mask)

for k = 1 : imagenum
    
    % read images one by one
    imagepath = strcat('imagerun/',imagelist(k).name);
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
%     backg = background_topright(saxsi);
%         elseif beamstop_position == 1;
%             backg = background_topleft(saxsi);
%             % backg = (background_topleft(saxsi) + background_topright(saxsi))/2;
%         elseif beamstop_position == 2;
%             backg = background_topright(saxsi);
%         end
%     end
% 
%     backMat=zeros(size(saxsi))+backg;
%     backMat=backMat.*~mask;
%     backMat=rot90(backMat);
%     backMat=rot90(backMat);
%     %%substract background
%     saxsi = saxsi - backMat;
    
    % plot image with logarithimic intensity scale (as in polar)
    saxsia = abs(saxsi)+1;
    saxsiaa = abs(saxsia);
    %saxsiaaf = (max(saxsiaa)/min(saxsiaa))*saxsiaa;
    saxsiaaf=saxsiaa;

    warning off MATLAB:log:logOfZero

    saxsial = log(saxsiaaf);
      
    % store image info for later plots
    saxs(k).images = saxsi;
    storeim(k).images =saxsi;% saxsial;
    
end

return