clear
close all
clc

% SPLINE
tic
xfine = 2:0.05:50;
y = myf(xfine);
yy = spline(xfine,y,xfine);
toc

% BSPLINE
tic
xfine = 2:0.05:50;
y = myf(xfine);
yyy = bspline(y);
toc

% CHEBFUN
tic
g = chebfun( @(t) myf(t),[2,50],'splitting','on');
toc 

plot(xfine,y,'b');
hold on;
plot(xfine,yy,'r');
plot(xfine,yy,'k');
plot(g,'g');
legend('reference','spline','bspline','cheb');