function makeSquareSequence()
%3. Short square wave pulse durations of 10 msec, 20 msec, 30 msec, 40
% msec, 50 msec (with 2 seconds between each) then pulse durations of 62.5
% msec duration, 125 msec, 250 msec and 500 msec.  Probably need a range of
% baseline currents from 100 to 300 pA at 25 pA steps to bring from resting
% up across firing threshold.  Also, need range of injection amplitudes from
% about -0 to -500 pA).

% wchapman 20131002

squareMagnitude = 0:25:500;
baselineCurrent = 0:25:300;
durations = [10:10:50 62.5 125 250 500]*1E-3; %Durations in ms

fs = 20000;

for i = 1:length(durations)
    square{i} = -1*ones(durations(i)*fs,1);
end

deadSpace = zeros(2*fs,1);

signal = [deadSpace];

for i = 1:length(square)
    signal = [signal;square{i};deadSpace];
end

folderName = ['Library' filesep 'squareSequences'];
mkdir(folderName)

ts = cumsum(ones(length(signal),1) * (1/fs))-(1/fs);

poolSize = matlabpool('size');

if ~poolSize
    matlabpool open
end

parfor i = 1:length(baselineCurrent)
    for j = 1:length(squareMagnitude)
        fname = [folderName filesep 'baselineCurrent' num2str(baselineCurrent(i)) '_squareMag' num2str(squareMagnitude(j))];  
        toABF(fname,ts,(signal*squareMagnitude)+baselineCurrent(i))
    end
end

end

