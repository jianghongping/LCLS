function maxloc = findavemax(vecin,start,win)

maxstore = 0;
maxidx = 1;
for i = start:(length(vecin) - win)
    locmean = mean(vecin(i:(i+win - 1)));
    if locmean > maxstore
        maxstore = locmean;
        maxidx = i;
    end
    i = i + 1;
end

if maxidx > 480
    maxloc = 480;
else
    maxloc = maxidx + floor(win/2);
end