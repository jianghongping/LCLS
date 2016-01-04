function backg = background_topleft(saxsi)

[rows, cols] = size(saxsi);

%bgoffset = 125;
xoffset=125;
yoffset=125;

bgwin = 50;

backgrounds = [saxsi(yoffset:(yoffset + bgwin),xoffset:(xoffset + bgwin))];
backg = mean(mean(backgrounds));

return