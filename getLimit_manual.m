function [low high] = getLimit_manual(qvec, sliceint10)

cont = 'n';

while cont == 'n'
    %     figure(1); hold on;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [dataImin data_pf] = findavemin(sliceint10, 160, 5);
    dataImax = findavemax(sliceint10, (dataImin + 10), 20);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % data_.min = qvec(dataImin);
    % data_.max = qvec(dataImax);
    % data_;

    symhalf = dataImax - dataImin;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    goleft = floor(symhalf * (1 / 3));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    default_low = dataImin + goleft;

    % low = dataImax
    if dataImax > 400
        default_high = 400;
    else
        default_high = dataImax + 100;
    end

    semilogy(qvec(default_low)*ones(length(sliceint10),1),sliceint10, 'g'); hold on;
    semilogy(qvec(default_high)*ones(length(sliceint10),1),sliceint10, 'g'); hold on;
    semilogy(qvec, sliceint10, 'Color', 'r'); hold on;

    [x1 y1] = ginput(1);
    [x2 y2] = ginput(1);
    if x1 < x2
        low = x1;
        high = x2;
    else
        low = y2;
        high = y1;
    end

    % visual confirmation

    semilogy(low*ones(length(sliceint10),1),sliceint10); hold on;
    semilogy(high*ones(length(sliceint10),1),sliceint10); hold off;
    cont = input('continue? [y/n] > ', 's');
    close all;

end

l_index = find(qvec >= low);
low = l_index(1);
h_index = find(qvec <= high);
high = h_index(end);

