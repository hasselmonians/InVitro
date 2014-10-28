function plot(self)

    figure
    hold on
    for i = 1:length(self.ts)
        plot(self.ts{i},self.I{i},'g')
        plot(self.ts{i},self.V{i})
    end
    xlabel('Time (s)')
    ylabel('mV || pA')
    
end
