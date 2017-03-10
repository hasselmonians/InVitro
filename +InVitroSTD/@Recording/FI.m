function [current, freq] = FI(self,varargin)
%Calculate spike frequency based on first two spikes in each sweep
%containing spikes. 
%
% Input Varables:
%       self: InVitro Recording object
%       varargin: Estimate for spike threshold
%
%Craig Kelley 10/13/16

%% Find spikes in each sweep
if ~isempty(varargin) && length(varargin) > 1
    if ~isnan(varargin{2})
        [timeInd, ~] = findSpikes(self, varargin{1}, varargin{2});
    else
        [timeInd, ~] = findSpikes(self, varargin{1});
    end
else
    [timeInd, ~] = findSpikes(self);
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
    
%% Calculate spike frequency for each sweep containing spikes
vec = cellfun(@isempty, timeInd);
if ~all(vec)
    %determine which cells in timeInd contain spikes
    L = sum(~vec);
    current = zeros(1,L);
    freq = zeros(1,L);
        
    %populate current and frequency
    ind = 1;
    for i = 1:length(timeInd)
        if ~vec(i)
            self.I{i} = self.I{i} - mean(self.I{i}(1000));
            current(ind) = mean(self.I{i}(on:off));
            if length(timeInd{i}) == 1
                freq(ind) = 1;
            else
                freq(ind) = 1 / (timeInd{i}(2) / Fs - timeInd{i}(1) / Fs);
            end
            ind = ind + 1;
        end
    end
else
    freq = NaN;
    current = NaN;
end

end