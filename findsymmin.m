function [min_loc passfail] = findsymmin(vecin, start, win)

i = start + win;
end_idx = length(vecin) - win;

prev_mean = mean(vecin((i-win):(i+win)));
next_mean = mean(vecin((i-win+1):(i+win+1)));

passfail = 1;   % 1 if not mono decreasing

while  prev_mean > next_mean  && i < end_idx
    
    prev_mean = next_mean;

    i = i + 1;
    next_mean = mean(vecin((i-win+1):(i+win+1)));

    if i == end_idx
        passfail = 0;
    end
    
    min_loc = i;

end

% if it misses the while loop, give minLoc the starting index + 2

if i == start
    min_loc = i;
end

return

