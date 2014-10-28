function sig = superImpose(und,sup,lp)

und = und(:);
sup = sup(:);

sig = und;

    for i = 1:length(lp)
        %lvar = min([length(und),length(sup)+lp(i),length(und)-lp(i)]) -1;
        lvar = length(sup);
        sig(lp(i):lp(i)+lvar-1) = ...
                sig(lp(i):lp(i)+lvar-1) + sup(1:lvar);
    end


end