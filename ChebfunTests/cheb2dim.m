clear
close all
clc


tic
x = 2:0.05:50;
y = 2:0.05:50;
z = myf2(x,y);
yy = spline(x,y,xfine);
toc


tic
xfine = 2:0.05:50;
y = myf(xfine);
yyy = bspline(y);
toc


tic
g = chebfun( @(t) myf(t),[2,50],'splitting','on');
toc 

plot(xfine,y,'b');
hold on;
plot(xfine,yy,'r');
plot(xfine,yy,'k');
plot(g,'g');
legend('reference','spline','bspline','cheb');