function V2 = removeSpikes(self)

     inds = self.findSpikes;

    for i = 1:length(self.V)
        ind = inds{i};
        V = self.V{i};      
        
        for k = 1:length(ind)
            V(ind(k)-100:ind(k)+100) = NaN;
        end
        
        V2(i,:) = InVitroSTD.Utils.nanInterp(V,'spline');   
    end

end