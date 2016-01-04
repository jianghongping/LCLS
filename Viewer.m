function [] = Viewer(saxsi,dark,k)
%
xc=889;
yc=904;
offset_theta(k)=0;
thetamax =0.174532925199433;
thetamin =-0.174532925199433;
SDD=2043;
pix = 0.109920000000000;
thetasteps =50;

        figure
        imagesc(saxsi(k).raw)
        set(gca,'DataAspectRatio',[1,1,1])
        title('raw')
        hold on
        subtracted=saxsi(k).raw-dark;
        figure
        imagesc(subtracted)
        set(gca,'DataAspectRatio',[1,1,1])
        title('Dark Subtracted')
        hold on
        transmission=0.419446214106067;
        pulseEnergy=saxsi(k).energy;
        %NORMALIZING image by pulse energy * transmission.
%         normalized=subtracted/(transmission*pulseEnergy);
%         figure
%         imagesc(normalized)
%         set(gca,'DataAspectRatio',[1,1,1])
%         title('Normalized')
%         hold on
    lowerPeakBound=230;
    upperPeakBound=480;
   
    %offset_theta(k)=5*0.628;    
    rmax=find_rmax_v2([size(saxsi(k).images,2),size(saxsi(k).images,1)],[xc,yc],offset_theta(k)+(thetamax+thetamin)/2,(thetamax-thetamin)/2);
    [qvec, sliceint10, darclengths, gaps]=tr_wedge_lineout_masked_strict(subtracted,saxsi(k).energy,SDD,pix, [xc, yc], thetamin,...
        thetamax, thetasteps, rmax, offset_theta(k));
    
    
    J=1;
    while (gaps(J+1)-gaps(J))==1 && J < length(gaps)-1 %Tom Riis: added j<len(gaps)
        beamstop_edge_index(k)=J;
        J=J+1;
    end

    %sliceint10 = sum(sliceforint',1)';
    %Tom Riis: changed get_peak_index to search outside min radius
    
    raz(k) = tr_get_peak_index(sliceint10,lowerPeakBound,upperPeakBound)+beamstop_edge_index(k);



 
disp(' ');

    
    

   
    
    rmax=find_rmax_v2([size(saxsi(k).images,2),size(saxsi(k).images,1)],[xc,yc],offset_theta(k)+(thetamin+thetamax)/2,(thetamax-thetamin)/2);
    [qvec, sliceint10, darclengths, gaps]=tr_wedge_lineout_masked_strict(subtracted,saxsi(k).energy,SDD,pix, [xc, yc], thetamin,...
        thetamax, thetasteps, rmax, offset_theta(k));
    
    J=1;
    while (gaps(J+1)-gaps(J))==1 & J < length(gaps)-1 %Tom Riis: added j<len(gaps)
        beamstop_edge_index(k)=J;
        J=J+1;
    end

    %sliceint10 = sum(sliceforint',1)';
    raz(k) = tr_get_peak_index(sliceint10,lowerPeakBound,upperPeakBound)+beamstop_edge_index(k);



    humpqs(k) = qvec(floor(raz(k)-beamstop_edge_index(k))); %Tom Riis: getting rid of -beam_sto_pedge for raz(k)
    ivsq(k).data = [qvec', sliceint10];
    
    figure
    semilogy(qvec, sliceint10, 'b.'); hold on;
   
    end

