function [qvec,IntI,darc,gaps]=tr_wedge_lineout_masked_strict(image,energy,SDD,pix,center,thetamin,thetamax,thetasteps,rmax,offset)

[I,darc]=rectslice_masked_strict(image,center(1),center(2),thetamin,thetamax,thetasteps,rmax,offset);

%For the sake of clarifying everything: q_parallel=4*pi*E*conv(eV->J)/(h*c)*sin(0.5*2theta)/conv(m->A)
qvec=4*pi*energy*1.602*10^-19/(6.63*10^-34)/(3*10^8)*sin(0.5*atan((1:rmax)*pix/SDD))/10^10; %Tom Riis: now in inverse angstroms

J=1;
IntI=zeros(length(I),1);
for i=1:rmax
    IntI(i)=mean(I(i,find(I(i,:))));
    if isnan(IntI(i))
        IntI(i)=0;
        gaps(J)=i;
        J=J+1;
    end
end
qlist=find(IntI);
qvec=qvec(qlist);
IntI=IntI(qlist);

end