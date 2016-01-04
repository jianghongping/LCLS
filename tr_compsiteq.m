%%%%
%obtain saxs and waxs from data file folders
%Could do same for .dat as well
saxs=dir('imagerun/*ds1*.csv*');
waxs=dir('imagerun/*ds2*.csv*');
%Take data out of imagerun and separate into SAXS OR WAXS
for i=1:length(saxs)
    Waxs{i}=importdata(strcat('imagerun/',waxs(i).name));
    Saxs{i}=importdata(strcat('imagerun/',saxs(i).name));
end

for i=1:length(Waxs)
    
    wEnd=find(Waxs{i}(:,1));
    wEnd=length(wEnd);
    sEnd=find(Saxs{i}(:,1));
    sEnd=length(sEnd);
    Waxs{i}=Waxs{i}(2:wEnd+2,1:2);
    Saxs{i}=Saxs{i}(2:sEnd+2,1:2);
end

%Gets waxs and saxs I(q),q
for i=1:length(Waxs)
    qS=Saxs{i}(:,1);
    IS=Saxs{i}(:,2);
    qW=Waxs{i}(:,1);
    IW=Waxs{i}(:,2);
    %Loglog plot throws warning when negative so we take absolute value
    figure;
    loglog(abs(qS),abs(IS),'b*')
    hold on;
    loglog(abs(qW),abs(IW),'g*')
    hold off;
    
    lx=min(qS);
    axis([lx max(qW) 0 max(max(IS),max(IW))])
%Begin conditional statement
    Done=0;
    while Done==0
    option=input('Change SAXS [s], change WAXS [w], continue [else]','s');
    %______________________________________________________________________    
    if option=='s'
    [x,y]=ginput(2);
   
    %Find points below chosen points and save only those to the left
    upb=find(Saxs{i}(:,1)<x(1));
    saxsInd=upb;
    saxsInd=saxsInd(1:end-1);
    %Increment all points by distance
    Saxs{i}=Saxs{i}(saxsInd,1:2);
    
    %HERE IS WHERE YOU MANIPULATE SAXS DATA || Dont understand how to make
    %it exact stitch (tried + and * in Loglog setting and both are
    %inexact)
    
    Saxs{i}(:,2)=Saxs{i}(:,2)+(y(2)-y(1));
    
    %Replot new stitched data
    figure;
    qW=Waxs{i}(:,1);
    IW=Waxs{i}(:,2);
    loglog(abs(Saxs{i}(saxsInd,1)),abs(Saxs{i}(saxsInd,2)),'b*')
    hold on;
    loglog(abs(qW),abs(IW),'g*')
    hold off;
    axis([lx max(qW) 0 max(Saxs{i}(saxsInd,2))])
    %______________________________________________________________________
    elseif option=='w'
    [x1,y1]=ginput(2);
    
    %Save only the values to the right of input
    wlowerb=find(Waxs{i}(:,1)>x1(1));
    waxsInd=wlowerb;
    waxsInd=waxsInd(1:end-1);
    Waxs{i}=Waxs{i}(waxsInd,1:2);
    
    %HERE IS WHERE YOU MANIPULATE WAXS DATA || Dont understand how to make
    %it exact stitch (tried + and * in Loglog setting and both are
    %inexact)
    Waxs{i}(:,2)=Waxs{i}(:,2)+(y1(2)-y1(1));
    
    qW=abs(Waxs{i}(:,1));
    IW=abs(Waxs{i}(:,2));
    %Plot new data
    loglog(Saxs{i}(saxsInd,1),Saxs{i}(saxsInd,2),'b*')
    hold on;
    loglog(qW,IW,'g*')
    hold off;
    %______________________________________________________________________
    else
        Done=1;
    end
    end

    
end
