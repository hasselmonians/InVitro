function [sig, ts] = nested(lowFreq,lowMag,highMag, ifSave)

sampFreq = 5000; %Sample at 5KHz
deadSpace = zeros(4*sampFreq,1);

highFreqs = [4 5 6 7 8];

ts = 0:(1/sampFreq):35;
ts = ts(:);

lowSig = lowMag*sin(lowFreq*2*pi*ts);

sig = deadSpace;
for i = 1:length(highFreqs)
    highSig = highMag*sin(highFreqs(i)*2*pi*ts);
    sig = [sig;lowSig+highSig;deadSpace(:)];
end

ts = (1/sampFreq)*(cumsum(ones(size(sig)))-1);


if ifSave == 1
    fname=['lf' num2str(lowFreq) '_' 'lm' num2str(lowMag) '_' 'hm' num2str(highMag)];
    fld = ['/media/wchapman/RatBrains/Library' filesep 'nested'];
    
    mkdir(fld);
    
    make.toABF([fld filesep fname],ts,sig);
end

%{
od = pwd;
addpath(od);
cd /media/RatBrains/Dropbox' (Hasselmonians)'/yusuke/Data/HeadDirection/
[d, ts] = make.abfload('2014_06_13_0004_baseline_adjusted1.abf');
v = d(:,1);
cd(od);


T = (ts*1e-6);                     % Sample time
Fs = 1/T;                     % Sampling frequency
L = length(v);                     % Length of signal
%t = (0:L-1)*T;                % Time vector


NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(d,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

%yy = smooth(2*abs(Y(1:NFFT/2+1)),50);
% Plot single-sided amplitude spectrum.
yy = smooth(2*abs(Y(1:20000)),500);
plot(f(1:length(yy)),yy) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
xlim([0 60])


%ratio = .082/.02645; % about 3

%---------------------------------------------------------------------
lowFreq = .2:.1:1;
lowMag = 10:20:200;
highMag = 10:10:200;
parfor i = 1:length(lowFreq)
    for k = 1:length(lowMag)
        for m = 1:length(highMag)
            make.nested(lowFreq(i),lowMag(k),highMag(k),1);
        end
    end
end
%}

end