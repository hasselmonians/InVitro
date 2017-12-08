function [time,avg] = restingPotential(self)
%restingPotential() calculates the average resting potential in an InVitro 
%Recording object containing 10 sweeps of 60 seconds each
%
%Craig Kelley 10/13/16

Fs = 1 / (self.ts{1}(2) - self.ts{1}(1));

if length(self.V) == 1
    if length(self.V{1}) <= 6*Fs*60
        time = 1:5;
        avg = [mean(self.V{1}(1:Fs*60)), mean(self.V{1}(60*Fs+1:2*Fs*60)), mean(self.V{1}(2*Fs*60+1:3*Fs*60)), mean(self.V{1}(3*Fs*60+1:4*Fs*60))]%, mean(self.V{1}(4*Fs*60+1:5*Fs*60))];
    else
        time = 1:10;
        avg = [mean(self.V{1}(1:Fs*60)), mean(self.V{1}(60*Fs+1:2*Fs*60)), mean(self.V{1}(2*Fs*60+1:3*Fs*60)), mean(self.V{1}(3*Fs*60+1:4*Fs*60)), mean(self.V{1}(4*Fs*60+1:5*Fs*60)), mean(self.V{1}(5*Fs*60+1:6*Fs*60)), mean(self.V{1}(6*Fs*60+1:7*Fs*60)), mean(self.V{1}(7*Fs*60+1:8*Fs*60)), mean(self.V{1}(8*Fs*60+1:9*Fs*60)), mean(self.V{1}(9*Fs*60+1:end))];
    end
else
    avg = zeros(1,length(self.V));
    time = 10:10:10*length(self.V);

    for i = 1:length(avg)
        avg(i) = mean(self.V{i}(2*Fs:9*Fs));
    end
end

end