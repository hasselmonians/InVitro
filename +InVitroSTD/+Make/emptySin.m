function [signal ts] = emptySin(ifSave)

%% File parameters
sampFreq = 5000;
deadSpace = zeros(2*sampFreq,1); %four seconds of deadspace
sinAmp = 50; %<--I_pp = 50pA
freqs = 2:1:12;

%% Make folders
folderName = '/media/RatBrains/software/Library/';
mkdir(folderName) 
fname = [folderName 'emptySin'];

%% Run
tFinal = 15;
numSamples = tFinal*sampFreq;
ts = [0;cumsum((1/sampFreq)*ones(numSamples,1))];

for i = 1:length(freqs)
    sinSig{i} = (sinAmp/2)*sin(2*pi*ts*freqs(i));
end

signal = [];
for i = 1:11
    signal = [signal;deadSpace;sinSig{i}];
end
signal = [signal;deadSpace];

ts = cumsum((1/sampFreq)*ones(length(signal),1));
ts = ts-ts(1);

if ifSave==1
    make.toABF(fname,ts,signal);
end
