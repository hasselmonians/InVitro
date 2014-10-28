function  savefigs2(fv,rv,ifClose)
% This function allows you to quickly save all currently open figures with
% a custom filename for each in multiple formats.  To use the function
% simply call savefigs with no arguments, then follow the prompts
%
% Upon execution this function will one-by-one bring each currently open
% figure to the foreground.  Then it will supply a text prompt in the main
% console window asking you for a filename.  It will save that figure to
% that filename in the .fig, .emf, .png, and .eps formats.  
%
% The formats that it saves in can be changed by commenting out or adding
% lines below.
%
% Copyright 2010 Matthew Guidry 
% matt.guidry ATT gmail DOTT com  (Email reformatted for anti-spam)

mkdir(fv);

hfigs = get(0, 'children');                          %Get list of figures

for m = 1:length(hfigs)
    figure(hfigs(m))                                %Bring Figure to foreground
    nv = num2str(rv);
    if length(nv) == 1
        nv = ['0' '0' nv];
    elseif length(nv) == 2
        nv = ['0' nv];
    end
    
    mf = [fv '/' num2str(rv) '_' num2str(m)];
    filename = (mf); 
    if strcmp(filename, '0')                        %Skip figure when user types 0
        continue
    else
        set(hfigs(m),'PaperPositionMode','auto')
        %print(hfigs(m),'-depsc',mf)
        %saveas(hfigs(m), [filename '.jpg']) %Standard PNG graphics file (best for web)
        saveas(hfigs(m), [filename '.eps'],'epsc2') %Standard PNG graphics file (best for web)

    end
end

if ~exist('ifClose','var')
    ifClose=1;
end

if ifClose==1
    close all
end