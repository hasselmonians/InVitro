function h=plotConfidenceInterval( x, y, conf, color, fade, ax)

x = x(:);
y = y(:);
conf = conf(:);
% Modified from Jason Climer, 13th November 2012

if ~exist('ax','var')
    ax = gca;
end

if ~exist('color','var')
    color = [0 0 1];
end

if ~exist('fade','var')
    fade = 0.3;
end

set(gcf,'CurrentAxes',ax);

temp = y-conf;
hold on;
h=plot(x,y,'Color',color*(1-fade),'LineWidth',1.5);

patch([x x(end:-1:1)],[y+conf temp(end:-1:1)],color,'FaceAlpha',fade,'EdgeColor',color,'EdgeAlpha',(1+fade)/2,'LineWidth',1);
patch([x x(end:-1:1)],[y-conf temp(end:-1:1)],color,'FaceAlpha',fade,'EdgeColor',color,'EdgeAlpha',(1+fade)/2,'LineWidth',1);
hold off;

end

