function [manual_start low high] = get_startpos(qvec, sliceint10)

go = 'n';

while ~isempty(go)

    figure(1); clf;
    semilogy(qvec, sliceint10); hold off;

    warning off all;
    
    x1 = find(sliceint10 == max(sliceint10));
    x1 = ceil(x1) + 33;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [dataImin data_pf] = findavemin(sliceint10, x1, 5);
    dataImax = findavemax(sliceint10, (dataImin + 10), 20);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    symhalf = dataImax - dataImin;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    goleft = floor(symhalf * (1 / 3));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    low = dataImin + goleft;

    % low = dataImax
    if dataImax > 400
        high = 400;
    else
        high = dataImax + 100;
    end

    figure(1); clf;
%     semilogy(qvec(x1)*ones(length(sliceint10),1),sliceint10,'r'); hold on;
    semilogy(qvec(low)*ones(length(sliceint10), 1), sliceint10, 'g'); hold on;
    semilogy(qvec(high)*ones(length(sliceint10), 1), sliceint10, 'g'); hold on;
    semilogy(qvec, sliceint10, 'Color', 'b'); hold on;
    xlabel('q [nm^{-1}');
    ylabel('Intensity [a.u.]');

    go = input('Enter to continue or anything else to do it again [Enter/*/m] > ', 's');
%     go = '';
    
    if go == 'm'
        
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

manual_start = x1;
close all;

return
