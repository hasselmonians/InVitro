function res = sag(entry,varargin)
%res = [I F depolTime sagRatio numRebound reboundDelay];

si = entry.ts{1}(2);


for i = 1:length(entry.V)
    
    y = entry.V{i}; %local voltage
    x = entry.I{i}; %local current
    nx = x - nanmean(x(1:1000));
    depol = nanmean(nx(abs(nx)>2));
    Fs = 1 / (entry.ts{i}(2) - entry.ts{i}(1));
    
    on = find(nx<=depol,1,'first');
    off = find(nx<=depol,1,'last');

    if (off - on) / Fs > .6
        start = on + floor(Fs * .3);
        vec = nx(start:end);
        on1 = find(vec <= depol, 1, 'first');
        on = start + on1;
    elseif (off - on) / Fs < .15
        depol = 0;
    end
            
            
    if depol < 0

        % ---------- sag ratio ---------- %
        vinitial = nanmean(y(1:100));
        vpeakHyper = min(y);
        vssHyper = nanmean(y(off-100:off));
        
        baseline = nanmean(y(on-300:on-100));
        current(i) = vssHyper - baseline;

        vsave(i) = vssHyper;

        sagRatio(i) = vpeakHyper / vssHyper ; %<-- roth 2009

        strength(i) = vpeakHyper - vssHyper;

        % --- tao_sag --- %
        % Formula from Giocomo 2013
        % V = A1^(-t/tao1)+A2^(-t/tao2)
        % tao = tao1
        % fit after the trough

        [~,minInd] = min(y);
        inds = minInd:off;
        y2 = y(inds);

        ft = fittype(['a*exp(-t/tao)+b*exp(-t/tao2)'],'independent','t','coefficients',{'a','b','tao','tao2'});
        op = fitoptions(ft);
        op.startPoint = [0 0 .2 100];
        op.lower = [-inf -inf 0 0];
        op.upper = [inf inf 1200/1000 10000];
        t = si*(cumsum(ones(size(y2)))-1);

        if length(y2)>2
            rsquare(i) = 0;attempts=0;
            while (rsquare(i) < 0.7) && (attempts<=10)
                [fit_params goodness] = fit(t,y2,ft,op);


                tao(i) = fit_params.tao;
                tao2(i) = fit_params.tao2;
                rsquare(i) = goodness.rsquare;
                a(i) = fit_params.a;
                b(i) = fit_params.b;
                attempts = attempts+1;
            end

            if attempts > 10
                tao(i) = NaN;
                tao2(i) = NaN;
                rsquare(i) = NaN;
                a(i) = NaN;
                b(i) = NaN;
            end
        else
            tao(i) = NaN;
            tao2(i) = NaN;
            rsquare(i) = NaN;
            a(i) = NaN;
            b(i) = NaN;
        end

        depolTime(i) = (off - on)*si;

        % find peaks%
        try
            if isempty(varargin)
                [spikeMag spikeInds] = findpeaks(y(on:off),'MINPEAKHEIGHT',0);
            else
                [spikeMag spikeInds] = findpeaks(y(on:off),'MINPEAKHEIGHT',varargin{1});
            end
            F(i) = length(spikeInds)/((off-on)*si);
            I(i) = depol;

            if ~isempty(spikeInds)
               spikeDelay(i) = spikeInds(1)*si;
               numSampleDelay{i} = spikeInds;
            else
               spikeDelay(i) = NaN;
               numSampleDelay{i} = NaN;
            end

        catch
            F(i) = 0;
            I(i) = depol;
            spikeDelay(i) = NaN;
            numSampleDelay{i} = NaN;
        end

        % find rebound peaks:
        try
            if isempty(varargin)
                [reboundMag reboundInds] = findpeaks(y(off:end),'MINPEAKHEIGHT',0);
            else
                [reboundMag reboundInds] = findpeaks(y(off:end),'MINPEAKHEIGHT',varargin{1});
            end
            numRebound(i) = length(reboundInds);
            if numRebound(i) ~=0
                reboundDelay(i) = (reboundInds(1)*si);
                numSampleDelay{i} = NaN;
            else
                reboundDelay(i) = NaN;
            end
        catch
            numRebound(i) = 0;reboundDelay(i) = NaN;
            numSampleDelay{i} = NaN;
        end
    end
end
%      1    2       3           4               5           6             7     8          9         10   
res = [I(:) F(:) depolTime(:) sagRatio(:) numRebound(:) reboundDelay(:) tao(:) tao2(:) strength(:) vsave(:) current(:)];

end