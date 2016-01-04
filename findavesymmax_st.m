function maxloc = findavesymmax_st(vecin, stp, win)

% win = +/- value of moving average window

maxstore = 0;
maxidx = stp;

for i = (stp+win+1):(length(vecin)-win)
    locmean = mean(vecin((i-win):(i+win)));
    if locmean > maxstore
        maxstore = locmean;
        maxidx = i;
    end
end
    maxloc = maxidx;
end