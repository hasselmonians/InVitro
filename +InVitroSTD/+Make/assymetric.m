function [signal ts] = assymetric(freq,ifSave)

%{
parfor freq = 1:8
    make.assymetric(freq,1);
end
%}
%% File parameters
sampFreq = 5000;
deadSpace = zeros(4*sampFreq,1); %four seconds of deadspace
sinAmp = 50; %<--I_pp = 50pA

%% doubleExp parameters
dt = 1/sampFreq;
tau1 = .001;
tau2 = .005;


%% Make folders
folderName = '/media/RatBrains/software/Library/assymetric';

%% Run
fname = [folderName '/assymetric_' num2str(freq)];

ratios = [1/5 1/4 1/3 1/2 1 2 3 4 5];

tFinal = 0.4;
doubleExp_sig =make.doubleExp(tFinal,dt,tau1,tau2,1); % signal to super impose
doubleExp_sig = -1*((doubleExp_sig / max(doubleExp_sig))*sinAmp);

tFinal = 17;
numSamples = tFinal*sampFreq;
ts = [0;cumsum((1/sampFreq)*ones(numSamples,1))];

for i = 1:length(ratios)
    sinsig = (sinAmp/2)*make.assymetricSinusoid(2*pi*ts*freq,ratios(i));
    sig{i} = make.superImposed(sinsig,doubleExp_sig,[],0,16,0);
end

signal = [];
for i = 1:length(ratios)
    signal = [signal;deadSpace;sig{i}];
end
signal = [signal;deadSpace];

ts = cumsum((1/sampFreq)*ones(length(signal),1));
ts = ts-ts(1);

if ifSave==1
    make.toABF(fname,ts,signal);
end
