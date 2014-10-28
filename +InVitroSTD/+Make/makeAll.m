baseSteps = [0 5 12.5 25];
ifRandom = [0 1];
ifConst = [1 0];
relativeStrength = [0.5 1];

for i = 1:length(baseSteps)
    for k = 1:length(ifRandom)
        for l = 1:length(ifConst)
            for m = 1:length(relativeStrength)
                make.makeSpatialSelectivity2(baseSteps(i),relativeStrength(m),ifRandom(k),ifConst(l));
            end
        end
    end
end

makeRampSin()

%{
makeSpatialSelectivity2(0,1)
makeSpatialSelectivity2(0,0)
makeSpatialSelectivity2(5,1)
makeSpatialSelectivity2(5,0)
makeSpatialSelectivity2(12.5,1)
makeSpatialSelectivity2(12.5,0)
makeSpatialSelectivity2(25,1)
makeSpatialSelectivity2(25,1)
%}