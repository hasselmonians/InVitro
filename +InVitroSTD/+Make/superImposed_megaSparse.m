function sig = superImposed_megaSparse(sinSignal,secondSignal,seperationPoints,ifRandom,numberPhases,ifConst)
% sig = superImposed(sinSignal, secondSignal)
%
% Takes in a sinusoid input and a non-sinusoid input. finds minimum
% inflection points in the sinusoid input, and places second signal in a
% random location (super imposed) in each cycle of sinInput.
%
% Assumed time sampling for the signals is the same.

% wchapman 20130930

%% Setup
sinSignal = sinSignal(:);

if ~exist('seperationPoints','var')
    seperationPoints = [];
end

if ~exist('ifRandom','var')
    ifRandom = 1;
end

if ~exist('numberPhases','var')
    numberPhases = 16;
end

if ~exist('ifConst','var')
    ifConst = 0;
end

if isempty(seperationPoints)
    [~,seperationPoints] = findpeaks(sinSignal);
    seperationPoints = seperationPoints(1:15:length(seperationPoints));
end

% Fix edges of seperation points
if seperationPoints(1) ~= 0
   seperationPoints = [0;seperationPoints];
end

if seperationPoints(end) ~= length(sinSignal)
    seperationPoints = [seperationPoints;length(sinSignal)];
end

%% ifConst
% Forces the magnitude of superimposed signal at peaks to be same as at
% troughs.

if ifConst==1
    mag = max(sinSignal); 
elseif ifConst==-1
    mag = min(sinSignal);
end

%% ifRandom
if ifRandom == 1
    sig = sinSignal;

    for i = 2:length(seperationPoints)-1
        cycleInds = seperationPoints(i):seperationPoints(i+1);
        point = floor(cycleInds(1) + (cycleInds(end)-cycleInds(1)).*rand(1,1)); 

        lvar = min(length(secondSignal),length(sinSignal)-point) -1;

        if ~ifConst
            sig(point:point+lvar) = ...
                sig(point:point+lvar) + secondSignal(1:lvar+1); %add on the second signal starting at point
        else
            if ifConst==1
                
                t = mag - sig(point); %how much higher secondSignal needs to be
                scaleF = 1+(t / max(secondSignal));
                                
                sig(point:point+lvar) = sig(point:point+lvar) + scaleF*secondSignal(1:lvar+1);
                    
            elseif ifConst==-1
                
                t = mag-sig(point); % how much lower secondSignal needs to be.
                scaleF = abs(1+(t/min(secondSignal)));
                sig(point:point+lvar) = sig(point:point+lvar) + scaleF*secondSignal(1:lvar+1);
                
            end  
        end
    end    
end

%% Not random:
if ifRandom ==0
    
    sig = sinSignal;

    cycleLength = [diff(seperationPoints);NaN];
    cycleNumber = 1:1:length(seperationPoints);
    
    phaseOffsetNum = zeros(length(seperationPoints),1);
    for i = 2:length(seperationPoints)
        phaseOffsetNum(i) = phaseOffsetNum(i-1)+1;
        if phaseOffsetNum(i) == numberPhases
            phaseOffsetNum(i) = 0;
        end
    end
    
    offset = floor((cycleLength./numberPhases).*phaseOffsetNum(:));
    
    points = NaN(length(seperationPoints),1);
    for i = 1:length(offset)
        points(i) = seperationPoints(i)+offset(i);
    end
    
    points(points<seperationPoints(2)) = [];
    
    bads = find(diff(points)<(nanmean(diff(points))/3));

    points(bads) = [];
    
       
    for i = 1:length(points)-1
       lvar = min(length(secondSignal),length(sinSignal)-points(i)) -1; 
       
       point = points(i);
       
        if ~ifConst
            sig(point:point+lvar) = ...
                sig(point:point+lvar) + secondSignal(1:lvar+1); %add on the second signal starting at point
        else
            if ifConst==1
                
                t = mag - sig(point); %how much higher secondSignal needs to be
                scaleF = 1+(t / max(secondSignal));
                                
                sig(point:point+lvar) = sig(point:point+lvar) + scaleF*secondSignal(1:lvar+1);
                    
            elseif ifConst==-1
                
                t = mag-sig(point); % how much lower secondSignal needs to be.
                scaleF = abs(1+(t/min(secondSignal)));
                sig(point:point+lvar) = sig(point:point+lvar) + scaleF*secondSignal(1:lvar+1);
                
            end  
        end
       
       
       sig(points(i):points(i)+lvar) = ...
            sig(points(i):points(i)+lvar) + secondSignal(1:lvar+1); %add on the second signal starting at point
    end
    
end



end