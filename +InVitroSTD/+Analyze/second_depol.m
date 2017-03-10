function [hv depol tao fr fit_params_rise_a fit_params_rise_b] = second_depol(entry)

    %% setup
    si = entry.ts{1}(2);

    for i = 1:length(entry.I)
        y = entry.V{i};
        x = entry.I{i};
        hv(i) = nanmean(y(1:1000));

        nx = x-nanmean(x(1:1000));
        depol(i) = nanmean(nx(abs(nx)>2));
        on = find(nx>=depol(i),2,'first');
        off = find(nx>=depol(i),1,'last');
        on = on(end);
        eps = [on:off];

        [~,inds] = findpeaks(y(eps(ep,1):eps(ep,2)),'MINPEAKHEIGHT',0);
        fr(i,ep) = length(inds) / ((eps(ep,2)-eps(ep,1))*entry.ts{1}(2));

        tao(i) = (off-on)*entry.ts{1}(2);

        %% ADP
        yy = y(eps(3,1):eps(3,2));
        [~,ind] = min(yy);
        yy = yy(ind:end);
        yyz = yy;

        % rise:
        [~,ind] = max(yyz);
        yy = yyz(1:ind);
        yy = yy-yy(1);
        ft = fittype([num2str(yy(end)) '- a*exp(-b*x)'],'independent','x','coefficients',{'a' 'b'});
        t = (cumsum(ones(size(yy)))-1)*si;
        op = fitoptions(ft);
        op.lower = [1 1];
        op.upper = [inf inf];
        op.startPoint = [max(yy)-min(yy) 100];
        [temp, goodness] = fit(t,yy,ft, op);
        fit_params_rise_a(i) = temp.a;
        fit_params_rise_b(i) = temp.b;  
    end

end
