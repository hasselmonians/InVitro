function FIall(self)
%calculate FI curve for all Recordings in a cell/path

%initialize variables
import InVitro.*

Fs = 1 / (self.Recording(1).ts{1}(2) - self.Recording(1).ts{1}(1));
outs = struct();
count = 1;

%determine spike frequency for each recording
for i = 1:length(self.Recording)
    [timeInd, height] = self.Recording(i).findSpikes;
    vec = cellfun(@isempty, timeInd);
    if ~all(vec)
        L = sum(~vec);
        outs(count).current = zeros(1,L);
        outs(count).freq= zeros(1,L);
        ind = 1;
        for j = 1:length(timeInd)
            if ~vec(j)
                outs(count).current(ind) = mean(self.Recording(i).I{j}(Fs:1.2 * Fs));
                if length(timeInd{j}) == 1
                    outs(count).freq(ind) = 1;
                else
                    outs(count).freq(ind) = length(timeInd{j}) / (timeInd{j}(end) / Fs - timeInd{j}(1) / Fs);
                end
                ind = ind + 1;
            end
        end
        count = count + 1;
    end
end

%determine average and std for frequency 
if isfield(outs(1),'freq')
    %determine minimum and maximum currents tested
    minI = floor(outs(1).current(1));
    maxI = floor(outs(1).current(end));
    if length(outs) > 1
        for i = 2:length(outs)
            if outs(i).current(1) < minI
                minI = floor(outs(i).current(1));
            end
            if outs(i).current(end) > maxI
                maxI = floor(outs(i).current(end));
            end
        end
    end
    %create matrix of frequencies
    I = minI:10:maxI;
    F = nan(length(outs),length(I));
    for i = 1:length(outs)
        for j = 1:length(outs(i).current)
            ind = find(I == floor(outs(i).current(j)));
            F(i,ind) = outs(i).freq(j);
        end
    end
    Favg = nanmean(F);
    Ferr = nanstd(F);
        
    %plotting nonsense
    upper = Favg + Ferr;
    lower = Favg - Ferr;
    figure()
    fade = .3;
    color = [0, 0, 1];    
    fill([I fliplr(I)],[upper fliplr(lower)],[.49, .73, .91])
    hold on
    plot(I,Favg,'Color',color*(1-fade),'LineWidth',1.5);
    
else
    fprintf('Warning: There are no spikes contained in this Neuron object."\n')
end

end