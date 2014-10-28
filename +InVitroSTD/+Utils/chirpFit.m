function [faxis Y]= chirpFit(I,V,Fs)
    addpath biophys
    
    warning('off','MATLAB:colon:nonIntegerIndex')
    
    [Z freq] = impedance(I, V, Fs, 1);
    L = size(V,2);
    N = 2^nextpow2(L);
    f = Fs/2*linspace(0,1,N/2+1);
    imp_curve=Z(find(f>=0.5,1,'first'):find(f<=20,1,'last'));
    faxis=f(find(f>=0.5,1,'first'):find(f<=20,1,'last'));
    xlim([0.5 20])
    [P,S]=polyfit(faxis,imp_curve,10);
    Y=polyval(P,faxis);
    [amp k]=max(Y);
    fr=f(k+find(f<0.5,1,'last'));


end