function [current, heights] = spikeHeights(self, varargin)

%% Find spikes in each sweep
if ~isempty(varargin)
    if length(varargin) > 1
        [timeInd, spkHeights] = findSpikes(self, varargin{1}, varargin{2});
    else
        [timeInd, spkHeights] = findSpikes(self, varargin{1});
    end
else
    [timeInd, spkHeights] = findSpikes(self);
end

%% Determine onset and offset of current step
y = self.V{1}; %local voltage
x = self.I{1}; %local current
nx = x - nanmean(x(1:1000));
depol = nanmean(nx(abs(nx)>2));
Fs = 1 / (self.ts{1}(2) - self.ts{1}(1));

on = find(nx<=depol,1,'first');
off = find(nx<=depol,1,'last');

if (off - on) / Fs > .6
    start = on + floor(Fs * .3);
    vec = nx(start:end);
    on1 = find(vec <= depol, 1, 'first');
    on = start + on1;
elseif (off - on) / Fs < .4
    depol = 0;
end

%% Main body
vec = cellfun(@isempty, timeInd);
if ~all(vec)
    %determine which cells in timeInd contain spikes
    L = sum(~vec);
    current = nan(1,L);
    heights = nan(1,L);
    %populate current and frequency
    ind = 1;
    for i = 1:length(timeInd)
        if ~vec(i)
            self.I{i} = self.I{i} - mean(self.I{i}(1000));
            current(ind) = mean(self.I{i}(on:off));
            heights(ind) = nanmean(spkHeights{i} - mean(self.V{i}(1:1000)));
            ind = ind + 1;
        end
    end
end

end