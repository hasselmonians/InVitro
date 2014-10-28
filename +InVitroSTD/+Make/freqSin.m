function [signal ts phsd] = freqSin(ifSave,ifEven,ifReverse, excitInhib,relativeMag)

if ~exist('relativeMag','var')
    relativeMag = 1;
end

%% File parameters
sampFreq = 5000;
deadSpace = zeros(4*sampFreq,1); %four seconds of deadspace
sinAmp = 50; %<--I_pp = 50pA

%% doubleExp parameters
dt = 1/sampFreq;
tau1 = .001;
tau2 = .005;


%% Make folders
folderName = '/media/RatBrains/software/Library/';

%% Run

if ifEven==1 && ifReverse==0
    fname = [folderName 'freqSin_even'];
    freqs = [2 4 6 8];

    tFinal = 0.4;
    doubleExp_sig =make.doubleExp(tFinal,dt,tau1,tau2,1); % signal to super impose
    doubleExp_sig = -1*relativeMag*((doubleExp_sig / max(doubleExp_sig))*sinAmp);

    tFinal = 40;
    numSamples = tFinal*sampFreq;
    ts = [0;cumsum((1/sampFreq)*ones(numSamples,1))];

    for i = 1:length(freqs)
        sinsig = (sinAmp/2)*sin(2*pi*ts*freqs(i));
        sig{i} = make.superImposed(sinsig,doubleExp_sig,[],0,16,0);
        phs{i} = wrapTo2Pi(2*pi*ts*freqs(i));
    end

    signal = [];
    phsd = [];
    for i = 1:length(freqs)
        signal = [signal;deadSpace;sig{i}];
        phsd = [phsd;NaN(size(deadSpace));phs{i}];
    end
    signal = [signal;deadSpace];
    phsd = [phsd;NaN(size(deadSpace))];

    ts = cumsum((1/sampFreq)*ones(length(signal),1));
    ts = ts-ts(1);

    if ifSave==1
        make.toABF(fname,ts,signal);
    end
end

%% Run reverse
if ifEven==1 && ifReverse==1
    fname = [folderName 'freqSin_even_reverse'];
    freqs = [8 6 4 2];

    tFinal = 0.4;
    doubleExp_sig =make.doubleExp(tFinal,dt,tau1,tau2,1); % signal to super impose
    doubleExp_sig = -1*((doubleExp_sig / max(doubleExp_sig))*sinAmp);

    tFinal = 40;
    numSamples = tFinal*sampFreq;
    ts = [0;cumsum((1/sampFreq)*ones(numSamples,1))];

    for i = 1:length(freqs)
        sinsig = (sinAmp/2)*sin(2*pi*ts*freqs(i));
        sig{i} = make.superImposed(sinsig,doubleExp_sig,[],0,16,0);
    end

    signal = [];
    for i = 1:length(freqs)
        signal = [signal;deadSpace;sig{i}];
    end
    signal = [signal;deadSpace];

    ts = cumsum((1/sampFreq)*ones(length(signal),1));
    ts = ts-ts(1);

    if ifSave==1
        make.toABF(fname,ts,signal);
    end
end

%% Run odd
if ifEven==0 && ifReverse==0
    fname = [folderName 'freqSin_odd'];
    freqs = [3 5 7 9];
    tFinal = 0.4;
    doubleExp_sig =make.doubleExp(tFinal,dt,tau1,tau2,1); % signal to super impose
    doubleExp_sig = -1*((doubleExp_sig / max(doubleExp_sig))*sinAmp);

    tFinal = 40;
    numSamples = tFinal*sampFreq;
    ts = [0;cumsum((1/sampFreq)*ones(numSamples,1))];

    for i = 1:length(freqs)
        sinsig = (sinAmp/2)*sin(2*pi*ts*freqs(i));
        sig{i} = make.superImposed(sinsig,doubleExp_sig,[],0,16,0);
    end

    signal = [];
    for i = 1:length(freqs)
        signal = [signal;deadSpace;sig{i}];
    end
    signal = [signal;deadSpace];

    ts = cumsum((1/sampFreq)*ones(length(signal),1));
    ts = ts-ts(1);

    if ifSave==1
        make.toABF(fname,ts,signal);
    end
end

%% Run odd reverse
if ifEven==0 && ifReverse == 0
    fname = [folderName 'freqSin_odd_reverse'];
    freqs = [9 7 5 3];

    tFinal = 0.4;
    doubleExp_sig =make.doubleExp(tFinal,dt,tau1,tau2,1); % signal to super impose
    doubleExp_sig = -1*((doubleExp_sig / max(doubleExp_sig))*sinAmp);

    tFinal = 40;
    numSamples = tFinal*sampFreq;
    ts = [0;cumsum((1/sampFreq)*ones(numSamples,1))];

    for i = 1:length(freqs)
        sinsig = (sinAmp/2)*sin(2*pi*ts*freqs(i));
        sig{i} = make.superImposed(sinsig,doubleExp_sig,[],0,16,0);
    end

    signal = [];
    for i = 1:length(freqs)
        signal = [signal;deadSpace;sig{i}];
    end
    signal = [signal;deadSpace];

    ts = cumsum((1/sampFreq)*ones(length(signal),1));
    ts = ts-ts(1);

    if ifSave==1
        make.toABF(fname,ts,signal);
    end
end
