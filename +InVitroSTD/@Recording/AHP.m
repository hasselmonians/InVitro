function [out] = AHP(di, varargin)

out = NaN(1,length(di.V));

if ~isempty(varargin) && length(varargin) > 1
    if ~isnan(varargin{2})
        [inds, ~] = findSpikes(di, varargin{1}, varargin{2});
    else
        [inds, ~] = findSpikes(di, varargin{1});
    end    
else
    [inds, ~] = findSpikes(di);
end 

% finds the on and off in current input
y = di.V{1}; %local voltage
x = di.I{1}; %local current
nx = x - nanmean(x(1:1000));
depol = nanmean(nx(abs(nx)>2));
Fs = 1 / (di.ts{1}(2) - di.ts{1}(1));

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



for i=1:length(di.I)
    % find the average membrane potential before the onset
    m = mean(di.V{i}(on - floor(Fs * .2):on -floor(Fs *.1)));
    %m = mean(di.V{i}(1:1000));
    ending = off;
    %Are there any spikes?
    if ~isempty(inds{i})
        
        %Are there spikes after offset of current injection?
        if inds{i}(end) > ending
            ending = inds{i}(end) + 100;
        end   

        %Find starting and stopping point for AHP analysis
        if di.V{i}(ending) > m
            start = find(di.V{i}(ending:end) < m , 1, 'first') + ending; 
        else 
            start = ending;
        end                  
        stop = find(di.V{i}(start:end) >= m , 1, 'first') + start;
        
        %Calculate are under the curve
        if ~isempty(stop)
            area = trapz(di.ts{i}(start:stop),(di.V{i}(start:stop) - m));
        else
            area = trapz(di.ts{i}(start:end),(di.V{i}(start:end) - m));
        end
        
        %Arbitrarily cutting areas off at magnitude one
        if abs(area)>1
            out(i) = area;
        else
            %Now try ADP
            ending = off;
            %Are there spikes after offset?
            if inds{i}(end) > ending
                ending = inds{i}(end) + 100;
            end
            
            %Find starting and stopping points for ADP analysis
            if di.V{i}(ending) < m
                start = find(di.V{i}(ending:end) > m, 1, 'first') + ending;
            else
                start = ending;
            end
            stop = find(di.V{i}(start:end) <= m, 1, 'first') + start;
            
            %Calculate area under the curve
            if ~isempty(stop)
                area = trapz(di.ts{i}(start:stop), (di.V{i}(start:stop) - m));
            else
                area = trapz(di.ts{i}(start:end), (di.V{i}(start:end) - m));
            end
            
            %Cutoff
            if abs(area) > 1
                out(i) = area;
            end
        end
    end
end

end
    

