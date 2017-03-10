function [avg, time] = rmpVar(self)
%Calculates the variance in resting membrane potential

Fs = 1 / (self.ts{1}(2) - self.ts{1}(1));

if length(self.V) == 1
    if length(self.V{1}) <=  6*Fs*60
        time = 1:5;
        avg = [std(self.V{1}(2*Fs:9*Fs)), std(self.V{1}(60*Fs+2*Fs:Fs*60+9*Fs)), std(self.V{1}(2*Fs*60+2*Fs:2*Fs*60+9*Fs)), std(self.V{1}(3*Fs*60+2*Fs:3*Fs*60+9*Fs)), std(self.V{1}(4*Fs*60+2*Fs:4*Fs*60+9*Fs))];
    else
        time = 1:10;
        avg = [std(self.V{1}(2*Fs:9*Fs)), std(self.V{1}(60*Fs+2*Fs:Fs*60+9*Fs)), std(self.V{1}(2*Fs*60+2*Fs:2*Fs*60+9*Fs)), std(self.V{1}(3*Fs*60+2*Fs:3*Fs*60+9*Fs)), std(self.V{1}(4*Fs*60+2*Fs:4*Fs*60+9*Fs)), std(self.V{1}(5*Fs*60+2*Fs:5*Fs*60+9*Fs)), std(self.V{1}(6*Fs*60+2*Fs:6*Fs*60+9*Fs)), std(self.V{1}(7*Fs*60+2*Fs:7*Fs*60+9*Fs)), std(self.V{1}(8*Fs*60+2*Fs:8*Fs*60+9*Fs)), std(self.V{1}(9*Fs*60+2*Fs:9*Fs*60+9*Fs))];
    end
else
    avg = zeros(1,length(self.V));
    time = 10:10:10*length(self.V);
    for i = 1:length(avg)
        avg(i) = std(self.V{i}(2*Fs:9*Fs));
    end
end

avg = avg .^ 2;
    
end