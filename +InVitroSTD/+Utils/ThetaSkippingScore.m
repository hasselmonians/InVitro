function [theta_index theta_skipping] = ThetaSkippingScore(cor,lag,skipper)
    
% [cor, lag] = self.spk_xcorr(cel, max_lag, t_bin, 1, 'prob');
cor = cor(:);
lag = lag(:);
    
if skipper == 1
    f = fittype('[a*(cos(w*x)+1)+a2*(cos(w*x/2)+1)+b]*exp(-abs(x)/tau)+c*exp(-x^2/tau2^2)',...
            'independent', 'x', ...
            'coefficients', {'a' 'a2' 'b' 'c' 'tau' 'tau2' 'w'}); % make model

    options = fitoptions(f); 

    options.Lower = [0 0 0 -inf 0 0  5*pi*2];
    options.Upper = [1 1 1 inf 5 .050 9*pi*2];
    options.MaxIter = 10^3;
    options.MaxFunEvals = 10^4;

    options.StartPoint = [  max(cor(lag>.1 & lag<.150))-min(cor(lag>.1 & lag<.150)),... % a
                            0,... % a2
                            mean(cor(lag>-.1&lag<.1)),... %b
                            cor(round(end/2)),... %c
                            .1,... % tau
                            .015,... % tau2
                            2*pi*8]; % w

    [model, gof, info] = fit(lag(lag~=0), cor(lag~=0), f, options);

    peak_ts = 2*model.a+2*model.a2+model.b; % peak at theta skipping peak (3rd peak)

    peak_t = 2*model.a+model.b; % peak at theta skipping trough (2nd peak)

    %SL(i).thetaskip2 = model.a2 / model.a; looked pretty good

    theta_skipping = (peak_ts-peak_t) / max(peak_t, peak_ts);

    theta_index = (model.a+model.a2) / mean(cor);

    if info.exitflag<=0 % no convergence

        disp('No convergence in IntrinsicFrequency2');

        theta_index = NaN;
        f_intrins = NaN;
        modelstruct.model = model;
        modelstruct.gof = gof;
        modelstruct.info = info;
        modelstruct.cor = cor;
        modelstruct.lag = lag;
        modelstruct.theta_index = NaN;
        modelstruct.f_intrins = NaN;
        modelstruct.theta_skipping = NaN;

    else

        f_intrins = model.w/(2*pi);

        modelstruct.model = model;
        modelstruct.gof = gof;
        modelstruct.info = info;
        modelstruct.cor = cor;
        modelstruct.lag = lag;
        modelstruct.theta_index = theta_index;
        modelstruct.f_intrins = f_intrins;
        modelstruct.theta_skipping = theta_skipping;

    end
    
    
elseif skipper == 0
    cor = cor / max(cor(lag>.1 & lag<.150)); % normalize to peak between 100 and 150ms

    cor(cor>1) = 1; % clip anything greater than 1
    
    f = fittype('[a*(cos(w*x)+1)+b]*exp(-abs(x)/tau)+c*exp(-x^2/tau2^2)'); % make model
    
    options = fitoptions(f); 

    options.Lower = [0 0 0 0 0  5*pi*2];
    options.Upper = [1 1 1 5 .050 9*pi*2];
    options.MaxIter = 10^3;
    options.MaxFunEvals = 10^4;
    %                      
    options.StartPoint = [  max(cor(lag>.1 & lag<.150))-min(cor(lag>.1 & lag<.150)),... % a
                            mean(cor(lag>-.1&lag<.1)),... %b
                            cor(round(end/2)),... %c
                            .1,... % tau
                            .015,... % tau2
                            2*pi*8];  % w
    
    [model, gof, info] = fit(lag(lag~=0), cor(lag~=0), f, options);
    
    theta_skipping = NaN; % didnt measure for theta skipping

    theta_index = model.a / mean(cor);
    
end

end