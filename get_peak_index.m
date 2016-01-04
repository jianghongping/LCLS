function peak_index = get_peak_index(sliceint10)

minwin = 3;
maxwin = 2;

Ifullmax_index = find(sliceint10 == max(sliceint10));

if Ifullmax_index==length(sliceint10)
    Ifullmax_index=1;
else
    Ifullmax_index = Ifullmax_index(1) + length(Ifullmax_index);
end

[Imin_index, pfail] = findavesymmin(sliceint10, Ifullmax_index, minwin);

dataImax = findavesymmax_st(sliceint10, Imin_index, maxwin);

peak_index = dataImax;

end