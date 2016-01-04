function [low high] = getLimit(qvec, sliceint10)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[dataImin data_pf] = findavemin(sliceint10, 160, 5);
dataImax = findavemax(sliceint10, (dataImin + 10), 20);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_.min = qvec(dataImin);
data_.max = qvec(dataImax);
data_;

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

return