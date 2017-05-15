function V2 = removeSpikes(self,varargin)
%removeSpikes() removes spikes from each sweep in the InVitro Recording 
%object by using spline interpolation. Varargin is an optional input
%argument for estimated spike threshold.
%
%Bill Chapman, Craig Kelley 10/13/16
    if ~isempty(varargin)
        if length(varargin) > 1
            inds = findSpikes(self,varargin{1},varargin{2});
        else
            inds = findSpikes(self,varargin{1});
        end
    else
        inds = self.findSpikes;
    end

    for i = 1:length(self.V)
        ind = inds{i};
        V = self.V{i};      
        
        for k = 1:length(ind)
            V(ind(k)-60:ind(k)+60) = NaN;
        end
        
        V2(i,:) = InVitroSTD.Utils.nanInterp(V,'spline');   
    end

end