function res = gabab(varargin)
    %{
    spkHeight = [0 500 1000];
    thetaAmp = [25 50];% 100 200];
    gammaAmp = [5 10 25 50];% 100 200];
    gammaFreq = [40 60 100];
    thetaFreq = [1 2 3 4 5 8 10];

    for h = 3:length(thetaFreq)
        for i = 1:length(thetaAmp)
            for k = 1:length(gammaAmp)
                for m = 1:length(spkHeight)
                    for n = 1:length(gammaFreq)
                        res = make.gabab('gammaFreq',gammaFreq(n),'thetaFreq',thetaFreq(h),'thetaAmp',thetaAmp(i),'gammaAmp',gammaAmp(k),'spkHeight',spkHeight(m),'ifSave',1,'ifPlot',0);
                    end
                end
            end
        end
    end
    %}
    %% Setup:
    p = inputParser;
    p.addParamValue('ifSave',0);
    p.addParamValue('sampFreq',5000);
    p.addParamValue('ifPlot',1);
    
    p.addParamValue('spkHeight',100);
    p.addParamValue('tau1',0.5/1000);
    p.addParamValue('tau2',1/1000);
    p.addParamValue('spkMode', 'square');
    p.addParamValue('spkDur', 10);
    
    p.addParamValue('gabbaAmp',50);
    p.addParamValue('gt1',5/1000);
    p.addParamValue('gt2',20/1000);
    p.addParamValue('gabbaStep',50);
    
    p.addParamValue('gammaFreq',80);
    p.addParamValue('gammaAmp',50*.125);
    
    p.addParamValue('thetaFreq',8);
    p.addParamValue('thetaAmp',50);
    
    
    p.parse(varargin{:});
    fns = fieldnames(p.Results);
    for i = 1:length(fns)
        eval([fns{i} '= p.Results.' fns{i} ';']);
    end
    
    dt = 1/sampFreq;

    %% Make "spikes"

    if strcmp(spkMode,'double')
        spk = make.doubleExp(1,dt,tau1,tau2,1);
        spk = spk/max(spk);
    elseif strcmp(spkMode,'square')
        spk = ones(spkDur,1);
    end
    
    spk = spk*spkHeight;

    %% The gabba stimulus:
    [gb] = make.doubleExp(1/thetaFreq,dt,gt1,gt2,1);
    gb = gb/max(gb);
    gb = gabbaAmp*(-gb) + gabbaAmp;
    
    res.gabba.sig = repmat(gb,20,1);
    res.gabba.ts = dt*(cumsum(ones(size(res.gabba.sig)))-1);

    %% Gabba with input
    [gb] = make.doubleExp(1/thetaFreq,dt,gt1,gt2,1);
    gb = gb/max(gb);
    gb = gabbaAmp*(-gb) + gabbaAmp;

    gbspk = make.superImpose(gb,spk,50-length(spk)/2);
    
    gabaDepol = [repmat(gb,4,1);gbspk;repmat(gb,20,1)];
    gabaDepol_ts = dt*(cumsum(ones(size(gabaDepol)))-1);
    
    %% 5X
    ts = 1/(gammaFreq*4):dt:5/(gammaFreq)+(1/(gammaFreq*4));
    x5 = (sin(2*pi*ts*gammaFreq) - 1)/2;
    x5 = x5(:);
    
    zv = zeros(floor(((0.125-ts(end))/dt)/2),1);
    x5 = [zv;x5;zv];
    x5 = gammaAmp*repmat(x5,5,1);

    x52 = make.superImpose(x5,spk,1493-length(spk)/2);
    
    x5 = [x5;x52;x5;x5;x5;x5];
    
    x5_ts = dt*(cumsum(ones(size(x5)))-1);

    %% Gamma:
    ts_gamma = 0:dt:1/gammaFreq;
    gamma = gammaAmp*sin(2*pi*ts_gamma*gammaFreq);
    
    gamma = [repmat(gamma,1,5) zeros(1,floor(((1/thetaFreq)/dt))-length(gamma))];
    gamma = repmat(gamma,1,20);
    
    
    res.gamma.sig = gamma;
    res.gamma.ts =  dt*(cumsum(ones(size(res.gamma.sig)))-1);
    
    %% GammaBeta
    gb=make.doubleExp(1/thetaFreq,dt,gt1,gt2,1);
    gb = gb/max(gb);
    gb = gabbaAmp*(-gb);
    
    ts = dt*(cumsum(ones(size(gb)))-1);
    
    gamma = gammaAmp*sin(2*pi*ts*gammaFreq);
    gamma(1:440)=0;
    
    gammabeta = gamma+gb+gabbaAmp;
    
    % Make cycle specific ones:
    clear sig
    sig{1} = make.superImpose(gammabeta,spk,30-length(spk)/2);
    sig{2} = make.superImpose(gammabeta,spk,115-length(spk)/2);
    sig{3} = make.superImpose(gammabeta,spk,164-length(spk)/2);
    sig{4} = make.superImpose(gammabeta,spk,211-length(spk)/2);
    sig{5} = make.superImpose(gammabeta,spk,255-length(spk)/2);
    sig{6} = make.superImpose(gammabeta,spk,564-length(spk)/2);
    sig{7} = gammabeta(:);

    sig = cell2mat([repmat(sig(7),5,1);sig(1);repmat(sig(7),20,1)]);

    res.gammabeta.sig = sig;
    res.gammabeta.ts = dt*(cumsum(ones(size(res.gammabeta.sig)))-1);
    
    
    %% GammaBetaPeak
    gb=make.doubleExp(1/thetaFreq,dt,gt1,gt2,1);
    gb = gb/max(gb);
    gb = gabbaAmp*(-gb);
    
    ts = dt*(cumsum(ones(size(gb)))-1);
    
    gamma = gammaAmp*sin(2*pi*ts*gammaFreq);
    gamma(1:440)=0;
    
    gammabeta = gamma+gb+gabbaAmp;
    
    % Make cycle specific ones:
    clear sig
    sig{1} = make.superImpose(gammabeta,spk,50-length(spk)/2);
    sig{2} = make.superImpose(gammabeta,spk,115-length(spk)/2);
    sig{3} = make.superImpose(gammabeta,spk,164-length(spk)/2);
    sig{4} = make.superImpose(gammabeta,spk,211-length(spk)/2);
    sig{5} = make.superImpose(gammabeta,spk,255-length(spk)/2);
    sig{6} = make.superImpose(gammabeta,spk,580-length(spk)/2);
    sig{7} = gammabeta(:);

    
    sig = cell2mat([repmat(sig(7),5,1);sig(6);repmat(sig(7),20,1)]);

    gammabetaPeak = sig;
    gammabetaPeak_ts = dt*(cumsum(ones(size(gammabeta)))-1);
    
    %% gamma peak & trough
    ts = 0:dt:1/gammaFreq;
    gamma = gammaAmp*(sin(2*pi*ts*gammaFreq))/2;
    gamma = gamma(:);
    
    clear sig
    [~,maxInd] = max(gamma);
    [~,minInd] = min(gamma);
    
    sig{1} = gamma(:);
    sig{2} = make.superImpose(gamma,spk,maxInd-length(spk/2));
    sig{3} = make.superImpose(gamma,spk, minInd-length(spk/2));
    
    
    res.gammaTrough.sig = cell2mat([repmat(sig(1),5,1);sig(3);repmat(sig(1),20,1)]);
    res.gammaTrough.ts = dt*(cumsum(ones(size(res.gammaTrough.sig)))-1);

    res.gammaPeak.sig = cell2mat([repmat(sig(1),5,1);sig(2);repmat(sig(1),20,1)]);
    res.gammaPeak.ts = dt*(cumsum(ones(size(res.gammaPeak.sig)))-1);
    
    %% Gamma-Theta
    ts = 0:dt:1/thetaFreq;

    theta = sin(2*pi*ts*thetaFreq);
    gamma = sin(2*pi*ts*gammaFreq);
    gamma(floor(length(gamma)/2):end) = 0;
    
    tg = thetaAmp*theta+gammaAmp*gamma;

    % Make cycle specific ones:
    clear sig
    sig{1} = make.superImpose(tg,spk,68-length(spk)/2);
    sig{2} = make.superImpose(tg,spk,115-length(spk)/2);
    sig{3} = make.superImpose(tg,spk,164-length(spk)/2);
    sig{4} = make.superImpose(tg,spk,211-length(spk)/2);
    sig{5} = make.superImpose(tg,spk,255-length(spk)/2);
    sig{6} = make.superImpose(tg,spk,467-length(spk)/2);
    sig{7} = tg(:);

    sig = cell2mat([repmat(sig(7),5,1);sig(6);repmat(sig(7),20,1)]);

    gammatheta = sig;

    gammatheta_ts = dt*(cumsum(ones(size(gammatheta)))-1);
    
     %% Gamma-Theta - peak
    ts = 0:dt:1/thetaFreq;

    theta = sin(2*pi*ts*thetaFreq);
    gamma = sin(2*pi*ts*gammaFreq);
    gamma(floor(length(gamma)/2):end) = 0;
    
    tg = thetaAmp*theta+gammaAmp*gamma;

    % Make cycle specific ones:
    clear sig
    sig{1} = make.superImpose(tg,spk,68-length(spk)/2);
    sig{2} = make.superImpose(tg,spk,115-length(spk)/2);
    sig{3} = make.superImpose(tg,spk,143-length(spk)/2);
    sig{4} = make.superImpose(tg,spk,211-length(spk)/2);
    sig{5} = make.superImpose(tg,spk,255-length(spk)/2);
    sig{6} = make.superImpose(tg,spk,467-length(spk)/2);
    sig{7} = tg(:);

    sig = cell2mat([repmat(sig(7),5,1);sig(3);repmat(sig(7),20,1)]);

    res.gammathetaPeak.sig = sig;

    res.gammathetaPeak.ts = dt*(cumsum(ones(size(gammatheta)))-1);

    %% Gamma-theta Input at trough of theta
    ts = 0:dt:1/thetaFreq;

    theta = sin(2*pi*ts*thetaFreq);
    gamma = sin(2*pi*ts*gammaFreq);
    gamma(floor(length(gamma)/2):end) = 0;
    
    tg = thetaAmp*theta+gammaAmp*gamma;
    
    [~,ind] = min(tg);
    
    % Make cycle specific ones:
    clear sig
    sig{1} = make.superImpose(tg,spk,68-length(spk)/2);
    sig{2} = make.superImpose(tg,spk,115-length(spk)/2);
    sig{3} = make.superImpose(tg,spk,143-length(spk)/2);
    sig{4} = make.superImpose(tg,spk,211-length(spk)/2);
    sig{5} = make.superImpose(tg,spk,255-length(spk)/2);
    sig{6} = make.superImpose(tg,spk,467-length(spk)/2);
    sig{7} = tg(:);
    sig{8} = make.superImpose(tg,spk,ind-length(spk)/2);
    
    sig = cell2mat([repmat(sig(7),5,1);sig(8);repmat(sig(7),20,1)]);

    res.gammatheta_thetaTrough.sig = sig;

    res.gammatheta_thetaTrough.ts = dt*(cumsum(ones(size(gammatheta)))-1);
    
    %% Output
    res.x5.sig = x5;
    res.x5.ts = x5_ts;
    
    %res.x20.sig = x20;
    %res.x20.ts = x20_ts;
    
    res.gammabetaPeak.sig = gammabetaPeak;
    res.gammabetaPeak.ts = dt*(cumsum(ones(size(gammabetaPeak)))-1);
    
    res.gammabeta.ts = dt*(cumsum(ones(size(res.gammabeta.sig)))-1);
    
    res.gammatheta.sig = gammatheta;
    res.gammatheta.ts = dt*(cumsum(ones(size(gammatheta)))-1);
    
    %res.gammathetaPeak.sig = gammathetaPeak;
    %res.gammathetaPeak.ts = dt*(cumsum(ones(size(gammathetaPeak)))-1);
    
    ds = zeros(sampFreq*5,1);
    %sig = [res.x5.sig;ds;res.x20.sig;ds;res.gammabeta.sig;ds;res.gammabetaPeak.sig;ds;res.gammatheta.sig;ds;res.gammathetaPeak.sig];
    %ts = dt*(cumsum(ones(size(sig)))-1);
        
    %% Write it
    
    if ifSave == 1
       make.toABF(['~/Desktop/gabab/gamma_neg/' num2str(gammaAmp) 'pA_' num2str(gammaFreq) 'Hz' '_spk' num2str(spkHeight) '_' num2str(spkDur) '.abf'], res.x5.ts,res.x5.sig);
       make.toABF(['~/Desktop/gabab/gamma/' num2str(gammaAmp) 'pA_' num2str(gammaFreq) '-' num2str(thetaFreq) 'Hz' '_spk' num2str(spkHeight) '_' num2str(spkDur) '.abf'], res.gamma.ts,res.gamma.sig);
       make.toABF(['~/Desktop/gabab/gammaPeak/' num2str(gammaAmp) 'pA_' num2str(gammaFreq) 'Hz' '_spk' num2str(spkHeight) '_' num2str(spkDur) '.abf'], res.gammaTrough.ts, res.gammaTrough.sig);
       make.toABF(['~/Desktop/gabab/gammaTrough/' num2str(gammaAmp) 'pA_' num2str(gammaFreq) 'Hz' '_spk' num2str(spkHeight) '_' num2str(spkDur) '.abf'], res.gammaPeak.ts, res.gammaPeak.sig);
       make.toABF(['~/Desktop/gabab/gabbaDepol/' num2str(gabbaAmp) 'pA' '_spk' num2str(spkHeight) '_' num2str(spkDur) '_' num2str(thetaFreq) 'Hz.abf'], gabaDepol_ts,gabaDepol);
       make.toABF(['~/Desktop/gabab/gabba/' num2str(gabbaAmp) 'pA' '_spk' num2str(spkHeight) '_' num2str(spkDur) '.abf'],res.gabba.ts,res.gabba.sig);
       make.toABF(['~/Desktop/gabab/gammagabaPeak/' num2str(gammaAmp) '-' num2str(gabbaAmp) 'pA_' num2str(thetaFreq) '-'  num2str(gammaFreq) 'Hz' '_spk' num2str(spkHeight) '_' num2str(spkDur) '.abf'],res.gammabetaPeak.ts,res.gammabetaPeak.sig);
       make.toABF(['~/Desktop/gabab/gammagabaTrough/' num2str(gammaAmp) '-' num2str(gabbaAmp) 'pA_' num2str(thetaFreq) '-' num2str(gammaFreq) 'Hz' '_spk' num2str(spkHeight) '_' num2str(spkDur) '.abf'], res.gammabeta.ts, res.gammabeta.sig);
       make.toABF(['~/Desktop/gabab/gammathetaTrough/' num2str(gammaAmp) '-' num2str(thetaAmp) 'pA_' num2str(gammaFreq) '-' num2str(thetaFreq) 'Hz' '_spk' num2str(spkHeight) '_' num2str(spkDur) '.abf'], res.gammatheta.ts, res.gammatheta.sig);
       make.toABF(['~/Desktop/gabab/gammathetaPeak/' num2str(gammaAmp) '-' num2str(thetaAmp) 'pA_' num2str(gammaFreq) '-' num2str(thetaFreq) 'Hz' '_spk' num2str(spkHeight) '_' num2str(spkDur) '.abf'], res.gammathetaPeak.ts, res.gammathetaPeak.sig);
       make.toABF(['~/Desktop/gabab/gammatheta_thetaTrough/' num2str(gammaAmp) '-' num2str(thetaAmp) 'pA_' num2str(gammaFreq) '-' num2str(thetaFreq) 'Hz' '_spk' num2str(spkHeight) '_' num2str(spkDur) '.abf'], res.gammatheta_thetaTrough.ts, res.gammatheta_thetaTrough.sig);
       

    end
    
end


