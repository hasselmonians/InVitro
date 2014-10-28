function toABF(fname,ts,samp)
% Take an arbitrary signal and time stamps and write an abf file to use as
% stimulus.
%
% Inputs: fname: File to write to (can include folder)
%         ts: Nx1 vector of timestamps (N = number of samples)
%         samp: Nx1 vector of current (picoAmps)
%
% Outputs: None, simply write the file.
%
% example: toABF('myABFs/sin.abf',0:.01:10,sin(0:.01:10));

% wchapman 2013.09.10

if length(ts) ~=length(samp)
    error('TS and samp must be the same length')
end

fs = 1/(ts(2)-ts(1));

% Add 343.7 ms of dead time (current = 0)
deadSpace = zeros(16129,1);
samp = [deadSpace;samp(:);deadSpace];
ts = 0:1:length(samp)-1;
ts = ts(:);
ts = ts/fs;

inds = strfind(fname, filesep);
d = fname(1:inds(end)-1);
mkdir(d);

fid = fopen(fname,'w');

fprintf(fid,'ATF\t1.0\r\n');
fprintf(fid,'0\t3\r\n');
fprintf(fid,'"Time (s)"\t"Amplitude (pA)"\tComment ()"\r\n');

for i=1:length(samp)
  fprintf(fid,'%8f\t%8f\t""\r\n',ts(i),samp(i));
end

fclose(fid);

end