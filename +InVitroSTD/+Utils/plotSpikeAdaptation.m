function plotSpikeAdaptation(da, db, dc)

import InVitro.*

%calculate spike adaptation of each
[outA, freqA] = spikeAdaptation(da, 'base');
[outB, freqB] = spikeAdaptation(db, 'dur');
[outC, freqC] = spikeAdaptation(dc, 'wash');

%find which current step to start at
starts = zeros(1,3);
count = 1;
while length(outA(count).time) < 4
    count = count + 1;
end
starts(1) = count;
count = 1;
while length(outB(count).time) < 4
    count = count + 1;
end
starts(2) = count;
count = 1;
while length(outC(count).time) < 4
    count = count + 1;
end
starts(3) = count;
start = max(starts);

%plotting
count = 1;
for i = start:length(outA)
    figure(count)
    
    plot(outA(i).time, freqA{i}, 'bo')
    hold on
    plot(outA(i).time, outA(i).fitted, 'b')
    hold on
    
    plot(outB(i).time, freqB{i}, 'ro')
    hold on
    plot(outB(i).time, outB(i).fitted, 'r')
    hold on
    
    plot(outC(i).time, freqC{i}, 'ko')
    hold on
    plot(outC(i).time, outC(i).fitted, 'k')
    
    s = sprintf('Spike Adatation at %d pA', floor(outA(i).current));
    title(s)
    xlabel('Time (s)')
    ylabel('Frequency (spikes/sec)')
    count = count + 1;
end
end 
    