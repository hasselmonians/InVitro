function signal = makeSpatialSelectivity_eval(baseSteps,relativeStrength,ifRandom,ifConst,sinFreq,sinAmp,excitInhib,t,baseSteps)
% Recreate the original input signal based on parameters

%% File parameters
sampFreq = 1/(t(2) - t(1));
deadSpace = zeros(4*sampFreq,1);


%% doubleExp
dt = 1/sampFreq;
tau1 = .001;
tau2 = .005;

tFinal = 0.4; % how long to run the double exponential
[doubleExp_sig] =doubleExp(tFinal,dt,tau1,tau2,1); % signal to super impose
doubleExp_sig = ((doubleExp_sig / max(doubleExp_sig))*sinAmp)*relativeStrength;

if excitInhib
    doubleExp_sig = -1*doubleExp_sig;
end

                
deadSpace = zeros(sampFreq*5,1); %Give 5 seconds between
signal = deadSpace;

for q = 1:9
    tFinal = 180/9; % number of seconds needed
    numSamples = tFinal * sampFreq;
    ts = [0;cumsum((1/sampFreq)*ones(numSamples,1))];

    sinSig = (sinAmp(i)/2)*sin(2*pi*ts*sinFreq(n));
    
    if ~excitInhib
        sig = superImposed(sinSig,doubleExp_sig,[],ifRandom,16,ifConst*1) + (q-1)*baseSteps; %Define breaks at peaks, non random
    else
        sig = superImposed(sinSig,doubleExp_sig,[],ifRandom,16,ifConst*-1) + (q-1)*baseSteps; %Define breaks at peaks, non random
    end

    deadSpace = deadSpace+baseSteps;
    signal = [signal;sig;deadSpace];
end
    
end

