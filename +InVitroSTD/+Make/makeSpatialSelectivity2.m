function makeSpatialSelectivity2(baseSteps,relativeStrength,ifRandom,ifConst)

%5. Spatial selectivity protocol - random phase of pulses on sine wave.
%Have a sinewave with different peak to trough amplitudes (-100 pA to -500
%pA) at different baseline current values (100 to 300 pA at 25 pA steps).
%Superimposed on this sine wave, have synaptic pulses at random phases
%(uniform distribution) with tao1= 1-2 msec and tao2=2-6 msec.  (should
%look at data on IPSCs and EPSCs. IMPORTANT: Need both an inhibitory
%sequence AND an excitatory sequence.

% wchapman20131001

%% File parameters
sampFreq = 5000; %Sample at 5KHz
tFinal = 20; % Run for 20 seconds
t = 0:1/sampFreq:tFinal;
t = t(:);
deadSpace = zeros(4*sampFreq,1);
%% Sin parameters:
%sinFreq = [2 3 4 5 6 7 8 9 10 11 12 13 14]; % For a variety of frequencies, (put freqs in same file)%
%sinAmp = [25 50 75 150 200 250 300];
sinAmp = [50];
sinFreq = [2 4 6 8 10 12];
%% doubleExp parameters
dt = 1/sampFreq;
tau1 = .001;
tau2 = .005;

%% Make folders

folderName_inhib = ['SpatialSelectivity_5Khz_inhib' '__relativeStrength' num2str(relativeStrength)];
folderName_excit = ['SpatialSelectivity_5Khz_excit' '__relativeStrength' num2str(relativeStrength)];

if ifConst == 1
    folderName_inhib = [folderName_inhib '_Constant'];
    folderName_excit = [folderName_excit '_Constant'];
end

if ifRandom==1
   folderName_inhib = [folderName_inhib '_Random'];
   folderName_excit = [folderName_excit '_Random'];
end

mkdir(folderName_inhib)
mkdir(folderName_excit)

%% Run
%%{
poolSize = matlabpool('size');

if ~poolSize
    matlabpool open
end
%%}

parfor i = 1:length(sinAmp)
    for k = 1:length(tau1)
        for m = 1:length(tau2)
            for n = 1:length(sinFreq)
                
                tFinal = 0.4;
                [doubleExp_sig] =make.doubleExp(tFinal,dt,tau1(k),tau2(m),1); % signal to super impose
                doubleExp_sig = ((doubleExp_sig / max(doubleExp_sig))*sinAmp(i))*relativeStrength/2;
                %{
                deadSpace = zeros(sampFreq*4,1); %Give 5 seconds between
                signal = deadSpace;

                for q = 1:9
                    tFinal = 180/9; % number of seconds needed
                    numSamples = tFinal * sampFreq;
                    ts = [0;cumsum((1/sampFreq)*ones(numSamples,1))];

                    sinSig = (sinAmp(i)/2)*sin(2*pi*ts*sinFreq(n));
                    sig = make.superImposed(sinSig,doubleExp_sig,[],ifRandom,16,ifConst*1) + (q-1)*baseSteps; %Define breaks at peaks, non random

                    deadSpace = deadSpace+baseSteps;
                    signal = [signal;sig;deadSpace];
                end
                
                ts = cumsum((1/sampFreq)*ones(length(signal),1));
                ts = ts-ts(1);
                
                fname = [folderName_excit '/spatialExcit_sinAmp' num2str(sinAmp(i)) 'sinFreq' num2str(sinFreq(n)) '_tau1' num2str(tau1(k)) '_tau2' num2str(tau2(m)) '_step' num2str(baseSteps)]; 
                
                %plot(ts,signal)
                %saveas(gcf,[fname '.fig'])
                
                make.toABF(fname,ts,signal);
                %}
                
                % ---------- inhibatory --------%
                doubleExp_sig = -1*doubleExp_sig;
                
                deadSpace = zeros(4*sampFreq,1);
                signal = deadSpace;

                for q = 1:9
                    tFinal = 180/9; % number of seconds needed
                    numSamples = tFinal * sampFreq;
                    ts = [0;cumsum((1/sampFreq)*ones(numSamples,1))];

                    sinSig = (sinAmp(i)/2)*sin(2*pi*ts*sinFreq(n));
                    sig = make.superImposed(sinSig,doubleExp_sig,[],ifRandom,16,ifConst*-1) + (q-1)*baseSteps; %Define breaks at peaks, non random

                    deadSpace = deadSpace+baseSteps;
                    signal = [signal;sig;deadSpace];
                end
                
                ts = cumsum((1/sampFreq)*ones(length(signal),1));
                ts = ts-ts(1);
                
                fname = [folderName_inhib '/spatialinhib_sinAmp' num2str(sinAmp(i)) 'sinFreq' num2str(sinFreq(n)) '_tau1' num2str(tau1(k)) '_tau2' num2str(tau2(m)) '_step' num2str(baseSteps)]; 
                
                %plot(ts,signal)
                %saveas(gcf,[fname '.fig'])
                
                make.toABF(fname,ts,signal);
                
            end
        end
    end
end
                
                
                
    
    
    


    
end

