function [ saxOut,storeimOut ] = SaxsiInterval( saxsi,storeim,interval )
%sums and averages images of saxsi and takes x,y,z from top image
avgImage=zeros(size(saxsi(1).images));
avgRaw=zeros(size(saxsi(1).raw));
avgStoreIm=zeros(size(storeim(1).images));
energy=0;
for i=interval(1):interval(2)
    avgImage=avgImage+saxsi(i).images;
    avgStoreIm=avgStoreIm+storeim(i).images;
    avgRaw=avgRaw+saxsi(i).raw;
    energy=energy+saxsi(i).energy;
end
intLength=length((interval(1):interval(2)));
aveImage=avgImage/intLength;
aveRaw=avgRaw/intLength;
aveStoreIm=avgStoreIm/intLength;
energy=energy/intLength;
storeimOut.images=aveStoreIm;
saxOut.images=aveImage;
saxOut.raw=aveRaw;
saxOut.interval=[interval(1),interval(2)];
saxOut.x=saxsi(interval(2)).x;
saxOut.y=saxsi(interval(2)).y;
saxOut.z=saxsi(interval(2)).z;
saxOut.x=saxsi(interval(2)).x;
saxOut.energy=energy;
saxOut.index=saxsi(interval(2)).index;
end