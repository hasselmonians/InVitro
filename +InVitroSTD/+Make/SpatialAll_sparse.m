function  [sig ts sig_normal sig_normalized sig_halfMag sig_random] = SpatialAll_sparse(sinFreq,excitInhib,ifSave)
%{
matlabpool open
freqs = 2:1:12;
parfor i=1:length(freqs)
    make.SpatialAll_sparse(freqs(i),0,1);
    make.SpatialAll_sparse(freqs(i),1,1);
end
%}
%% File parameters
sampFreq = 5000;%5000;
tFinal = 20;
deadSpace = zeros(4*sampFreq,1); %four seconds of deadspace
sinAmp = 50; %<--I_pp = 50pA
%% doubleExp parameters
dt = 1/sampFreq;
tau1 = .001;
tau2 = .005;

%% Make folders

if ifSave==1
    folderName = [dropboxPath '/Bill/Projects/Library/SpatialAll_sparse/' ];
    if excitInhib == 0
        folderName = [folderName 'excit/'];
    else
        folderName = [folderName 'inhib/'];
    end

    fname = [folderName num2str(sinFreq)];

    mkdir(folderName)
end
%% Run
tFinal = 0.4;
doubleExp_sig =make.doubleExp(tFinal,dt,tau1,tau2,1); % signal to super impose
doubleExp_sig = ((doubleExp_sig / max(doubleExp_sig))*sinAmp);

var = 1;
if excitInhib == 1
    doubleExp_sig = -1*doubleExp_sig;
    var = -1;
end

tFinal = 180/9/5;
numSamples = tFinal*sampFreq;
ts = [0;cumsum((1/sampFreq)*ones(numSamples,1))];
sinSig = (sinAmp/2)*sin(2*pi*ts*sinFreq);

sig_normal = make.superImposed_sparse(sinSig,doubleExp_sig,[],0,16,0);
sig_normalized = make.superImposed_sparse(sinSig,doubleExp_sig,[],0,16,var);
sig_halfMag = make.superImposed_sparse(sinSig,0.5*doubleExp_sig,[],0,16,0);
sig_random = make.superImposed_sparse(sinSig,2*doubleExp_sig,[],1,16,0);

sig = [deadSpace;sig_normal;deadSpace;sig_normalized;deadSpace;sig_halfMag;deadSpace;sig_random];
sig = [sig;sig];

ts = cumsum((1/sampFreq)*ones(length(sig),1));
ts = ts-ts(1);

if ifSave
    make.toABF(fname,ts,sig);
end

end