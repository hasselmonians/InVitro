function [sigOut] = assymetricSinusoid(tIn,ratio)
    
    timesep = 1/5000;

    t1 = (-pi/2:timesep/ratio:pi/2);
    t2 = (t1(end):timesep*ratio:(3*pi/2));
    t = [t1 t2];

    sig = sin(t);
    sigt = wrapToPi(linspace(min(t1),max(t2),length(sig)));

    [sigt inds] = sort(sigt);
    sig = sig(inds);
    
    t2 = wrapToPi(tIn);
    
    sigOut = interp1(sigt,sig,t2);
    

end