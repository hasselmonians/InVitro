function [pow] = timeFrequency_dB_normalized(data,Fs,low,high)
%timeFrequency() performs a time frequency decomposition from 2-12 Hz with no
%normalization on a data set stored as a vector.  Outputs a matrix of power
%values where row refers to frequency and column is time.  Requires
%sampling frequency and low/high bounds for frequency band of interest
%
%Example call:
%      >> power = timeFrequency(vector,1000,30,90);
%
%Craig Kelley, Yale School of Medicine, Translation Neuropharmacology

% freq = low:.1:high;
freq = low:high;
pow = zeros(length(freq),length(data));
for i = 1:length(freq)
    vec = eegfilt(data,Fs,freq(i)-1,freq(i)+1);
    Hvec = hilbert(vec);
    pow(i,:) = abs(Hvec).^2;
    pow(i,:) = 10*log10(pow(i,:) ./ mean(pow(i,1:1000)));
end