function [low high peak] = get_fitting_range(qvec, sliceint10, fitdn, fitup, manchoice, peak)

go = 'n';
go2 = 'n';

figure(1); clf;
semilogy(abs(sliceint10)); 
hold off;

minwin = 3;
maxwin = 3;

% Look for full max only over first 75 pixels
Ifullmax_index = find(sliceint10 == max(sliceint10(1:75)));

if length(Ifullmax_index) > 1
    Ifullmax_index = Ifullmax_index(1) + length(Ifullmax_index);
end

[Imin_index data_pf] = findavesymmin(sliceint10, Ifullmax_index, minwin);

Imax_index = findavesymmax_st(sliceint10, Imin_index, maxwin);

if Imax_index < Imin_index
    Imin_index = floor(0.25*length(qvec));
    Imax_index = floor(0.50*length(qvec));
end

symhalf = Imax_index - Imin_index;

goleft = floor(symhalf*fitdn);
goright = floor(symhalf*fitup);

low = Imax_index - goleft;
high = Imax_index + goright;

if high > length(qvec)
    high = length(qvec);
end

if low < 1
    low = 1;
end
    
if manchoice ~= '1'

    while ~isempty(go)

    startfit = qvec(low)
    endfit = qvec(high)
    
    semilogy(qvec(low)*ones(length(sliceint10), 1), sliceint10, 'g'); hold on;
    semilogy(qvec(high)*ones(length(sliceint10), 1), sliceint10, 'r'); hold on;
    semilogy(qvec, sliceint10, 'b.'); hold on;

    go = input('FITTING RANGE: [Enter] to accept, [g] to select graphically, or [m] to specify manually > ', 's');
    disp(' ')
    
    if go == 'm'
        lefti = input('Enter beginning of fitting range [nm^-1] > ');
        disp(' ')
        righti = input('Enter end of fitting range [nm^-1] > ');
        disp(' ')
        
        % visual confirmation
        semilogy(lefti*ones(length(sliceint10),1),sliceint10); hold on;
        semilogy(righti*ones(length(sliceint10),1),sliceint10); hold off;

        l_index = find(qvec >= lefti);
        low = l_index(1);
        h_index = find(qvec <= righti);
        high = h_index(end);
        
        cont = input('Enter to continue > ', 's');
        if isempty(cont)
            go = '';
        end

    end
    
    if go == 'g'
        
        [x6 y6] = ginput(1);
        [x7 y7] = ginput(1);
        if x6 < x7
            low = x6;
            high = x7;
        else
            low = x7;
            high = x6;
        end

        % visual confirmation
        semilogy(low*ones(length(sliceint10),1),sliceint10); hold on;
        semilogy(high*ones(length(sliceint10),1),sliceint10); hold off;
        l_index = find(qvec >= low);
        low = l_index(1);
        h_index = find(qvec <= high);
        high = h_index(end);

        cont = input('Enter to continue > ', 's');
        if isempty(cont)
            go = '';
        end

    end

    end
    
    while ~isempty(go2)

    peakloc = qvec(peak);
    
    semilogy(qvec(peak)*ones(length(sliceint10), 1), sliceint10, 'k--'); hold on;
    semilogy(qvec, sliceint10, 'b.'); hold on;

    figure(gcf)
    go2 = input('PEAK LOCATION: [Enter] to accept, [g] to select graphically, or [m] to specify manually > ', 's');
    disp(' ')
    
    if go2 == 'm'
        peaki = input('Enter peak location [nm^-1] > ');
        disp(' ')
        
        % visual confirmation
        semilogy(peaki*ones(length(sliceint10),1),sliceint10,'b--'); hold on;

        p_index = find(qvec >= peaki);
        peak = p_index(1);
        
        cont = input('Enter to continue > ', 's');
        if isempty(cont)
            go2 = '';
        end
    end
    
    if go2 == 'g'
        
        [peakx peaky] = ginput(1);
        peakx

        % visual confirmation
        semilogy(peakx*ones(length(sliceint10),1),sliceint10); hold on;

        p_index = find(qvec >= peakx);
        peak = p_index(1);

        cont = input('Enter to continue > ', 's');
        if isempty(cont)
            go2 = '';
        end
    end

    end
    
end

close all;

return
