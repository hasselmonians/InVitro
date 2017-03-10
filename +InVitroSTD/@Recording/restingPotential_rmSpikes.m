function [time,avg] = restingPotential_rmSpikes(self)
%restingPotential2() is an alternative method for calculating the average
%resting potential vs. time for InVitro Recording objects containing 1
%10 minute long sweep.
%
%Craig Kelley 10/13/16

%time = 1:10;
time = 1:5;
Fs = 1 / (self.ts{1}(2) - self.ts{1}(1));

V = removeSpikes(self);

avg = [mean(V(1:Fs*60)), mean(V(60*Fs+1:2*Fs*60)), mean(V(2*Fs*60+1:3*Fs*60)), mean(V(3*Fs*60+1:4*Fs*60)), mean(V(4*Fs*60+1:5*Fs*60))];%, mean(V(5*Fs*60+1:6*Fs*60)), mean(V(6*Fs*60+1:7*Fs*60)), mean(V(7*Fs*60+1:8*Fs*60)), mean(V(8*Fs*60+1:9*Fs*60)), mean(V(9*Fs*60+1:end))];