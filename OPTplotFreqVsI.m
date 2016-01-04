figure;
Ifull=[-I(end:-1:1);I];
oneFull=[-oneR(end:-1:1);oneN];
twoFull=[-twoR(end:-1:1);twoN];
xone = lsqcurvefit(foneN,[1,0],Ifull,oneFull);
xtwo = lsqcurvefit(ftwoN,[1,0],Ifull,twoFull);
plot(I,oneN,'b+-')
hold on;
plot(I,twoN,'+-','color',[1 .3 0]);
% line(I, twoN, 'Color', 'b', 'LineStyle','s', 'LineStyle',':',...
%          'Color', [1 .3 0], 'LineWidth',2);
plot(-I,oneR,'b+-')
% line(-I, oneR, 'Color', 'b', 'LineStyle','s', 'LineStyle',':',...
%          'Color', [0 0 1], 'LineWidth',2);
plot(-I,twoR,'+-','color',[1 .3 0]);
% line(-I, twoR, 'Color', 'b', 'LineStyle','s', 'LineStyle',':',...
%          'Color', [1 .3 0], 'LineWidth',2);
title('Resonance Values')
xlabel('Current (Amps)')
ylabel('Frequency (MHz)')

hold off;

figure;
Ifulle=[-2.4;Ifull;2.4];
plot(Ifull,oneFull,'b +-')
hold on;
plot(Ifull,twoFull,'+-','color',[1 .3 0]);
plot(Ifulle,foneN(xone,Ifulle),'k-')
plot(Ifulle,ftwoN(xtwo,Ifulle),'k-');

title('Slope Fitting Via Least Squares')
xlabel('Current (Amps)')
ylabel('Frequency (MHz)')

hold off;


%Caculate Ione and I two and B_e
N=135;
R=0.275;
m1=xone(1);
m2=xtwo(1);
Spin1=(0.5)*((2.799/m1)*(N/R)*(0.9E-2)-1)
Spin2=(0.5)*((2.799/m2)*(N/R)*(0.9E-2)-1)
B=zeros(1,2*length(oneN));
for i=1:length(oneN)
    B(i)=abs(oneN(i)-oneR(i))*(0.5)*(1/2.799)*(2*(3/2)+1);
    B(i+length(oneN))=abs(twoN(i)-twoR(i))*(0.5)*(1/2.799)*(2*(5/2)+1);
end

Field=mean(B)
error=std(B)


%  line(height, peakIntNorm, 'Color', 'b', 'LineStyle','s', 'LineStyle',':',...
%          'Color', [0 0 1], 'LineWidth',2);