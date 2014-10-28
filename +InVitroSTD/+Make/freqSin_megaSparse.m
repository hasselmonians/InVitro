function [signal ts] = freqSin_megaSparse(ifSave,ifEven,ifReverse, excitInhib)

%{
for i = 0:1
    for k = 0:1
        make.freqSin_megaSparse(1,i,k,1);
    end
end

%}


%% File parameters
sampFreq = 5000;
deadSpace = zeros(6*sampFreq,1); %four seconds of deadspace
sinAmp = 50; %<--I_pp = 50pA

%% doubleExp parameters
dt = 1/sampFreq;
tau1 = .001;
tau2 = .005;


%% Make folders
folderName = 'Library/freqSin_megaSparse/';
mkdir(folderName)
%% Run

if ifEven==1 && ifReverse==0
    fname = [folderName 'freqSin_even'];
    freqs = [2 4 6 8];

    tFinal = 0.4;
    doubleExp_sig =make.doubleExp(tFinal,dt,tau1,tau2,1); % signal to super impose
    doubleExp_sig = -1*((doubleExp_sig / max(doubleExp_sig))*sinAmp);

    tFinal = 40;
    numSamples = tFinal*sampFreq;
    ts = [0;cumsum((1/sampFreq)*ones(numSamples,1))];

    for i = 1:length(freqs)
        sinsig = (sinAmp/2)*sin(2*pi*ts*freqs(i));
        sig{i} = make.superImposed_megaSparse(sinsig,doubleExp_sig,[],0,16,0);
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
        sig{i} = make.superImposed_megaSparse(sinsig,doubleExp_sig,[],0,16,0);
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
        sig{i} = make.superImposed_megaSparse(sinsig,doubleExp_sig,[],0,16,0);
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
if ifEven==0 && ifReverse == 1
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
        sig{i} = make.superImposed_megaSparse(sinsig,doubleExp_sig,[],0,16,0);
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
