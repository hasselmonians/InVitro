function [t, V, faxis, imp_curve, Y] = Chirp(Recording, ifPlot)

I=Recording.I{1}';

V=Recording.V{1}';

avgV=mean(V);

Fs=(Recording.ts{1}(2)-Recording.ts{1}(1));%*(10^-6);
Fs=1/Fs;

no_null=1;

[Z freq] = InVitroSTD.Biophys.impedance(I, V, Fs, no_null);

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

[Q F M E] = InVitroSTD.Biophys.zap_Q(imp_curve,faxis);

if ~exist('ifPlot','var')
    ifPlot = 1;
end

if ifPlot==1
    plot(faxis,imp_curve)
    hold on
    plot(faxis,Y,'r','LineWidth',2)
    xlabel('Frequency (Hz)')
    ylabel('Impedence')
    title(['Q=' num2str(Q)])
end