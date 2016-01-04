function [fitstats morefitstats] = besselfit1wc(fitq, fitI, limit, st_)

fitq = fitq(:);
fitI = fitI(:);
fo_ = fitoptions('method','NonlinearLeastSquares','Robust','on','Lower',...
    [limit.A(1) limit.D(1) limit.sD(1) limit.c(1)],...
    'Upper',[limit.A(2) limit.D(2) limit.sD(2) limit.c(2)],...
    'MaxFunEvals',5000,'MaxIter',5000);
ok_ = ~(isnan(fitq) | isnan(fitI));
set(fo_,'Startpoint',st_);
ft_ = fittype('A*intensityfitwc(x,D,sigD,c)',...
     'dependent',{'y'},'independent',{'x'},...
     'coefficients',{'A', 'D', 'sigD', 'c'});

 % Fit this model using new data
cf_ = fit(fitq(ok_),fitI(ok_),ft_,fo_);
     
[cf_ gof] = fit(fitq(ok_), fitI(ok_), ft_, fo_);

fitstats = coeffvalues(cf_);
morefitstats = gof;