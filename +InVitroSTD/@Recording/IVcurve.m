function [current, voltage, fit, res, rsq] = IVcurve(self)
%IVcurve() calculates the average membrane potential at each current
%injection in an InVitro Recording object and fits a line to the voltage values at currents less than
%zero.  res is the slope of the best fit line fit, and rsq is the R^2 value
%for the fit.
%
%Input variables:
%       self: InVitro Recording object.
%
%Example calls:
%       [current, voltage, fit, res, rsq] = d.Recording(7).IVcurve;
%       [current, voltage, fit, res, rsq] = IVcurve(d.Recording(7));
%
%Craig Kelley 10/13/16

%% Initialize variables
current = zeros(1,length(self.V));
voltage = zeros(1,length(self.V));

%% Determine onset and offset of current injection
y = self.V{1}; %local voltage
x = self.I{1}; %local current
nx = x - nanmean(x(1:1000));
depol = nanmean(nx(abs(nx)>2));
Fs = 1 / (self.ts{1}(2) - self.ts{1}(1));

on = find(nx<=depol,1,'first');
off = find(nx<=depol,1,'last');

if (off - on) / Fs > .6
    start = on + floor(Fs * .3);
    vec = nx(start:end);
    on1 = find(vec <= depol, 1, 'first');
    on = start + on1;
elseif (off - on) / Fs < .4
    depol = 0;
end

%% Calculate average membrane potential at each current step
for i = 1:length(self.V)
    self.I{i} = self.I{i} - mean(self.I{i}(1:1000));
    current(i) = mean(self.I{i}(on:off));
    voltage(i) = mean(self.V{i}(on:off)) - mean(self.V{i}(on-floor(.1*Fs)-100 : on - 100));
end

%% Fitting line to voltage vs. current and relevant parameters
p = polyfit(current(current < 0), voltage(current < 0), 1);
fit = polyval(p,current(current < 0));
res = p(1);
rsq = 1 - sum((voltage(current<0) - fit).^2)/sum((voltage(current<0) - mean(voltage(current<0))).^2);

end