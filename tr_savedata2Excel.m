function [] = tr_savedata2Excel(sampprefix,Ivsq,storeaz,herm,hermfit,offset_theta,ScatI,peakI,humpqs,saxsi,imagelist,imagenum)
%Take in and/or compute I(q),q,I(phi),I(phi) fitted curve,phi values,
%hermans of raw data, hermans of fitted data, total scattering intensity,
%normalized peack intenstiy, corresponding pulse energy 
%
%For each image, make and excell sheet tabulating these values and place it
%int the output folder with corresponding label

mkdir('output','ExcelFiles')
mkdir('output','TextFiles')
height=[saxsi.y]-saxsi(end).y;


for k=1:imagenum
    hvParameters={height(k),herm(k),hermfit(k),offset_theta(k),ScatI(k),peakI(k),humpqs(k),saxsi(k).energy};
    datalist={Ivsq(k).dataNoNorm(:,1),Ivsq(k).dataNoNorm(:,2),storeaz(k).theta,storeaz(k).laz,storeaz(k).lazfit,herm(k),hermfit(k),ScatI(k),peakI(k),saxsi(k).energy};
    max=0;
    for i=1:length(datalist)
        if length(datalist{i})>max
            max=length(datalist{i});
        end
    end
    datamat=[];
    for i=1:length(datalist)
        zeroList=zeros(max+100,1);
        zeroList(2:length(datalist{i})+1,1)=datalist{i};
        datamat(:,i)=zeroList;
    end
    [token,remainder]=strtok(imagelist(k).name,'.');
    [s]=xlswrite(strcat('output/ExcelFiles/',token,'A_data.xls'),datamat);
    fileID = fopen(strcat('output/TextFiles/',token,'A.txt'),'w+');
    fprintf(fileID,'%12s %12s %12s %12s %12s %12s %12s %12s %12s %12s\n','q [A^-1]','I(q)','offset phi','I(phi)','I(phi) Fit','hermans','Fit Hermans','ScatteringI','PeakIntensity','PulseEnergy');
    fprintf(fileID,'%6.6e %6.6e %6.6e %6.6e %6.6e %6.6e %6.6e %6.6e %6.6e %6.6e\n',datamat.');
    fclose(fileID);
    %%%Get hermans, Scattering Intensity, Peak Intensity and pulse energy
    %%%for each height.
    for i =1:length(hvParameters)
            HvParamMat(k,i)=hvParameters{i};
    end
end  
    txtfilename = strcat(sampprefix,'hermdata.txt');
    fileID = fopen(txtfilename,'w+');
    fprintf(fileID,'%12s %12s %12s %12s %12s %12s %12s %12s\n','Height','Hermans','Hermans Fit','offsettheta','ScatteringI','Peak Intensity','Peak Location','Pulse Energy');
    fprintf(fileID,'%6.6e %6.6e %6.6e %6.6e %6.6e %6.6e %6.6e %6.6e\n',HvParamMat.');
    fclose(fileID);
    [s]=xlswrite(strcat('output/','hermdata.xls'),HvParamMat);
end


