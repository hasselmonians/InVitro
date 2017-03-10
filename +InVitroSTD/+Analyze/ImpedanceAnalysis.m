function [peaks, freq, faxis, Yavg, Yerr] = ImpedanceAnalysis(varargin)
%ImpedanceAnalysis() calculates average impedance vs frequency for multiple
%zap/chirp sweeps. Each cell of varargin should contain an InVitro
%Recording object.  Yavg is the avg is the mean of the fitted curves to
%each chirp impedance response, Yerr is a vector of confidence intervals,
%faxis is a vector of frequencies, freq is a vector containing the
%resonance frequencies for each input Recording object, and peaks is the
%height of each resonance peak in each Recording object.
%
%Input Arguments:
%       varargin: InVitro Recording objects containnig single chirp/zap
%       sweeps
%
%Example Calls:
%       >>[peaks,freq,faxis,Yavg,Yerr] = ImpedanceAnalysis(d.Recording(3) ...
%           d.Recording(4), d.Recording(5));
%
%Craig Kelley 10/13/16

import InVitro.*

if isempty(varargin)
    fpritnf('You must pass at least one Recording object to ImpedanceAnalysis()\n');
else

    L = length(varargin);

    peaks = NaN(1,L);
    freq = NaN(1,L);

    for i = 1:L
        [peaks(i), freq(i), faxis, Y(i,:)] = InVitroSTD.Analyze.imped(varargin{i});
    end

    Yavg = mean(Y,1);
    Yerr = std(Y,1);
end

end