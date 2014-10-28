function [y t ident] = doubleExp(tFinal,dt,tau1,tau2,factor1, factor2)
% Generates a double expontential stimulus. 
% plot(doubleExp(10,.001,.3,.5,5))

% wchapman 2013.09.10

if ~exist('factor1','var'),factor1=1;end
if ~exist('factor2','var'),factor2=1;end

t = 0:dt:tFinal;

y = (factor1*exp(-t/(tau2)) - factor2*exp(-t/(tau1)) );

[~,ident] = max(y);

y = y(:);
t = t(:);

end