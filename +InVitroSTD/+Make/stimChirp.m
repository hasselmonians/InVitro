function [t sig] = stimChirp(template,templateTS,templatePoint,freqStart,freqEnd,tEnd)
% Given a template input, will generate a chirp like function, starting at
% a given repetitions of the template per second, and ending at another
% number of repetitions per second. 

% wchapman 2013.09.11

tStep = templateTS(2) - templateTS(1);
t = (0:tStep:tEnd)';
cf = chirp(t,freqStart,t(end),freqEnd);
[~,trigs] = findpeaks(cf); % These are the points where we wtn templatePoint

sig = zeros(length(t),1);

for i = 1:length(trigs)
    sp = trigs(i)-templatePoint; %start a template at this point
    lv = length(t) - (sp+length(templateTS)-1);
    if lv >=0
        sig(sp:sp+length(templateTS)-1) = sig(sp:sp+length(templateTS)-1) + template;
    else
       sig(sp:sp+length(templateTS)-1+lv) = sig(sp:sp+length(templateTS)-1+lv) + template(1:end+lv);
    end
end

end

