function peak_index = tr_get_peak_index(qvec,sliceint10,minRadius,maxRadius)
%Added minimum/maxium radius in order to select peak in desired region.
minwin = 3;
maxwin = 2;
targetPeak=1.8;
lowerbound=220;
upperbound=350;
X=qvec(lowerbound:upperbound);
if size(X)~=size(sliceint10(lowerbound:upperbound))
    X=X';
p=polyfit(X,sliceint10(lowerbound:upperbound),9);
firstder=polyder(p);
secondder=polyder(firstder);
r=roots(secondder);
if isempty(r)
    Ifullmax_index=(lowerbound+upperbound)/2;
    disp('Couldnt find peak')
else
    upperInflection=r(length(find(r>targetPeak)));
    lowerlist=r(find(r<targetPeak));
    lowerInflection=lowerlist(1);
    ArithMean=(upperInflection+lowerInflection)/2;
    disp(strcat('mean value  ',num2str(ArithMean)))
    holder=find(qvec>ArithMean);
    Ifullmax_index=holder(1);
    
end
if qvec(Ifullmax_index)>1.85 || qvec(Ifullmax_index)<1.60
    disp('out of bounds')
    figure
    semilogy(qvec(Ifullmax_index)*ones(length(sliceint10), 1), sliceint10, 'k--'); hold on;
    semilogy(qvec, sliceint10, 'b.'); hold on;
    pause
   
    [peakx peaky] = ginput(1);

        % visual confirmation
    %semilogy(peakx*ones(length(sliceint10),1),sliceint10); hold on;
    close
    p_index = find(qvec >= peakx);
    Ifullmax_index = p_index(1);   
    
    
end

%Ifullmax_index = find(sliceint10 == max(sliceint10(minRadius:maxRadius)));

% if Ifullmax_index==length(sliceint10)
%     Ifullmax_index=1;
% else
%     Ifullmax_index = Ifullmax_index(1) + length(Ifullmax_index);
% end
% 
% [Imin_index, pfail] = findavesymmin(sliceint10, Ifullmax_index, minwin);
% 
% dataImax = findavesymmax_st(sliceint10, Imin_index, maxwin);

% peak_index = dataImax;
peak_index=Ifullmax_index;

end