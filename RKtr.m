function [ Xout] = RKtr(n,T0,Tfinal,A,h,X)
%Solve n order differential equation using Runge Kutta order 4


m=length(X);
for j=1:m
    w(j)=X(j);
end
t=[T0+h:h:Tfinal];

    
N=length(t);
k=zeros(4,m);
if A==0
    m=m-1;
    w=w(1:end-1);
    k=zeros(4,m-1);
end
for i=1:N
    for j=1:m
        if j==m
            k(1,j)=h*(1/A)*sum(w);
        else
            k(1,j)=h*w(j+1);
        end
    end
    for j=1:m
        if j==m
            k(2,j)=h*((1/A)*sum(w+0.5*k(1,:)));
        else
            k(2,j)=h*(w(j+1)+0.5*k(1,j));
        end
    end
    for j=1:m
        if j==m
            k(3,j)=h*((1/A)*sum(w+0.5*k(2,:)));
        else
            k(3,j)=h*(w(j+1)+0.5*k(2,j));
        end
    end
    for j=1:m
        if j==m
            k(4,j)=h*((1/A)*sum(w+k(3,:)));
        else
            k(4,j)=h*(w(j+1)+k(3,j));
        end
    end
    for j=1:m
        w(j)=w(j)+(1/6)*(k(1,j)+2*k(2,j)+2*k(3,j)+k(4,j));
    end
    
end
Xout=w(1);
       
end

