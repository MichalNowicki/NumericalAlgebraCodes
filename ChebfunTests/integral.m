a = 1; b = 5;
integrand = chebfun2(@(x,y) x.*y.*cos(x.^2.*y+y),[0 b 0 a]);

zlim([-10 10])

ans = integral(integrand)  ;          % computed quantity
exact = -sin(1/2)^2 + sin(13)^2/26  ;

tic
f = chebfun2(@(x,y) sin(30*x.*y) + sin(10*y.*x.^2) + exp(-x.^2-(y-.8).^2));
[mn mnloc] = min2(f);
[mx mxloc] = max2(f);
toc
plot(f), hold on
plot3(mnloc(1),mnloc(2),mn,'.r','markersize',40)
plot3(mxloc(1),mxloc(2),mx,'.b','markersize',40)
zlim([-6 6]), hold off

x = -1:0.01:1;
y = -1:0.01:1;

z = zeros(201,201);
for i = 1 : length(x)
    z(i,:) = sin(30*x(i).*y) + sin(10*y.*x(i).^2) + exp(-x(i).^2-(y-.8).^2);
end;
figure
surf(x,y,z);
axis([-1 1 -1 1 -6 6]);