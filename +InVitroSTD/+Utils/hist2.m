function rm = hist2(x,y,z, xb,yb)
    if ~exist('xb','var')
        xb = linspace(min(x),max(x),5);
    end
    
    if ~exist('yb','var')
        yb = linspace(min(y),max(y),5);
    end
    
    
    [~,wx] = histc(x,xb);
    [~,wy] = histc(y,yb);

    rm = NaN(length(xb),length(yb));
    for i = 1:length(xb)
        for k = 1:length(yb)
            inds = find(wx==i & wy==k);
            rm(i,k) = nanmean(z(inds));
        end
    end
end