function [peakloc] = tr_get_peak_pos(qvec, sliceint10, peak)

go2 = 'n';
peakloc = peak;

if qvec(peak)>1.85 || qvec(peak)<1.60
    figure
    semilogy(qvec(peak)*ones(length(sliceint10), 1), sliceint10, 'k--'); hold on;
    semilogy(qvec, sliceint10, 'b.'); hold on;
    pause
    close
    go2 =input('PEAK LOCATION: [Enter] to accept, [g] to select graphically, or [m] to specify manually > ', 's');
end
count=1;
while ~isempty(go2) && count==0
%     
      figure
      semilogy(qvec(peak)*ones(length(sliceint10), 1), sliceint10, 'k--'); hold on;
      semilogy(qvec, sliceint10, 'b.'); hold on;
      pause
      close

    
    disp('')
    
    if go2 == 'm'
        peaki = 1.8;%input('Enter peak location [A^-1] > '); %Tom Riis: changed to angstroms
        disp(' ')
        
        % visual confirmation
        %semilogy(peaki*ones(length(sliceint10),1),sliceint10,'b--'); hold on;

        p_index = find(qvec >= peaki);
        peakloc = p_index(1);
        count=1;
        %cont = input('Enter to continue > ', 's');
        %if isempty(cont)
        %    go2 = '';
        %end
   
    
    elseif go2 == 'g'
        
        [peakx peaky] = ginput(1);

        % visual confirmation
        semilogy(peakx*ones(length(sliceint10),1),sliceint10); hold on;

        p_index = find(qvec >= peakx);
        peakloc = p_index(1);   
        count=1;
        %if isempty(cont)
        %    go2 = '';
        %end
    else
        count=1;
        break
    end
    %close all;

end

end
