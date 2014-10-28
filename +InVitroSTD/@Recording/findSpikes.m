function [spkInds spkHeight] = findSpikes(self)

    for i = 1:length(self.V)
        V = self.V{i};
        [spkHeight{i}, spkInds{i}] = findpeaks(V,'MINPEAKHEIGHT',0);
    end
    
end