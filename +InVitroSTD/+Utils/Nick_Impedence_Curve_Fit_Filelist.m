function [t V faxis imp_curve Y] = Nick_Impedence_Curve_Fit_Filelist(data, SI)
addpath biophys/
I=data(:,2)';

V=data(:,1)';
avgV=mean(V);

Fs=SI*(10^-6);
Fs=1/Fs;

no_null=1;

[Z freq] = impedance(I, V, Fs, no_null);

L = size(V,2);

N = 2^nextpow2(L);

f = Fs/2*linspace(0,1,N/2+1);

imp_curve=Z(find(f>=0.5,1,'first'):find(f<=20,1,'last'));

faxis=f(find(f>=0.5,1,'first'):find(f<=20,1,'last'));


t = 1/Fs:1/Fs:length(V)/Fs;


[P,S]=polyfit(faxis,imp_curve,10);

Y=polyval(P,faxis);

[amp k]=max(Y);

fr=f(k+find(f<0.5,1,'last'));


