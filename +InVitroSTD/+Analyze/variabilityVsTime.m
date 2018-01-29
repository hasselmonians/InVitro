function [outTime, outMag] = variabilityVsTime(vec, time, window, overlap)

Fs = 1 / (time(2) - time(1));
starting = 1;
ending = window*Fs;
move = round(overlap*Fs);
count = 1;

while ending <= length(vec)
    outMag(count) = abs(max(vec(starting:ending)) - min(vec(starting:ending)));
    outTime(count) = median(time(starting:ending));
    starting = starting + move;
    ending = starting + window*Fs - 1;
    count = count + 1;
end

end