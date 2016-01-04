function backg = background_topright(saxsi)

[rows, cols] = size(saxsi);

bgoffset = 125;
bgwin = 50;

backgrounds = [saxsi(bgoffset:(bgoffset + bgwin),(cols-bgoffset-bgwin):(cols-bgoffset))];
backgrounds = [saxsi(bgoffset:(bgoffset + bgwin),(cols - 20 -bgoffset-bgwin):(cols - 20 -bgoffset))];
backg = mean(mean(backgrounds));

return