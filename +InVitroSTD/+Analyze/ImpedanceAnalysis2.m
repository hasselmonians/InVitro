function [peaks, freq, faxis, Yavg, Yerr] = ImpedanceAnalysis2(self)
%ImpedanceAnalysis2() is an alternative method for calculating average
%impedance and confidence intervals for multiple chirp/zap sweeps
%contained in a single InVitro Recording object. For description of output
%variables, see 'help InVitroSTD.Analyze.ImpedanceAnalysis'.
%
%Input Arguments:
%       self: InVitro Recording object
%
%Example call:
%       >> [peaks, freq, faxis

import InVitro.*

if isempty(self)
    fpritnf('You must pass at least one Recording object to ImpedanceAnalysis()\n');
else

    L = length(self.V);

    peaks = NaN(1,L);
    freq = NaN(1,L);

    for i = 1:L
        [peaks(i), freq(i), faxis, Y(i,:)] = InVitroSTD.Analyze.imped2(self.I{i},self.V{i},self.ts{i});
    end

    Yavg = mean(Y,1);
    Yerr = std(Y,1);
end

end