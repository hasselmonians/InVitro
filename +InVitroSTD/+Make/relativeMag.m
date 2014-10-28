function [sig ts of] = relativeMag(sinFreq,excitInhib,ifSave,sinAmp)
%{
freqs = 2:1:12;
for i=1:length(freqs)
    make.relativeMag(freqs(i),0,1);
    make.relativeMag(freqs(i),1,1);
end
%}
%% File parameters
sampFreq = 5000;%5000;
tFinal = 20;
deadSpace = zeros(4*sampFreq,1); %four seconds of deadspace
%sinAmp = 50; %<--I_pp = 50pA
%% doubleExp parameters
dt = 1/sampFreq;
tau1 = .001;
tau2 = .005;

%% Make folders

folderName = ['Library/relativeMag/' ];
if excitInhib == 0
    folderName = [folderName 'excit/' num2str(sinAmp) '/'];
else
    folderName = [folderName 'inhib/' num2str(sinAmp) '/'];
end

fname = [folderName num2str(sinFreq)];

mkdir(folderName)
%% Run
tFinal = 0.4;
doubleExp_sig =make.doubleExp(tFinal,dt,tau1,tau2,1); % signal to super impose
doubleExp_sig = ((doubleExp_sig / max(doubleExp_sig))*sinAmp);

var = 1;
if excitInhib == 1
    doubleExp_sig = -1*doubleExp_sig;
    var = -1;
end

tFinal = 180/9;
numSamples = tFinal*sampFreq;
ts = [0;cumsum((1/sampFreq)*ones(numSamples,1))];
sinSig = (sinAmp/2)*sin(2*pi*ts*sinFreq);

sig{1} = make.superImposed(sinSig,doubleExp_sig,[],0,16,0);
sig{2} = make.superImposed(sinSig,0.5*doubleExp_sig,[],0,16,0);
sig{3} = make.superImposed(sinSig,0.25*doubleExp_sig,[],0,16,0);
sig{4} = make.superImposed(sinSig,0.125*doubleExp_sig,[],0,16,0);
of = sig;

sig = [deadSpace;sig{1};deadSpace;sig{2};deadSpace;sig{3};deadSpace;sig{4}];
%sig = [sig;sig]; % Uncomment this line to make two repeats

ts = cumsum((1/sampFreq)*ones(length(sig),1));
ts = ts-ts(1);

if ifSave
    make.toABF(fname,ts,sig);
end

end