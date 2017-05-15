function [out, freq] = spikeAdaptation(di,varargin)
%spikeAdaptation() calculates spike frequency as a function of time and fits an
%exponential for each sweep contained in the Recording object di.  freq is
%a cell array whose length is the number of sweeps in di with each cell
%containing a vector of spiking frequencies.  out is a structure containing all
%other relevant output data, such as time, current intensity, and the
%values of the expopnential fit. An estimate of the spike detection
%threshold is an optional argument, and should be included for recordings
%in which spikes have a maximum membrane potential < 0.
%
%Input Variables:
%    di: An InVitro Recording object.
%    varargin: Estimate of spike threshold
%
%Usage: 
%    >> [out, freq] = spikeAdatation(d.Recording(3));
%    >> [out, freq] = d.Recording(3).spikeAdaptation;
%    >> [out, freq] = spikeAdaptation(d.Recording(3), -15);
%
%Craig Kelley 10/12/16

%% Find Spikes and initialize output variables
if ~isempty(varargin)  
    if length(varargin) > 1
        [timeInd, ~] = findSpikes(di,varargin{1},varargin{2});
    else
        [timeInd, ~] = findSpikes(di, varargin{1});
    end
else
    [timeInd, ~] = di.findSpikes;
end

freq = cell(1,length(timeInd));
out = struct();

%% Determine onset and offset of current step
y = di.V{1}; %local voltage
x = di.I{1}; %local current
nx = x - nanmean(x(1:1000));
depol = nanmean(nx(abs(nx)>2));
Fs = 1 / (di.ts{1}(2) - di.ts{1}(1));

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

%% Calculate spike frequencies in each sweep
for i = 1:length(freq)
    if ~isempty(timeInd{i})
        if length(timeInd{i}) == 1
            freq{i} = 1;
        elseif length(timeInd{i}) == 2
            freq{i} = 1 / (timeInd{i}(2) - timeInd{i}(1));
        else
            freq{i} = zeros(1,length(timeInd{i})-1);
            for j = 1:length(timeInd{i})-1
                freq{i}(j) = 1 / ((timeInd{i}(j+1) - timeInd{i}(j))/Fs);
            end
        end
    end
end

%% For each sweep containing spikes, populate the out
count = 1;
for i = 1:length(timeInd)
    if ~isempty(timeInd{i}) && length(timeInd{i}) > 3
        %determine times for each frequency 
        out(i).time = zeros(1,length(timeInd{i})-1);
        for j = 1:length(out(i).time)
            out(i).time(j) = mean([di.ts{i}(timeInd{i}(j)), di.ts{i}(timeInd{i}(j+1))]);
        end        
        out(i).time = out(i).time - di.ts{i}(on);
        
        %exponential fit
        out(i).s = exp2fit(out(i).time, freq{i}, 1);
        out(i).fitted = out(i).s(1) + out(i).s(2) * exp(-out(i).time / out(i).s(3));
        
        %determine intensity of current injection
        di.I{i} = di.I{i} - mean(di.I{i}(1:1000));
        out(i).current = mean(di.I{i}(on:off));
        count = count + 1;
        
    elseif ~isempty(timeInd{i})
        out(i).time = [];
        out(i).s = [];
        out(i).fitted = [];
        out(i).current = [];
        fprintf('Too few spikes in sweep %i for curve fitting\n', i)
        
    else
        out(i).time = [];
        out(i).s = [];
        out(i).fitted = [];
        out(i).current = [];
        fprintf('There are no spikes detected in sweep %i\n', i)
    end
end