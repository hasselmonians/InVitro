function [Z, f] = impedance2(V, I, Fs)

[X, f] = fftMag(I, Fs);
[Y, f] = fftMag(V, Fs);
Z = Y ./ X;

function [F, f] = fftMag(X, Fs)

L = length(X);
N = 2^nextpow2(L);
f = Fs/2*linspace(0,1,N/2+1);

X = X - mean(X);
y = fft(X,N) / L;
F = 2*abs(y(1:N/2+1));

end

end