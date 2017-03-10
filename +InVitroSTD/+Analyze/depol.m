function [hv depol tao fr adp nspk delay vp] = depol(entry)

%% setup
si = entry.ts{1}(2);

for i = 1:length(entry.I)
    y = entry.V{i};
    x = entry.I{i};
    hv(i) = nanmean(y(1:1000));
    
    nx = x-nanmean(x(1:1000));
    depol(i) = nanmean(nx(abs(nx)>2));
    on = find(nx>=depol(i),1,'first');
    off = find(nx>=depol(i),1,'last');
   
    eps = [1 on;
           on off;
           off length(x)];
       
    for ep = 1:3
        [~,inds] = findpeaks(y(eps(ep,1):eps(ep,2)),'MINPEAKHEIGHT',0);
        fr(i,ep) = length(inds) / ((eps(ep,2)-eps(ep,1))*entry.ts{1}(2));
        nspk(i,ep) = length(inds);
    end
    tao(i) = (off-on)*entry.ts{1}(2);
    
    %% Delay:
    if fr(i,3) > 0
        [~, ind] = findpeaks(y(eps(3,1):eps(3,2)),'MINPEAKHEIGHT',0);
        delay(i) = ind(1);
    else
        delay(i) = NaN;
    end
    
    %% ADP Rise
    yy = y(eps(3,1):eps(3,2));
    yy = smooth(yy,1000);
    
    [pkVals, pkInds] = findpeaks(yy,'MINPEAKDISTANCE',1000);
    [minVals, minInds] = findpeaks(-yy,'MINPEAKDISTANCE',1000);
    mnI = find(minInds>50);
    mnI = minInds(mnI(1));
    
    yy = yy(mnI:end);
    yy = yy-yy(1);
    t = (cumsum(ones(size(yy)))-1)*si;
    ft = fittype(['-A1*exp(-x/tao1) + A2*exp(-x/tao2)+e'],'independent','x','coefficients',{'A1' 'tao1','A2','tao2','e'});

    [~,ind] = max(yy); sb = t(ind);
    op = fitoptions(ft);
    op.lower = [0   0   0  sb    -inf];
    op.upper = [inf sb  inf    20*sb  inf];
    op.startPoint = [max(yy)-yy(1) sb/2 max(yy)-yy(end) 20*sb yy(end)];
    [res, goodness] = fit(t,yy,ft, op);
    %{
    clf
    plot(t,yy)
    hold on
    plot(res)
    drawnow
    title(['Tao_r_i_s_e=' num2str(res.tao1) ' && Tao_f_a_l_l=' num2str(res.tao2)])
    res
    %}
    adp.amp(i) = max(yy);
    adp.tao_slow(i) = res.tao2;
    adp.tao_fast(i) = res.tao1;
    
    
    %% plateu
    vp(i) = mean(y(end-1000):y(end));
    ylabel('Shifted Voltage (mV)')
    xlabel('time (s)')
end


end