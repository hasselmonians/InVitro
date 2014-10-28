function x = clean(x,lb,ub)
    
    if ~exist('lb','var')
        lb = -inf;
    end
    
    if ~exist('ub','var')
        ub = inf;
    end

    x = x(~isnan(x) & ~isinf(x) & x<ub & x>lb);

end