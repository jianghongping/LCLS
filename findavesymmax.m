function maxloc = findavesymmax(vecin,win)

% win = +/- value of moving average window

maxstore = 0;
maxidx = 1;

for i = (1+win):(length(vecin)-win)
    locmean = mean(vecin((i-win):(i+win)));
    if locmean > maxstore
        maxstore = locmean;
        maxidx = i;
    end
end
    maxloc = maxidx;
end