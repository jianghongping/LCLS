function [A,m,s]=gaussfit(X0,X,Y,LB,UB,autoback)
%gaussfit returns the scaling coefficient, mean, and standard deviation of
%a gaussian distribution which best fits the data X,Y. X0 should have 3
%entries corresponding in the same order to the output parameters.  X and Y
%should be the same size. LB and UB are each a 1x3 matrix with the lower
%and upper bounds on the parameters A, m, and s.

%plot original
figure
plot(X,Y,'ko')
hold on

%remove baseline from Y
if strcmp(autoback,'l') %automatic line joining beginning and end of plot
    M=(mean(Y((length(Y)-2):length(Y)))-mean(Y(1:3)))/(X(end-1)-X(2));
    b=mean(Y(1:3))-M*X(2);
    plot(X,M*X+b,'-r')
    Y=Y-M*X-b;
elseif strcmp(autoback,'f') %automatic constant background (minimum)
    Y=Y-min(Y);
elseif strcmp(autoback,'ml')    %manual linear background
    badback=1;
    while badback
        hold off
        plot(X,Y,'ko')
        hold on
        commandwindow
        disp('Please select two ranges as background')
        [x,~]=ginput(4);
        x11=find(X<x(1),1,'last');
        x12=find(X<x(2),1,'last');
        x21=find(X<x(3),1,'last');
        x22=find(X<x(4),1,'last');
        M=(mean(Y(x21:x22))-mean(Y(x11:x12)))/(mean(X(x21:x22))-mean(X(x11:x12)));
        b=mean(Y(x11:x12))-M*mean(X(x11:x12));
        plot(X,M*X+b,'-r')
        badback=~input('Are you satisfied with the background approximation? > ');
    end
    Y=Y-M*X-b;
end

%plot baseline-removed
figure
plot(X,Y,'ko')
hold on

%actual regression
gauss=@(F,x) F(1)*exp(-((x-F(2))/sqrt(2)/F(3)).^2);
F=lsqcurvefit(gauss,X0,X,Y,LB,UB,optimset('maxfunevals',10000,'MaxIter',10000));
A=F(1);
m=F(2);
s=F(3);

plot(X,gauss(F,X),'-r')
pause
close
close
end