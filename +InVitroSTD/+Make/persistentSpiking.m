function [sig ts] = persistentSpiking(frequency,depolStrength,saveABF)

%{
matlabpool open
freqs = 1:1:12;
depols = -100:10:50;
parfor i = 1:length(freqs)
    for k = 1:length(depols)
        make.persistentSpiking(freqs(i),depols(k),1);
    end
end
%}
%% File parameters
sampFreq = 5000; %Sample at 5KHz
deadSpace = zeros(4*sampFreq,1);


%% run
sig = [];
% deadspace 4 seconds
t = 0:1/sampFreq:4;
x = zeros(size(t));
sig = [sig;x(:)];

% sinusoid 10 seconds
t = 0:1/sampFreq:10;
x = 25*sin(2*pi*t*frequency);
sig = [sig;x(:)];

% deadspace 10 seconds
t = 0:1/sampFreq:10;
x = zeros(size(t));
sig = [sig;x(:)];

% depol 10 seconds
t = 0:1/sampFreq:10;
x = depolStrength * ones(size(t));
sig = [sig;x(:)];
    
% deadspace 10 seconds
t = 0:1/sampFreq:10;
x = zeros(size(t));
sig = [sig;x(:)];

ts = (1/sampFreq)*(cumsum(ones(size(sig)))-1);
%% save?
if ~exist('saveABF','var'), saveABF = 0;end

if saveABF ==1
    mkdir(['Library/persistentSpiking'])
    fname = ['Library/persistentSpiking/' num2str(frequency) 'Hz_' num2str(depolStrength) 'mV'];
    make.toABF(fname,ts,sig);
end

end