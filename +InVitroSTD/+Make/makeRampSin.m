function makeRampSin()
% A linearly increasing current with a superimposed sinusoid

% wchapman 20131001

% 4. Sinewaves on a ramp.  We decided to do 10 second rising ramp and 10
% seconds falling ramp with 5 seconds in between.  Do different frequencies
% on different ramps (possible 2,4,8,12,16 Hz).  Need different peak to
% trough amplitudes of sine wave (i.e. between -100 pA to -500 pA).


sinFreqs = [2 4 6 8 10 12 16 20];
sinAmps = 25:25:500;

slopes = (0:25:100)/10; %pA/s

folderName = ['/media/RatBrains/software/Library' filesep 'sinRamps'];
mkdir(folderName)


fs = 5000; %sampling frequency
t_sin = 0:1/fs:20; %each frequency of sin is 20 seconds


parfor i = 1:length(sinAmps)
    for k = 1:length(slopes)
        
        fname = [folderName filesep 'slope' num2str(slopes(k)) '_sinMag' num2str(sinAmps(i))];  
        dramp = (1/fs).*slopes(k).*ones(floor(length(t_sin)/2),1);
        dramp2 = -(1/fs).*slopes(k).*ones(ceil(length(t_sin)/2),1);
        dramp = [dramp ; dramp2];
        ramp = cumsum(dramp);
        
        deadSpace = zeros(fs*4,1);
        signal = deadSpace;
        
        for m = 1:length(sinFreqs)
            sinSig = -((sinAmps(i)/2)*sin(2*pi*t_sin*sinFreqs(m)-pi/2)) - sinAmps(i)/2; %Phase offset to start at 0 after shifts
            signal = [signal;sinSig(:) + ramp;deadSpace];
        end
        
        ts = cumsum(ones(length(signal),1) * (1/fs))-(1/fs);
        
        make.toABF(fname,ts,signal)
        
    end
end

end