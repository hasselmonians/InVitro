function makeSpatialSelectivity()

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
sinFreq = [2 4 6 8 10 12 16 20]; % For a variety of frequencies, (put freqs in same file)
sinAmp = 25:25:500;

deadSpace = zeros(sampFreq*5,1); %Give 5 seconds between

%% doubleExp parameters
dt = 1/sampFreq;
tau1 = (1:.1:2)*1E-3;
tau2 = (2:.2:6)*1E-3;
factor = (100:50:600);%*1E-3;

%% Run
folderName_inhib = ['Library' filesep 'SpatialSelectivity_5Khz_inhib_sweep'];
mkdir(folderName_inhib)

folderName_excit = ['Library' filesep 'SpatialSelectivity_5Khz_excit_sweep'];
mkdir(folderName_excit)
%%{
poolSize = matlabpool('size');

if ~poolSize
    matlabpool open
end
%%}

parfor i = 2:length(sinAmp)
    for k = 1:length(tau1)
        for m = 1:length(tau2)
            for n = 1:length(factor)
                
                tFinal = 0.4;
                [doubleExp_sig] =doubleExp(tFinal,dt,tau1(k),tau2(m),factor(n)); % signal to super impose

                signal = deadSpace;
                % Make 32 passes of each sin frequency
                for q = 1:length(sinFreq)
                    tFinal = (1/sinFreq(q)) * 32; % number of seconds needed
                    numSamples = tFinal * sampFreq;
                    ts = [0;cumsum((1/sampFreq)*ones(numSamples,1))];

                    sinSig =  -((sinAmp(i)/2)*sin(2*pi*ts*sinFreq(q)-pi/2)) - sinAmp(i)/2;
                    sig = superImposed(sinSig,doubleExp_sig,[],0); %Define breaks at peaks, non random

                    signal = [signal;sig;deadSpace];
                end
                
                ts = cumsum((1/sampFreq)*ones(length(signal),1));
                ts = ts-ts(1);
                
                fname = [folderName_excit '/spatialSweepExcit_sinAmp' num2str(sinAmp(i)) '_tau1' num2str(tau1(k)) '_tau2' num2str(tau2(m)) '_factor' num2str(factor(n))]; 
                
                toABF(fname,ts,signal);
                
                % ---------- inhibatory --------%
                doublExp_sig = -1*doubleExp_sig;
                
                 signal = deadSpace;
                % Make 32 passes of each sin frequency
                for q = 1:length(sinFreq)
                    tFinal = (1/sinFreq(q)) * 32; % number of seconds needed
                    numSamples = tFinal * sampFreq;
                    ts = [0;cumsum((1/sampFreq)*ones(numSamples,1))];

                    sinSig =  -((sinAmp(i)/2)*sin(2*pi*ts*sinFreq(q)-pi/2)) - sinAmp(i)/2;
                    sig = superImposed(sinSig,doubleExp_sig,[],0); %Define breaks at peaks, non random

                    signal = [signal;sig;deadSpace];
                end
                
                ts = cumsum((1/sampFreq)*ones(length(signal),1));
                ts = ts-ts(1);
                
                fname = [folderName_excit '/spatialSweepInhib_sinAmp' num2str(sinAmp(i)) '_tau1' num2str(tau1(k)) '_tau2' num2str(tau2(m)) '_factor' num2str(factor(n))]; 
                
                toABF(fname,ts,signal);
                
                
            end
        end
    end
end
                
                
                
    
    
    


    
end

