function firingRateHist(self, windowWidth, nOverlap, thresh)

%% Initialize variables
%thresh refers to threshold of the derivative for spike detection.
%Probably won't need to be adjusted
if ~exist('thresh','var') || isempty(thresh)
    thresh = 20;
end

%windowWidth refers to the size of the window (in seconds) used to calculate firing rate
if ~exist('windowWidth','var') || isempty(windowWidth)
    windowWidth = 10;
end

%nOveralp refers to the number of overlapping seconds between bins
if ~exist('nOverlap', 'var') || isempty(nOverlap)
    nOverlap = 0;
end

Fs = 1 / (self.ts{1}(2) - self.ts{1}(1));

i = 1;

%% Find spike threshold based off Tahvildari et al 2012
V = self.V{i};
dVdt = diff(V./1000)*Fs;

%Derivative greater than 20, +1; less than 20, -1; nan, otherwise
dV = nan(1,length(dVdt));
for j = 1:length(dV)
    if dVdt(j) > thresh
        dV(j) = 1;
    elseif dVdt(j) < -5
        dV(j) = -1;
    end
end

%Clean up the clutter
countPos = 0;
countPosInter = 0;
countNeg = 0;
countNegInter = 0;

for j = 1:length(dV)
    if dV(j) == -1 && countPos == 0
        dV(j) = nan;
    elseif dV(j) == 1
        countPosInter = j+1;
        while countPosInter < length(dV) && dV(countPosInter) ~= -1
            dV(countPosInter) = nan;
            countPosInter = countPosInter + 1;
        end
        countPos = countPos + 1;
    elseif dV(j) == -1
        countNegInter = j+1;
        while countNegInter < length(dV) && dV(countNegInter) ~= 1
            dV(countNegInter) = nan;
            countNegInter = countNegInter + 1;
        end
    end
end

%Find the spikes
count = 1;
for j = 1:length(dV)
    if dV(j) == 1
        fin = find(dV(j:end) == -1, 1, 'first');
        fin = fin + j + 1;
        if ~isempty(fin)
            [spkHeight_temp(count), spkInd_temp(count)] = max(V(j:fin));
            spkInd_temp(count) = spkInd_temp(count) + j - 1;
            heightDif(count) = spkHeight_temp(count) - V(j);
            count = count + 1;
        end
    end
end

%% Generate bar graph of for spike frequency vs time
oneHot = zeros(1,length(self.ts{1}));
oneHot(spkInd_temp) = 1;

%Calculate firing rate for each window
start = 1;
ending = start + round(windowWidth * Fs);
count = 1;
while ending <= length(self.ts{1})
    FR(count) = sum(oneHot(start:ending)) / (self.ts{1}(ending) - self.ts{1}(start));
    time(count) = median(self.ts{1}(start:ending));
    count = count + 1;
    start = start + round(windowWidth * Fs) + 1 - round(nOverlap * Fs);
    ending = start + round(windowWidth * Fs);
end

figure()
bar(time, FR)
xlabel('Time (s)')
ylabel('Firing Rate (Hz)')

end