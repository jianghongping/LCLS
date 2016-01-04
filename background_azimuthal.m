function backg = background(saxsi)

[rows, cols] = size(saxsi);

% backgrounds = azimuthal(saxsi,512,512,0.5*pi/360,505,3,0,2*pi);
backgrounds = azimuthal(saxsi,ceil(size(saxsi,2)/2),ceil(size(saxsi,1)/2),0.5*pi/360,min([floor(size(saxsi,2)/2) floor(size(saxsi,1)/2)])-10,3,0,2*pi);

backg = mean(mean(backgrounds));

return