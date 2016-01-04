function display_offset_redo(simage, imagename, xLine, xc, yc, offset_theta, azv1, azv2, focus)

close all;
figure
subplot(1,2,1)
imagesc(simage);
set(gca,'DataAspectRatio',[1,1,1])
hold on;
title(imagename);

% for plotting, invert offset theta

tanoffth = tan(offset_theta);
if offset_theta == 0
    tanoffth = 1e-3;
elseif offset_theta==pi/2
    tanoffth = 1e12;
end

xxvals = 1:1:size(simage,2);
xyvals = yc - (xxvals - xc)*tanoffth;
plot(xxvals,xyvals,'k-');

yxvals = 1:1:size(simage,1);
yyvals = yc - (xc - xxvals)/tanoffth;
plot(yxvals,yyvals,'k-');

% axis([0 1024 0 1024]);    %For image of size=[1024,1024]

subplot(1,2,2)
hold on
% polar(azv(:,1),azv(:,2));
plot(azv1(:,1)*180/pi,azv1(:,2),'b.');
plot(azv2(:,1)*180/pi-180,azv2(:,2),'r.');
legend('quadrant 1','quadrant 2');

minya = 0;
maxya = 1.1*abs(max(max(azv1(:,2)),max(azv2(:,2))));
offd = rad2deg(offset_theta);
%ydiff = (maxya - minya)/100;

%xoffL = offd*ones(1,101);
%yoffL = minya:ydiff:maxya;

plot([offd offd],[minya maxya],'k-','LineWidth',2)

% axis([-30 30 minya maxya]);
% set(gca,'XTick',[-30 0 30 60 90 120 150 180 210])

grid on
findfigs

end