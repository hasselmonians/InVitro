function [counts,phi,wb,mrl mrAng uVal lVal field phi2] = mrlRose(data,phi,ifPlot,val)

%% Setup
if ~exist('phi','var'), phi = []; end
if isempty(phi), 
    phi = linspace(0,2*pi,14);
end

if ~exist('ifPlot','var'), ifPlot=[];end
if isempty(ifPlot)
    ifPlot=1;
end

if ~exist('val','var'), val = []; end
if isempty(val)
    val = 3;
end

%% Calculations
mrl = CMBHOME.Utils.circ.circ_r(data);
mrAng = CMBHOME.Utils.circ.circ_mean(data);

[counts wb] = histc(data,phi);
counts = counts(1:end-1);
wb(wb==max(wb)) = 1;
counts = smooth(counts,2);

% 30 percentile
[counts2] = histc(wrapTo2Pi(data-mrAng),phi);
counts2 = counts2(1:end-1);
counts2 = counts2 / max(counts2);
phi3 = diff(phi); phi3 = phi3(1); phi3 = 0:phi3/2:2*pi;
%counts2 = interp1(phi(1:end-1),counts2,phi3);
phi3 = phi;

field = (counts2 > val);
field = field(:);

field = [field;field];
[a b] = CMBHOME.Utils.OverThresholdDetect(field,1,3,1);
field = b(1:length(b)/2);

t = CMBHOME.Utils.SplitVec(field,'equal');
firsts = cellfun(@(c) c(1),t);
[~,notField] = max(cellfun(@(c) length(c), t(~firsts)));
temp = find(~firsts);
notField = temp(notField);
t2 = cellfun(@(c) ones(length(c),1),t,'UniformOutput',0);
try
    t2{notField} = zeros(length(t2{notField}),1);
    field = CMBHOME.Utils.ContinuizeEpochs(t2);
catch
    
end


phi2 = wrapTo2Pi(phi3+mrAng);
lVal = phi2(max(find(~field)));
uVal = phi2(min(find(~field)));

if isempty(lVal), lVal = NaN; end
if isempty(uVal), uVal = NaN; end

if ~((mrAng<uVal) & (mrAng>lVal))
    %t = uVal;
    %uVal = lVal;
    %lVal = t;
    1
end
field = double(field);
%% ifPlot
if ifPlot==1
   % rose
   %rose(data,phi)
   dv = counts(:)/max(counts);
   dv = [dv(:);dv(1)];
   ph = [phi(:)];
   h = polar(ph,dv);
   set(h,'LineWidth',3)
   hold on
   
   % ul & ll
   plot([0 cos(uVal)],[0 sin(uVal)],'g','LineWidth',3)
   plot([0 cos(lVal)],[0 sin(lVal)],'g','LineWidth',3)
   
   % mean resultant
   plot([0 mrl*cos(mrAng)],[0 mrl*sin(mrAng)],'r','LineWidth',3)
   
end

end