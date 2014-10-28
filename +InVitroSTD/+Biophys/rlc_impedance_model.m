% Fitting response to ZAP input impedance curves
% Irina Erchova, 11/09
% modified by Ian Boardman, 11/09
%
% args: Frequency (radians) vector, impedance curve computed from
% membrane potential response to ZAP input:
%   Z(f) = abs(fft(U-mean(U)))./abs(fft(I-mean(I)))
% where U = membrane potential Vm(t), I(t) is input current.
% Z can be an array of impedance where length(Z) = length(W).
% Optional vector argument scales rand(1,4) starting parameters,
% (default [1 1 1000 1]).
% Returns first output argument of lsqcurvefit -- the model
% parameters -- and a structure containing the additional output
% arguments (see Matlab doc) 

function [M S] = rlc_impedance_model(W, Z, o, no_fit, self_call)
  sz = size(Z);
  d = find(min(sz));
  m = sz(d);
  n = sz(find(max(sz)));
  M = zeros(m,4);
  S(n,1) = struct('sqerr',0,'err',[],'flag',0,'info',struct([]));
  o_dft = [1 1 1e4 1];
  if nargin < 5
    self_call=0;
    if nargin < 4
      no_fit = [];
      if nargin < 3
        o = o_dft;
      end
    end
  end
  if isempty(o), o = o_dft; end
  zl = 1:m;
  for k = zl(~ismember(zl,no_fit))
    %% parameter setting
    % parameters are [R Rl L C]
    %Initial values of the parameters are random within established limits
    par = o .* rand(1,4);
    impfun = @InVitroSTD.Biophys.rlc_impedance_curve;
    % limits on parameters to fit a single solution
    LB=[0, -inf, 0, 1e-6]; UB=[inf, inf, inf, 100]; 
    % curve fit options
    fit_opts = optimset('MaxFunEvals',1e7,'MaxIter',1e6,...
                        'TolFun',1e-7,'TolCon',1e-2,'Display','off');
    % function that returns fit to current parameters
    if d == 1, z = Z(k,:); else z = Z(:,k); end
    [paroptim,sqerr,toterror,exit_flag,opt_info] = ...
        lsqcurvefit(impfun,par,W,z,LB,UB,fit_opts);
    %fprintf('%d model: %s, sq_err=%.5g\n', k, ...
    %        sprintf('%.5g ', paroptim), sqerr);
    if sqerr > 5e4 && (nargin < 4 || self_call < 4)
      disp('large error, evaluate with different starting value')
      if self_call > 2, o = [10 10 1e4 10]; end
      [M(k,:) S(k)] = rlc_impedance_model(W, z, o, [], self_call+1);
    else
      M(k,:) = paroptim;
      S(k) = struct('sqerr',sqerr,'err',toterror,'flag',...
                    exit_flag,'info',opt_info);
    end
  end
end

