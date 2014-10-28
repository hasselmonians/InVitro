function sinusoidInputs()
% Creates constant amplitude, constant frequency sinusoid inputs with a
% maximum of zero, for input into pclamp.

% wchapman 20130822

mkdir out2

freq = [2 4 8 12 16]; % each frequency (Hz)
amp = 25:25:250; % each amplitude (pA)

parfor i = 1:length(freq)
    for k = 1:length(amp)
        saveSin(['out2/sin_' num2str(freq(i)) 'Hz_' num2str(amp(k)) 'pA.abf'],freq(i),amp(k),20,20000);
    end
end


end

function [zapsig,t]=saveSin(fname, freq, amplitude, duration, samprate)
    t = 0:(1/samprate):duration;

    sig = -((amplitude/2)*sin(2*pi*t*freq)) - amplitude/2;

    fid = fopen(fname,'w');
    fprintf(fid,'ATF\t1.0\r\n');
    fprintf(fid,'0\t3\r\n');
    fprintf(fid,'"Time (s)"\t"Amplitude (pA)"\tComment ()"\r\n');
    for i=1:length(sig)
      fprintf(fid,'%8f\t%8f\t""\r\n',t(i),sig(i));
    end
    fclose(fid);
end