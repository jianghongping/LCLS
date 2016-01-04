function [min_loc passfail] = findavemin(vecin, start, win)

i = start;
end_idx = length(vecin) - win; % (win + 1)
prev_mean = mean(vecin(i : (i + win - 1)));
next_mean = mean(vecin((i + 1) : (i + win)));

passfail = 1;   % 1 if not mono decreasing

while  prev_mean > next_mean  && i < end_idx
    
    prev_mean = next_mean;
    i = i + 1;
    next_mean = mean(vecin((i + 1) : (i + win)));

    if i == end_idx
        passfail = 0;
    end
    
    min_loc = i + floor(win/2);
end

% if it misses the while loop, give minLoc the starting index + 2
if i == start
%     disp('try giving higher starting point');
    min_loc = i + floor(win/2);
end

return

