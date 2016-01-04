function [xo,y] = lorentzianfit(azimvec)
%Estimate xo by mean of middle 24% of data.
%estimate y by half of interquartile range
X=azimvec(:,1);
Y=azimvec(:,2);
X0=[median(azimvec(:,1)),mean(azimvec(:,2))];
%plot original
figure
plot(X,Y,'ko')
hold on



%plot baseline-removed
figure
plot(X,Y,'ko')
hold on

%actual regression
lorentzian=@(F,x) 1/(pi*F(2)*(1+((x-F(1))/F(2)).^2));
F=lsqcurvefit(lorentzian,X0,X,Y);
xo=F(1);
y=F(2);


plot(X,gauss(F,X),'-r')
pause
close
close
end



