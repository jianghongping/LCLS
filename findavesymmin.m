function [min_loc passfail] = findavesymmin(vecin, start, win)

i = start + win;
end_idx = length(vecin) - win - 1;

prev_mean = mean(vecin((i-win):(i+win)));
next_mean = mean(vecin((i-win+1):(i+win+1)));

passfail = 1;   % 1 if not mono decreasing

if prev_mean > next_mean


while  prev_mean > next_mean && i < end_idx
    
    prev_mean = next_mean;

    i = i + 1;
    next_mean = mean(vecin((i-win+1):(i+win+1)));

    if i == end_idx
        passfail = 0;
    end
    
    min_loc = i;
    
end

% if it misses the while loop, set minimum at 25 pixels from the starting
% point
else
    min_loc = start + 25;
end