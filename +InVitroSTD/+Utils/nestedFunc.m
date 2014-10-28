%% Setup
figure
bins = linspace(0,2*pi,20);
[nbx,wbx] = histc(x,bins);
[nby,wby] = histc(y,bins);


%% Main scatter
subplot(3,3,[2 3 5 6])
plot(sp.x{k,m},sp.y{k,m},'.','MarkerFaceColor','b')
xlim([0 2*pi]),ylim([0 2*pi])
vline([0 pi/2 pi 3*pi/2])
hline([0 pi/2 pi 3*pi/2])

yr = [min(bins(nby>(max(nby)/4))) max(bins(nby>(max(nby)/4)))];
patch([0 2*pi 2*pi 0],[yr(1) yr(1) yr(2) yr(2)],'b','FaceAlpha',0.2,'EdgeColor','b')

xr = [min(bins(nbx>(max(nbx)/4))) max(bins(nbx>(max(nbx)/4)))];
patch([xr(1) xr(1) xr(2) xr(2)],[0 2*pi 2*pi 0],'r','FaceAlpha',0.2,'EdgeColor','r')


%% Y marginal
subplot(3,3,[1 4])
plot(nby,bins)
ylim([0 2*pi])
hline([0 pi/2 pi 3*pi/2])
xl = get(gca,'xlim');
patch([xl(1) xl(2) xl(2) xl(1)],[yr(1) yr(1) yr(2) yr(2)],'b','FaceAlpha',0.2,'EdgeColor','b')

%% X marginal
subplot(3,3,[8 9])
plot(bins,nbx)
xlim([0 2*pi])
vline([0 pi/2 pi 3*pi/2])
yl = get(gca,'ylim');
patch([xr(1) xr(2) xr(2) xr(1)],[yl(1) yl(1) yl(2) yl(2)],'r','FaceAlpha',0.2,'EdgeColor','r')