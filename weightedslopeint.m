function [ b ] = weightedslopeint(x,y,E)
%b=  1/?(???1/(?_i^2 ) ???(x_i y_i)/(?_i^2 )-??(x_i^2)/(?_i^2 ) ???y_i/(?_i^2 ))???
%first calculate delta
onesigsquare=0;
for i=1:length(E);
    onesigsquare=onesigsquare+1/(E(i)^(2));
end
xsqOsigsq=0;
for i=1:length(x);
    xsqOsigsq=xsqOsigsq+(x(i)^(2))/(E(i)^2);
end
triangle=onesigsquare*xsqOsigsq-(xsqOsigsq^(2));

xyOsigsq=0;
for i=1:length(x)
    xyOsigsq=xyOsigsq+(x(i)*y(i))/(E(i)^2);
end

yOsigsq=0;
for i=1:length(y)
    yOsigsq=yOsigsq+y(i)/(E(i)^2);
end
xOsigsq1=0;
for i=1:length(y)
    xOsigsq1=xOsigsq1+x(i)/(E(i)^2);
end
b=(1/triangle)*(onesigsquare*xyOsigsq-(xOsigsq1*yOsigsq));





end

