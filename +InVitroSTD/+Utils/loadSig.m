function [ts signal] = loadSig(fname)

fid = fopen(fname);

fseek(fid, 0,1);
numSamples = ftell(fid) -3;
fseek(fid,0,-1);

% go past the header
for i = 1:3
    trash = fgetl(fid);
end

ts = zeros(numSamples,1);
signal = zeros(numSamples,1);


for i = 1:numSamples
    temp = fgetl(fid);
    breaks = strfind(temp, char(9));
    ts(i) = str2double(temp(1:breaks(1)-1));
    signal(i) = str2double(temp(breaks(1)+1:breaks(2)-1));
    if feof(fid)
        break
    end
end

ts = ts(1:i-1);
signal = signal(1:i-1);

