function [spkInds, spkHeight] = findSpikes(self, varargin)
%findSpikes() determines the indicies and heights of spikes in each sweep
%of the InVitro Recording object self.  A second optional argument is an
%estimate for the threshold of spiking.
%
%Input variables:
%       self: InVitro Recording object
%       varargin: Estimate of spike threshold
%
%Example calls:
%       >> [spkInds, spkHeight] = d.Recording(3).findSpikes;
%       >> [spkInds, spkHeight] = findSpikes(d.Recording(3));
%       >> [spkInds, spkHeight] = findSpikes(d.Recording(3),-20);
%
%Bill Chapman, Craig Kelley 10/13/16


%% Determine onset and offset of current step
y = self.V{1}; %local voltage
x = self.I{1}; %local current
nx = x - nanmean(x(1:1000));
depol = nanmean(nx(abs(nx)>2));
Fs = 1 / (self.ts{1}(2) - self.ts{1}(1));
deltaV = [];

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

%% Initialize Fs and first pass at finding spikes
Fs = 1 / (self.ts{1}(2) - self.ts{1}(1));

for i = 1:length(self.V)
    V = self.V{i};
    if ~isempty(varargin)
        [spkHeight{i}, spkInds{i}] = findpeaks(V(on:end), 'MINPEAKHEIGHT',varargin{1});
    else
        [spkHeight{i}, spkInds{i}] = findpeaks(V(on:end),'MINPEAKHEIGHT',0);
    end
    if ~isempty(spkInds{i})
        spkInds{i} = spkInds{i} + on;
    end
end




%% For each sweep that has spikes, make sure we've caught them all 
if ~all(cellfun(@isempty,spkInds))
    for i = 1:length(spkInds)
        if ~isempty(spkInds{i})
            
            %Find spike threshold based off Tahvildari et al 2012
            V = self.V{i};
            dVdt = diff(V./1000)*Fs;
            
            %Derivative greater than 20, +1; less than 20, -1; nan, otherwise
            dV = nan(1,length(dVdt));
            for j = on:length(dV)
                if dVdt(j) > 10
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
                    while countNegInter < length(dV) && dV(countNegInter) ~= 1;
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

            %Clear out  bad spikes
%             ind = find(spkHeight_temp < mean(spkHeight_temp) - 5*std(spkHeight_temp));
%             ind = find(heightDif < mean(heightDif) - 5*std(heightDif));
            if exist('heightDif','var')
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %                   Changed from < 4 -> < 20  -> < 10      %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                ind = find(heightDif < 4);
                if ~isempty(ind)
                    spkHeight_temp(ind) = [];
                    spkInd_temp(ind) = [];
                end
                
                spkInds{i} = spkInd_temp;
                spkHeight{i} = spkHeight_temp;
                
                clear spkInd_temp spkHeight_temp heightDif;
            else
                spkInds{i} = [];
                spkHeight{i} = [];
            end
            
            %%%%Trying something else%%%%
%             Vm = self.V{i}(find(dVdt > 15));
%             Vavg = mean(self.V{i}(on:off));
%             Vm(Vm < Vavg) = [];
%             
%             if ~isempty(varargin) && length(varargin) > 1
%                 if ~isnan(varargin{2})
%                     thresh = mean(Vm) + varargin{2};
%                 else
%                     thresh = mean(Vm);
%                 end
%             else
%                 thresh = mean(Vm);
%             end 
%             
%             [spkHeight{i}, spkInds{i}] = findpeaks(self.V{i}(on:end),'MINPEAKHEIGHT',thresh);
%             spkInds{i} = spkInds{i} + on -1;
            
            
%             %Clean up using spike heights
%             minval = min(self.V{i}(on + floor(.1*Fs) : off - floor(.1*Fs)));
%             if isempty(minval)
%                 minval = min(self.V{i}(on : off));
%             end
% %             
%             if minval < 0
%                 h = .75*minval;
%                 [spkHeight{i}, spkInds{i}] = findpeaks(self.V{i}(on:end),'MINPEAKHEIGHT', .6*h);
%             else
%                 h = 2*minval;
%                 [spkHeight{i}, spkInds{i}] = findpeaks(self.V{i}(on:end),'MINPEAKHEIGHT', h);
%             end
%             spkInds{i} = spkInds{i} + on;
%             
           %%Calculate using maximum height
%             maxval = max(self.V{i}(on : off));
%             avg = mean([minval, maxval]);
%             [spkHeight{i}, spkInds{i}] = findpeaks(self.V{i}(on:end), 'MINPEAKHEIGHT', avg);
% %             [spkHeight{i}, spkInds{i}] = findpeaks(self.V{i}(on:end), 'MINPEAKHEIGHT', avg-12);
% %             [spkHeight{i}, spkInds{i}] = findpeaks(self.V{i}(on:end), 'MINPEAKHEIGHT', .85*avg);
%             spkInds{i} = spkInds{i} + on;
%             
            %Clean up using interspike invervals
%             a = diff(spkInds{i});
%             for j = 1:length(a)
%                 if a(j) < .25*mean(a)
%                     spkInds{i}(j) = NaN;
%                     spkHeight{i}(j) = NaN;
%                 end
%             end
%             spkInds{i}(isnan(spkInds{i})) = [];
%             spkHeight{i}(isnan(spkHeight{i})) = [];
%             count = 2;
%             while count <= length(spkHeight{i})
%                 if spkHeight{i}(count) < 1.2*spkHeight{i}(count-1)
%                     spkHeight{i}(count) = [];
%                     spkInds{i}(count) = [];
%                 else
%                     count = count + 1;
%                 end
%             end
%             
            %second go
%             a = diff(spkInds{i});
%             for j = 1:length(a)
%                 if a(j) < .2*mean(a)
%                     spkInds{i}(j) = NaN;
%                     spkHeight{i}(j) = NaN;
%                 end
%             end
%             spkInds{i}(isnan(spkInds{i})) = [];
%             spkHeight{i}(isnan(spkHeight{i})) = [];
        end
    end
end    

end