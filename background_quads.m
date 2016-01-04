function backg = background_quads(saxsi)

[rows, cols] = size(saxsi);

bgoffset = 100;
bgwin = 100;

backgrounds1 = [saxsi(bgoffset:(bgoffset + bgwin),(cols-bgoffset - bgwin):(cols-bgoffset))];
backgrounds2 = [saxsi(bgoffset:(bgoffset + bgwin),bgoffset:(bgoffset + bgwin))];
backgrounds3 = [saxsi((rows-bgoffset - bgwin):(rows-bgoffset),bgoffset:(bgoffset + bgwin))];
backgrounds4 = [saxsi((rows-bgoffset - bgwin):(rows-bgoffset),(cols-bgoffset - bgwin):(cols-bgoffset))];


backg1 = mean(mean(backgrounds1))
backg2 = mean(mean(backgrounds2))
backg3 = mean(mean(backgrounds3))
backg4 = mean(mean(backgrounds4))

backg = mean(mean([backgrounds1 backgrounds2 backgrounds3 backgrounds4]));

return