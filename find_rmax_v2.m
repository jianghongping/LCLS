function [rmax]=find_rmax_v2(window,center,offset,spread)
%rmax calculates the maximum radius at which the whole wedge described by
%offset and spread is present in the window if the wedge is projected from
%the coordinates of center. Window and center both have two entries (one
%for x and one for y).

if abs(offset-pi/2*round(offset*2/pi))<spread
    if round(offset*2/pi)==0
        rmax=min(abs([window(1)-center(1) center(2)/sin(offset+spread) (window(2)-center(2))/sin(offset-spread)]));
    elseif round(offset*2/pi)==1
        rmax=min(abs([center(2) center(1)/cos(offset+spread) (window(1)-center(1))/cos(offset-spread)]));
    elseif (round(offset*2/pi)==2)||(round(offset*2/pi)==-2)
        rmax=min(abs([center(1) center(2)/sin(offset-spread) (window(2)-center(2))/sin(offset+spread)]));
    elseif (round(offset*2/pi)==-1)||(round(offset*2/pi)==3)
        rmax=min(abs([window(2)-center(2) center(1)/cos(offset-spread) (window(1)-center(1))/cos(offset+spread)]));
    end
else
    if floor(offset*2/pi)==0
        rmax=min(abs([(window(1)-center(1))/cos(offset-spread) center(2)/sin(offset+spread)]));
    elseif floor(offset*2/pi)==1
        rmax=min(abs([center(2)/sin(offset-spread) center(1)/cos(offset+spread)]));
    elseif (floor(offset*2/pi)==2)||(floor(offset*2/pi)==-2)
        rmax=min(abs([center(1)/cos(offset-spread) (window(2)-center(2))/sin(offset+spread)]));
    elseif floor(offset*2/pi)==-1
        rmax=min(abs([(window(2)-center(2))/sin(offset-spread) (window(1)-center(1))/cos(offset+spread)]));
    end
end

rmax=floor(rmax)-5;