function [storeim saxs] = read_all_images_edf(imagelist, imagenum, ccd_type, beamstop_position)

for k = 1 : imagenum
    
    % read images one by one
    imagepath = strcat('imagerun/',imagelist(k).name);
    imagelist;
    [fid,errmsg] = fopen(imagepath);
    fseek(fid, 1024, 'bof');
    [images(k).name, count] = fread(fid,[981,1043],'*int32','l'); % 1M
%     [images(k).name, count] = fread(fid,[487,195],'*int32','l'); % 100k
    images(k).name = fliplr(images(k).name);
    images(k).name = rot90(images(k).name);
%     images(k).name = flipud(images(k).name);
    fclose(fid);
      
    % image named as saxsi
    saxsi = images(k).name;
    saxsi = double(saxsi);
    saxsiaaf = saxsi;
%     saxsiaaf = fliplr(saxsiaaf);

%     % cast from integer to double
%     saxsi = double(saxsi);
%     %saxsi = im2double(saxsi);
%     saxsi = 65536 * saxsi;
% 
%     % calculate background
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
%       
%     % plot image with logarithimic intensity scale (as in polar)
%     saxsia = abs(saxsi);
%     saxsiaa = abs(saxsia);
%     saxsiaaf = (max(saxsiaa)/min(saxsiaa))*saxsiaa;

    warning off MATLAB:log:logOfZero

    saxsial = log(saxsiaaf);
      
    % store image info for later plots
    saxs(k).images = saxsiaaf;
    storeim(k).images = saxsial;
    
end

return