function [peak, freq, faxis, Y] = imped(self)

import InVitro.*
[~, ~, faxis, ~, Y] = InVitroSTD.Analyze.Chirp(self, 0);

[pk, ind] = findpeaks(Y);

if isempty(pk)
    peak = NaN;
    freq = NaN;
elseif ind(1) < faxis(5) && length(ind) > 1
    peak = pk(2);
    freq = faxis(ind(2));
else
    peak = pk(1);
    freq = faxis(ind(1));
end

end
