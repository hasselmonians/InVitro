function [current, ahps] = shortAHP(self, varargin)

%% Find spikes in each sweep
if ~isempty(varargin)
    if length(varargin) > 1
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

%% Main body
vec = cellfun(@isempty, timeInd);
if ~all(vec)
    %determine which cells in timeInd contain spikes
    L = sum(~vec);
    current = nan(1,L);
    ahps = nan(1,L);
        
    %populate current and frequency
    ind = 1;
    for i = 1:length(timeInd)
        if ~vec(i) && length(timeInd{i}) > 1
            self.I{i} = self.I{i} - mean(self.I{i}(1000));
            current(ind) = mean(self.I{i}(on:off));
            ahp = zeros(1,length(timeInd{i})-1);
            V = self.V{i};
            time = self.ts{i};
            dVdt = diff(V./1000)*Fs;
            VmInds = find(dVdt > 15);
            for j = 1:length(timeInd{i})-1
                %determine subthreshold indicies between spikes
%                 between = V(timeInd{i}(j):timeInd{i}(j+1));
%                 ibegin = find(between < thresh, 1, 'first');
%                 begin = timeInd{i}(j) + ibegin - 1;
%                 iend = find(between < thresh, 1, 'last');
%                 ending = timeInd{i}(j) + iend;
                index = find(VmInds > timeInd{i}(j), 1, 'first');
                if ~isempty(index)
                    thresh = V(VmInds(index));
                    ending = VmInds(index);
                    begin = timeInd{i}(j) + find(V(timeInd{i}(j):end) <= thresh + .5, 1, 'first') - 1; 

                    int = trapz(time(begin:ending),V(begin:ending));
                    ahp(j) = int - (thresh*(time(ending)-time(begin)));
                end
            end
            ahps(ind) = nanmean(ahp);
            ind = ind + 1;
        end
    end
end