function [peakloc] = get_peak_pos(qvec, sliceint10, peak)

go2 = 'n';
peakloc = peak;
    
while ~isempty(go2)
    
    figure
    semilogy(qvec(peakloc)*ones(length(sliceint10), 1), sliceint10, 'k--'); hold on;
    semilogy(qvec, sliceint10, 'b.'); hold on;

    go2 = input('PEAK LOCATION: [Enter] to accept, [g] to select graphically, or [m] to specify manually > ', 's');
    disp('')
    
    if go2 == 'm'
        peaki = input('Enter peak location [nm^-1] > ');
        disp(' ')
        
        % visual confirmation
        semilogy(peaki*ones(length(sliceint10),1),sliceint10,'b--'); hold on;

        p_index = find(qvec >= peaki);
        peakloc = p_index(1);
        
        cont = input('Enter to continue > ', 's');
        %if isempty(cont)
        %    go2 = '';
        %end
    end
    
    if go2 == 'g'
        
        [peakx peaky] = ginput(1);

        % visual confirmation
        semilogy(peakx*ones(length(sliceint10),1),sliceint10); hold on;

        p_index = find(qvec >= peakx);
        peakloc = p_index(1);

        cont = input('Enter to continue > ', 's');
        %if isempty(cont)
        %    go2 = '';
        %end
    end
    
    close all;

end

return
